#!/bin/bash
# Commit with Session - Automated commit workflow with Obsidian sync
# Integrates with session-manager.sh for complete session tracking

set -e

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
PROJECT_ROOT="/Users/aim/Documents/teardown-cafe"
CONTEXT_DIR="$PROJECT_ROOT/.context"
SESSION_STATE="$CONTEXT_DIR/session-state.json"

# Function to check if session is active
check_active_session() {
    if [ ! -f "$SESSION_STATE" ]; then
        echo -e "${YELLOW}No active session found.${NC}"
        echo "Starting a new session automatically..."
        
        # Auto-detect AI type based on environment or prompt user
        local ai_type="cursor"
        if [ -n "$CLAUDE_SESSION" ]; then
            ai_type="claude"
        fi
        
        echo "Auto-starting $ai_type session..."
        "$PROJECT_ROOT/scripts/session-manager.sh" start "$ai_type"
    fi
}

# Function to capture git diff for session note
capture_git_diff() {
    local session_file="$1"
    local diff_output=""
    
    # Get file changes
    local changed_files=$(git status --porcelain)
    if [ -n "$changed_files" ]; then
        diff_output="## Git Changes\n\n"
        diff_output+="**Files Changed:**\n"
        echo "$changed_files" | while read -r line; do
            local status=$(echo "$line" | cut -c1-2)
            local file=$(echo "$line" | cut -c4-)
            case "$status" in
                "M ") diff_output+="- Modified: \`$file\`\n" ;;
                "A ") diff_output+="- Added: \`$file\`\n" ;;
                "D ") diff_output+="- Deleted: \`$file\`\n" ;;
                "R ") diff_output+="- Renamed: \`$file\`\n" ;;
                "??") diff_output+="- Untracked: \`$file\`\n" ;;
            esac
        done
        
        # Add diff summary
        diff_output+="\n**Diff Summary:**\n"
        diff_output+="\`\`\`\n"
        diff_output+="$(git diff --stat)\n"
        diff_output+="\`\`\`\n"
        
        # Add detailed diff for important files
        diff_output+="\n**Detailed Changes:**\n"
        echo "$changed_files" | while read -r line; do
            local file=$(echo "$line" | cut -c4-)
            if [[ "$file" =~ \.(js|ts|astro|css|md|json)$ ]]; then
                diff_output+="\n**$file:**\n"
                diff_output+="\`\`\`diff\n"
                diff_output+="$(git diff --no-color "$file" 2>/dev/null || echo "Binary file or no changes")\n"
                diff_output+="\`\`\`\n"
            fi
        done
    else
        diff_output="**No changes detected.**\n"
    fi
    
    echo "$diff_output"
}

# Function to update session note with commit info
update_session_note() {
    local session_file="$1"
    local commit_message="$2"
    local commit_hash="$3"
    local timestamp=$(date "+%I:%M %p")
    
    # Append to session note
    cat >> "$session_file" << EOF

## Commit: $commit_message
**Time:** $timestamp  
**Hash:** \`$commit_hash\`  
**Files:** $(git status --porcelain | wc -l | tr -d ' ') files changed  

$(capture_git_diff "$session_file")

---
EOF
}

# Function to prompt for commit message
get_commit_message() {
    local default_message="$1"
    
    if [ -n "$default_message" ]; then
        echo "$default_message"
        return
    fi
    
    # Try to get commit message from git commit template or prompt user
    if [ -f "$PROJECT_ROOT/.gitmessage" ]; then
        echo "Using git commit template..."
        cat "$PROJECT_ROOT/.gitmessage"
    else
        echo -e "${YELLOW}Enter commit message:${NC}"
        read -r commit_message
        echo "$commit_message"
    fi
}

# Function to run pre-commit checks
run_pre_commit_checks() {
    echo -e "${BLUE}Running pre-commit checks...${NC}"
    
    # Check for common issues
    local issues=0
    
    # Check for console.log statements
    if git diff --cached --name-only | grep -E '\.(js|ts|astro)$' | xargs grep -l "console\.log" 2>/dev/null; then
        echo -e "${YELLOW}Warning: Found console.log statements${NC}"
        ((issues++))
    fi
    
    # Check for TODO comments
    if git diff --cached --name-only | grep -E '\.(js|ts|astro|css)$' | xargs grep -l "TODO\|FIXME" 2>/dev/null; then
        echo -e "${YELLOW}Info: Found TODO/FIXME comments${NC}"
    fi
    
    # Check file sizes
    local large_files=$(git diff --cached --name-only | xargs ls -la 2>/dev/null | awk '$5 > 1000000 {print $9 " (" $5 " bytes)"}')
    if [ -n "$large_files" ]; then
        echo -e "${YELLOW}Warning: Large files detected:${NC}"
        echo "$large_files"
        ((issues++))
    fi
    
    if [ $issues -gt 0 ]; then
        echo -e "${YELLOW}Pre-commit checks found $issues issue(s). Continue? (y/N)${NC}"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo -e "${RED}Commit cancelled.${NC}"
            exit 1
        fi
    fi
    
    echo -e "${GREEN}✓${NC} Pre-commit checks passed"
}

# Function to commit with session integration
commit_with_session() {
    local ai_type="$1"
    local commit_message="$2"
    
    echo -e "${BLUE}Committing with session integration...${NC}"
    
    # Check for active session
    check_active_session
    
    # Get session info
    local session_id=$(jq -r '.session_id' "$SESSION_STATE")
    local session_file=$(jq -r '.session_file' "$SESSION_STATE")
    
    echo "Session: $session_id"
    echo "Files to commit: $(git status --porcelain | wc -l | tr -d ' ') files"
    
    # Run pre-commit checks
    run_pre_commit_checks
    
    # Stage all changes
    echo -e "${BLUE}Staging changes...${NC}"
    git add -A
    
    # Get commit message
    local final_message=$(get_commit_message "$commit_message")
    
    # Commit changes
    echo -e "${BLUE}Committing changes...${NC}"
    local commit_hash=$(git commit -m "$final_message" | grep -o 'commit [a-f0-9]*' | cut -d' ' -f2)
    
    echo -e "${GREEN}✓${NC} Committed: $commit_hash"
    
    # Update session note
    update_session_note "$session_file" "$final_message" "$commit_hash"
    
    # Run Obsidian sync
    echo -e "${BLUE}Syncing to Obsidian...${NC}"
    if [ -f "$PROJECT_ROOT/sync-to-obsidian.sh" ]; then
        "$PROJECT_ROOT/sync-to-obsidian.sh"
    else
        echo -e "${YELLOW}Warning: sync-to-obsidian.sh not found${NC}"
    fi
    
    # Update session index
    "$PROJECT_ROOT/scripts/session-manager.sh" status > /dev/null 2>&1 || true
    
    echo -e "${GREEN}✓${NC} Session note updated"
    echo -e "${GREEN}✓${NC} Obsidian sync completed"
    
    # Show commit summary
    echo ""
    echo -e "${BLUE}Commit Summary:${NC}"
    echo "  Hash: $commit_hash"
    echo "  Message: $final_message"
    echo "  Files: $(git show --stat --format="" "$commit_hash" | tail -1)"
    echo "  Session: $session_id"
}

# Function to show help
show_help() {
    echo -e "${BLUE}Commit with Session - Automated commit workflow${NC}"
    echo ""
    echo "Usage:"
    echo "  $0 [ai_type] [commit_message]"
    echo ""
    echo "Arguments:"
    echo "  ai_type        - 'claude' or 'cursor' (auto-detected if not provided)"
    echo "  commit_message - Commit message (prompted if not provided)"
    echo ""
    echo "Examples:"
    echo "  $0 cursor \"Fixed Material You color tokens\""
    echo "  $0 claude \"Added new teardown content\""
    echo "  $0 \"Quick bug fix\""
    echo ""
    echo "Features:"
    echo "  - Automatic session detection"
    echo "  - Pre-commit checks"
    echo "  - Session note updates"
    echo "  - Obsidian sync integration"
    echo "  - Git diff capture"
}

# Main script logic
case "$1" in
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        # Auto-detect AI type or use provided
        ai_type="$1"
        commit_message="$2"
        
        # If first arg looks like a commit message, treat as message
        if [ -n "$1" ] && [[ ! "$1" =~ ^(claude|cursor)$ ]]; then
            commit_message="$1"
            ai_type=""
        fi
        
        # Auto-detect AI type if not provided
        if [ -z "$ai_type" ]; then
            if [ -n "$CLAUDE_SESSION" ]; then
                ai_type="claude"
            else
                ai_type="cursor"
            fi
        fi
        
        commit_with_session "$ai_type" "$commit_message"
        ;;
esac
