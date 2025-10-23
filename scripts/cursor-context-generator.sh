#!/bin/bash
# Cursor Context Generator - Creates formatted context for Cursor AI sessions
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

# Function to get file structure
get_file_structure() {
    echo "**Key Project Files:**"
    echo "- \`src/layouts/BaseLayout.astro\` - Main layout component"
    echo "- \`src/pages/index.astro\` - Homepage"
    echo "- \`src/data/teardowns/\` - Teardown content directory"
    echo "- \`src/components/\` - Reusable components"
    echo "- \`src/styles/global.css\` - Global styles"
    echo "- \`astro.config.mjs\` - Astro configuration"
    echo "- \`package.json\` - Dependencies and scripts"
}

# Function to get build status
get_build_status() {
    echo "**Build Status:**"
    
    # Check if node_modules exists
    if [ -d "node_modules" ]; then
        echo "- Dependencies: Installed"
    else
        echo "- Dependencies: Not installed (run \`npm install\`)"
    fi
    
    # Check for build errors
    if [ -d ".astro" ]; then
        echo "- Astro cache: Present"
    else
        echo "- Astro cache: Not found"
    fi
    
    # Check for dist directory
    if [ -d "dist" ]; then
        echo "- Build output: Present"
    else
        echo "- Build output: Not found (run \`npm run build\`)"
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

**PROJECT STRUCTURE:**
$(get_file_structure)

**BUILD STATUS:**
$(get_build_status)

**TECHNICAL STACK:**
- Astro 5 with Content Layer API
- Material You 3 design system
- Obsidian integration via sync scripts
- Git workflow with automated Obsidian updates

**CURRENT TASK:**
[Describe what you need Cursor AI to help with - code fixes, file operations, git management, component creation, etc.]

**RECENT CHANGES:**
- [What was just accomplished]
- [What files were modified]
- [Current git status]

**HANDOFF NOTES FOR CLAUDE:**
- [Strategic decisions needed]
- [Content creation tasks]
- [Design system work]
- [Architecture decisions]

**CONTEXT FILES:**
- Last Change Summary: $CONTEXT_DIR/last-change-summary.md
- Next AI Context: $CONTEXT_DIR/next-ai-context.md
- Current State: $CONTEXT_DIR/current-state.json

**QUICK COMMANDS:**
- \`npm run dev\` - Start development server
- \`npm run build\` - Build for production
- \`./scripts/commit-with-session.sh\` - Commit with session tracking
- \`./scripts/session-manager.sh status\` - Check session status

---
*Use this context when starting a new Cursor AI conversation*
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
    local output_file="$CONTEXT_DIR/cursor-context-$(date +%Y%m%d-%H%M%S).md"
    
    echo "$content" > "$output_file"
    echo -e "${GREEN}✓${NC} Context saved to: $output_file"
}

# Main script logic
case "$1" in
    "clipboard"|"copy")
        echo -e "${BLUE}Generating Cursor context...${NC}"
        local context=$(generate_context_prompt)
        copy_to_clipboard "$context"
        ;;
    "file"|"save")
        echo -e "${BLUE}Generating Cursor context...${NC}"
        local context=$(generate_context_prompt)
        save_to_file "$context"
        ;;
    "both")
        echo -e "${BLUE}Generating Cursor context...${NC}"
        local context=$(generate_context_prompt)
        copy_to_clipboard "$context"
        save_to_file "$context"
        ;;
    "show"|"display")
        echo -e "${BLUE}Cursor Context:${NC}"
        echo ""
        generate_context_prompt
        ;;
    *)
        echo -e "${BLUE}Cursor Context Generator${NC}"
        echo ""
        echo "Usage:"
        echo "  $0 clipboard    - Generate and copy to clipboard"
        echo "  $0 file         - Generate and save to file"
        echo "  $0 both         - Generate, copy to clipboard, and save to file"
        echo "  $0 show         - Display context (not copied)"
        echo ""
        echo "Examples:"
        echo "  $0 clipboard    - Quick copy for new Cursor chat"
        echo "  $0 both         - Full context generation"
        echo ""
        echo "Default action: clipboard"
        echo ""
        
        # Default to clipboard
        echo -e "${BLUE}Generating Cursor context...${NC}"
        local context=$(generate_context_prompt)
        copy_to_clipboard "$context"
        ;;
esac
