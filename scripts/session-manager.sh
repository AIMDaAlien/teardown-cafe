#!/bin/bash
# Session Manager for Claude-Cursor-Obsidian Workflow
# Manages AI session tracking with git state capture and Obsidian integration

set -e

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
PROJECT_ROOT="/Users/aim/Documents/teardown-cafe"
OBSIDIAN_VAULT="/Users/aim/Documents/Obsidian Notes Vault"
OBSIDIAN_SESSIONS="$OBSIDIAN_VAULT/Teardown Cafe/Sessions"
CONTEXT_DIR="$PROJECT_ROOT/.context"
SESSION_STATE="$CONTEXT_DIR/session-state.json"

# Ensure directories exist
mkdir -p "$OBSIDIAN_SESSIONS"
mkdir -p "$CONTEXT_DIR"

# Function to get current timestamp
get_timestamp() {
    date "+%Y-%m-%d-%H%M"
}

# Function to get current time for duration calculation
get_current_time() {
    date "+%s"
}

# Function to start a new session
start_session() {
    local ai_type="$1"
    local session_id="$(get_timestamp)-${ai_type}-session"
    local session_file="$OBSIDIAN_SESSIONS/${session_id}.md"
    local start_time=$(get_current_time)
    
    echo -e "${BLUE}Starting ${ai_type} session...${NC}"
    echo "Session ID: $session_id"
    
    # Capture initial git state
    local git_status=$(git status --porcelain | sed 's/"/\\"/g' | tr '\n' ' ')
    local git_branch=$(git branch --show-current)
    local git_commit=$(git rev-parse HEAD)
    
    # Create session state file
    cat > "$SESSION_STATE" << EOF
{
    "session_id": "$session_id",
    "ai_type": "$ai_type",
    "start_time": $start_time,
    "start_git_commit": "$git_commit",
    "start_git_branch": "$git_branch",
    "start_git_status": "$git_status",
    "session_file": "$session_file"
}
EOF
    
    # Create session note
    local ai_type_cap=$(echo "$ai_type" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
    cat > "$session_file" << EOF
# ${ai_type_cap} Session - $(date "+%B %d, %Y at %I:%M %p")

**Session ID:** \`$session_id\`  
**AI Type:** $ai_type  
**Start Time:** $(date "+%I:%M %p")  
**Git Branch:** $git_branch  
**Git Commit:** \`$git_commit\`  

## Session Goal
*[Describe what you plan to accomplish in this session]*

## Initial State
**Git Status:**
\`\`\`
$git_status
\`\`\`

**Files to Work On:**
*[List files you plan to modify]*

## Session Log
- **$(date "+%I:%M %p")**: Session started
- *[Add entries as you work]*

## Changes Made
*[Will be auto-populated on commit]*

## Handoff Notes
*[Add notes for the next AI session]*

---
*Session started at $(date "+%I:%M %p")*
EOF
    
    echo -e "${GREEN}✓${NC} Session started: $session_id"
    echo -e "${GREEN}✓${NC} Session note created: $session_file"
    echo -e "${BLUE}Session state saved to: $SESSION_STATE${NC}"
    
    # Update session index
    update_session_index
}

# Function to end a session
end_session() {
    if [ ! -f "$SESSION_STATE" ]; then
        echo -e "${RED}No active session found.${NC}"
        exit 1
    fi
    
    local session_id=$(jq -r '.session_id' "$SESSION_STATE")
    local ai_type=$(jq -r '.ai_type' "$SESSION_STATE")
    local start_time=$(jq -r '.start_time' "$SESSION_STATE")
    local session_file=$(jq -r '.session_file' "$SESSION_STATE")
    local end_time=$(get_current_time)
    local duration=$((end_time - start_time))
    local duration_minutes=$((duration / 60))
    
    echo -e "${BLUE}Ending ${ai_type} session...${NC}"
    echo "Session ID: $session_id"
    echo "Duration: ${duration_minutes} minutes"
    
    # Capture final git state
    local final_git_status=$(git status --porcelain)
    local final_git_commit=$(git rev-parse HEAD)
    local git_diff=""
    
    if [ "$final_git_status" != "" ]; then
        git_diff=$(git diff --stat)
    fi
    
    # Update session note with end time and summary
    cat >> "$session_file" << EOF

## Session Summary
**End Time:** $(date "+%I:%M %p")  
**Duration:** ${duration_minutes} minutes  
**Final Git Status:**
\`\`\`
$final_git_status
\`\`\`

**Changes Summary:**
\`\`\`
$git_diff
\`\`\`

---
*Session ended at $(date "+%I:%M %p")*
EOF
    
    # Create context files for handoff
    create_handoff_context "$session_id" "$ai_type" "$duration_minutes"
    
    # Clean up session state
    rm -f "$SESSION_STATE"
    
    echo -e "${GREEN}✓${NC} Session ended: $session_id"
    echo -e "${BLUE}Session note updated: $session_file${NC}"
}

# Function to create handoff context
create_handoff_context() {
    local session_id="$1"
    local ai_type="$2"
    local duration="$3"
    local timestamp=$(get_timestamp)
    
    # Create last change summary
    cat > "$CONTEXT_DIR/last-change-summary.md" << EOF
# Last Change Summary

**Session:** $session_id  
**AI:** $ai_type  
**Duration:** ${duration} minutes  
**Timestamp:** $(date "+%Y-%m-%d %H:%M:%S")  

## Git Changes
\`\`\`
$(git status --porcelain)
\`\`\`

## Diff Summary
\`\`\`
$(git diff --stat)
\`\`\`

## Files Modified
$(git status --porcelain | awk '{print "- " $2}' | grep -v "^$")

---
*Generated at $(date "+%I:%M %p")*
EOF
    
    # Create next AI context
    local next_ai="claude"
    if [ "$ai_type" = "claude" ]; then
        next_ai="cursor"
    fi
    
    local next_ai_cap=$(echo "$next_ai" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
    cat > "$CONTEXT_DIR/next-ai-context.md" << EOF
# Handoff to ${next_ai_cap}

**From:** $ai_type session  
**Session ID:** $session_id  
**Handoff Time:** $(date "+%Y-%m-%d %H:%M:%S")  

## Current Project State
**Git Branch:** $(git branch --show-current)  
**Git Commit:** \`$(git rev-parse HEAD)\`  
**Modified Files:** $(git status --porcelain | wc -l | tr -d ' ') files  

## Recent Changes
$(git log --oneline -5)

## Pending Items
*[Add any pending tasks or decisions]*

## Context for ${next_ai_cap}
*[Add specific context for the next AI session]*

---
*Handoff created at $(date "+%I:%M %p")*
EOF
    
    # Create current state JSON
    cat > "$CONTEXT_DIR/current-state.json" << EOF
{
    "last_session": {
        "id": "$session_id",
        "ai_type": "$ai_type",
        "duration_minutes": $duration,
        "timestamp": "$(date "+%Y-%m-%d %H:%M:%S")"
    },
    "git_state": {
        "branch": "$(git branch --show-current)",
        "commit": "$(git rev-parse HEAD)",
        "modified_files": $(git status --porcelain | wc -l | tr -d ' '),
        "status": "$(git status --porcelain)"
    },
    "project_state": {
        "last_updated": "$(date "+%Y-%m-%d %H:%M:%S")",
        "context_dir": "$CONTEXT_DIR"
    }
}
EOF
    
    echo -e "${GREEN}✓${NC} Handoff context created"
}

# Function to update session index
update_session_index() {
    local index_file="$OBSIDIAN_VAULT/Teardown Cafe/Session Index.md"
    
    # Create or update session index
    cat > "$index_file" << EOF
# 📊 Session Index

> **Auto-generated index of all AI collaboration sessions**

## Recent Sessions

EOF
    
    # Add recent sessions (last 10)
    find "$OBSIDIAN_SESSIONS" -name "*-session.md" -type f | sort -r | head -10 | while read -r session_file; do
        local session_name=$(basename "$session_file" .md)
        local session_date=$(echo "$session_name" | cut -d'-' -f1-3)
        local session_time=$(echo "$session_name" | cut -d'-' -f4-5)
        local ai_type=$(echo "$session_name" | sed 's/.*-\([^-]*\)-session$/\1/')
        
        echo "- **$session_date $session_time** - [$ai_type session]($session_file)" >> "$index_file"
    done
    
    cat >> "$index_file" << EOF

## Session Statistics

| Metric | Value |
|--------|-------|
| Total Sessions | $(find "$OBSIDIAN_SESSIONS" -name "*-session.md" | wc -l | tr -d ' ') |
| Claude Sessions | $(find "$OBSIDIAN_SESSIONS" -name "*-claude-session.md" | wc -l | tr -d ' ') |
| Cursor Sessions | $(find "$OBSIDIAN_SESSIONS" -name "*-cursor-session.md" | wc -l | tr -d ' ') |
| Last Updated | $(date "+%B %d, %Y at %I:%M %p") |

## Quick Actions

- [[Workflow Dashboard]] - Current project status
- [[claude-cursor-collaboration-prompt]] - Handoff prompts
- [[simple-workflow-guide]] - Usage guide

---
*Auto-generated at $(date "+%I:%M %p")*
EOF
    
    echo -e "${GREEN}✓${NC} Session index updated"
}

# Function to show current session status
show_status() {
    if [ -f "$SESSION_STATE" ]; then
        local session_id=$(jq -r '.session_id' "$SESSION_STATE")
        local ai_type=$(jq -r '.ai_type' "$SESSION_STATE")
        local start_time=$(jq -r '.start_time' "$SESSION_STATE")
        local current_time=$(get_current_time)
        local duration=$((current_time - start_time))
        local duration_minutes=$((duration / 60))
        
        echo -e "${BLUE}Active Session:${NC}"
        echo "  Session ID: $session_id"
        echo "  AI Type: $ai_type"
        echo "  Duration: ${duration_minutes} minutes"
        echo "  Session File: $(jq -r '.session_file' "$SESSION_STATE")"
    else
        echo -e "${YELLOW}No active session${NC}"
    fi
}

# Main script logic
case "$1" in
    "start")
        if [ -z "$2" ]; then
            echo -e "${RED}Usage: $0 start <claude|cursor>${NC}"
            exit 1
        fi
        
        if [ "$2" != "claude" ] && [ "$2" != "cursor" ]; then
            echo -e "${RED}AI type must be 'claude' or 'cursor'${NC}"
            exit 1
        fi
        
        if [ -f "$SESSION_STATE" ]; then
            echo -e "${YELLOW}Active session found. End current session first.${NC}"
            show_status
            exit 1
        fi
        
        start_session "$2"
        ;;
    "end")
        end_session
        ;;
    "status")
        show_status
        ;;
    *)
        echo -e "${BLUE}Session Manager for Claude-Cursor-Obsidian Workflow${NC}"
        echo ""
        echo "Usage:"
        echo "  $0 start <claude|cursor>  - Start a new session"
        echo "  $0 end                   - End current session"
        echo "  $0 status                - Show current session status"
        echo ""
        echo "Examples:"
        echo "  $0 start cursor          - Start Cursor AI session"
        echo "  $0 start claude          - Start Claude session"
        echo "  $0 end                   - End current session"
        ;;
esac
