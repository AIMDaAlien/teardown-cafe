#!/bin/bash
# Claude Context Generator - Creates formatted context for Claude AI sessions
# Reads session history and generates handoff context

set -e

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
PROJECT_ROOT="/Users/aim/Documents/teardown-cafe"
OBSIDIAN_VAULT="/Users/aim/Documents/Obsidian Notes Vault"
OBSIDIAN_SESSIONS="$OBSIDIAN_VAULT/Teardown Cafe/Sessions"
CONTEXT_DIR="$PROJECT_ROOT/.context"

# Function to get recent session info
get_recent_sessions() {
    local count="${1:-3}"
    find "$OBSIDIAN_SESSIONS" -name "*-session.md" -type f | sort -r | head -n "$count"
}

# Function to extract session summary
extract_session_summary() {
    local session_file="$1"
    local session_name=$(basename "$session_file" .md)
    local ai_type=$(echo "$session_name" | sed 's/.*-\([^-]*\)-session$/\1/')
    local session_date=$(echo "$session_name" | cut -d'-' -f1-3)
    local session_time=$(echo "$session_name" | cut -d'-' -f4-5)
    
    echo "**$session_date $session_time** - $ai_type session"
    
    # Extract key info from session file
    if [ -f "$session_file" ]; then
        # Get session goal
        local goal=$(grep -A 1 "## Session Goal" "$session_file" | tail -1 | sed 's/^\*\[\(.*\)\]$/\1/' | sed 's/^\[\(.*\)\]$/\1/')
        if [ -n "$goal" ] && [ "$goal" != "*[Describe what you plan to accomplish in this session]*" ]; then
            echo "  Goal: $goal"
        fi
        
        # Get changes made
        local changes=$(grep -A 10 "## Changes Made" "$session_file" | grep -v "## Changes Made" | head -5 | sed 's/^[[:space:]]*- //' | grep -v "^$")
        if [ -n "$changes" ]; then
            echo "  Changes: $changes"
        fi
        
        # Get handoff notes
        local handoff=$(grep -A 5 "## Handoff Notes" "$session_file" | grep -v "## Handoff Notes" | head -3 | sed 's/^[[:space:]]*- //' | grep -v "^$")
        if [ -n "$handoff" ]; then
            echo "  Handoff: $handoff"
        fi
    fi
}

# Function to get current project state
get_project_state() {
    echo "**Current Project State:**"
    echo "- Git Branch: $(git branch --show-current)"
    echo "- Git Commit: \`$(git rev-parse HEAD)\`"
    echo "- Modified Files: $(git status --porcelain | wc -l | tr -d ' ') files"
    
    if [ -f "$CONTEXT_DIR/current-state.json" ]; then
        echo "- Last Updated: $(jq -r '.project_state.last_updated' "$CONTEXT_DIR/current-state.json")"
    fi
}

# Function to get recent changes
get_recent_changes() {
    echo "**Recent Git Changes:**"
    git log --oneline -5 | while read -r line; do
        echo "- $line"
    done
}

# Function to get pending items
get_pending_items() {
    echo "**Pending Items:**"
    
    # Check for TODO comments in code
    local todos=$(grep -r "TODO\|FIXME" src/ 2>/dev/null | wc -l | tr -d ' ')
    if [ "$todos" -gt 0 ]; then
        echo "- $todos TODO/FIXME comments in code"
    fi
    
    # Check for uncommitted changes
    local uncommitted=$(git status --porcelain | wc -l | tr -d ' ')
    if [ "$uncommitted" -gt 0 ]; then
        echo "- $uncommitted uncommitted changes"
    fi
    
    # Check for untracked files
    local untracked=$(git status --porcelain | grep "^??" | wc -l | tr -d ' ')
    if [ "$untracked" -gt 0 ]; then
        echo "- $untracked untracked files"
    fi
    
    # Check for merge conflicts
    if git status | grep -q "both modified"; then
        echo "- Merge conflicts detected"
    fi
}

# Function to generate context prompt
generate_context_prompt() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    cat << EOF
---
**PROJECT CONTEXT - Teardown Cafe**
*Generated: $timestamp*

**CURRENT STATE:**
$(get_project_state)

**RECENT SESSIONS:**
$(for session in $(get_recent_sessions 3); do
    extract_session_summary "$session"
    echo ""
done)

**RECENT CHANGES:**
$(get_recent_changes)

**PENDING ITEMS:**
$(get_pending_items)

**TECHNICAL STACK:**
- Astro 5 with Content Layer API
- Material You 3 design system
- Obsidian integration via sync scripts
- Git workflow with automated Obsidian updates

**MCP TOOLS AVAILABLE:**
- Docker (Obsidian interaction)
- Context7 (libraries/frameworks)
- Figma Dev Mode (design)
- GitHub, Filesystem, PDF tools

**CURRENT TASK:**
[Describe what you need Claude to help with - strategic decisions, content creation, design system work, etc.]

**HANDOFF NOTES FOR CURSOR:**
- [Code fixes needed]
- [File operations required]
- [Git management tasks]
- [Component creation needs]

**CONTEXT FILES:**
- Last Change Summary: $CONTEXT_DIR/last-change-summary.md
- Next AI Context: $CONTEXT_DIR/next-ai-context.md
- Current State: $CONTEXT_DIR/current-state.json

---
*Use this context when starting a new Claude conversation*
EOF
}

# Function to copy to clipboard
copy_to_clipboard() {
    local content="$1"
    
    # Try different clipboard commands
    if command -v pbcopy >/dev/null 2>&1; then
        echo "$content" | pbcopy
        echo -e "${GREEN}✓${NC} Context copied to clipboard (pbcopy)"
    elif command -v xclip >/dev/null 2>&1; then
        echo "$content" | xclip -selection clipboard
        echo -e "${GREEN}✓${NC} Context copied to clipboard (xclip)"
    elif command -v wl-copy >/dev/null 2>&1; then
        echo "$content" | wl-copy
        echo -e "${GREEN}✓${NC} Context copied to clipboard (wl-copy)"
    else
        echo -e "${YELLOW}Warning: No clipboard utility found${NC}"
        echo "Context generated but not copied to clipboard"
        return 1
    fi
}

# Function to save to file
save_to_file() {
    local content="$1"
    local output_file="$CONTEXT_DIR/claude-context-$(date +%Y%m%d-%H%M%S).md"
    
    echo "$content" > "$output_file"
    echo -e "${GREEN}✓${NC} Context saved to: $output_file"
}

# Main script logic
case "$1" in
    "clipboard"|"copy")
        echo -e "${BLUE}Generating Claude context...${NC}"
        local context=$(generate_context_prompt)
        copy_to_clipboard "$context"
        ;;
    "file"|"save")
        echo -e "${BLUE}Generating Claude context...${NC}"
        local context=$(generate_context_prompt)
        save_to_file "$context"
        ;;
    "both")
        echo -e "${BLUE}Generating Claude context...${NC}"
        local context=$(generate_context_prompt)
        copy_to_clipboard "$context"
        save_to_file "$context"
        ;;
    "show"|"display")
        echo -e "${BLUE}Claude Context:${NC}"
        echo ""
        generate_context_prompt
        ;;
    *)
        echo -e "${BLUE}Claude Context Generator${NC}"
        echo ""
        echo "Usage:"
        echo "  $0 clipboard    - Generate and copy to clipboard"
        echo "  $0 file         - Generate and save to file"
        echo "  $0 both         - Generate, copy to clipboard, and save to file"
        echo "  $0 show         - Display context (not copied)"
        echo ""
        echo "Examples:"
        echo "  $0 clipboard    - Quick copy for new Claude chat"
        echo "  $0 both         - Full context generation"
        echo ""
        echo "Default action: clipboard"
        echo ""
        
        # Default to clipboard
        echo -e "${BLUE}Generating Claude context...${NC}"
        local context=$(generate_context_prompt)
        copy_to_clipboard "$context"
        ;;
esac
