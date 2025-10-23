# 🤖 Claude-Cursor-Obsidian Integrated Workflow

> **Complete guide for seamless AI collaboration with automatic documentation**

## 🎯 Overview

This workflow system enables seamless collaboration between Claude and Cursor AI while maintaining complete context through Obsidian documentation. Every change is tracked, documented, and made available to both AIs.

## 🚀 Quick Start

### 1. Open Workspace
```bash
cd ~/Documents/teardown-cafe
code teardown-cafe.code-workspace
```

### 2. Start a Session
```bash
# For Cursor AI work
./scripts/session-manager.sh start cursor

# For Claude work
./scripts/session-manager.sh start claude
```

### 3. Work and Commit
```bash
# Make your changes...
# Then commit with session tracking
./scripts/commit-with-session.sh "Your commit message"
```

### 4. Generate Context for Handoff
```bash
# For Claude
./scripts/claude-context-generator.sh clipboard

# For Cursor
./scripts/cursor-context-generator.sh clipboard
```

## 📋 Complete Workflow

### Starting a New Session

1. **Choose your AI:**
   ```bash
   # Cursor AI (for code, files, git)
   ./scripts/session-manager.sh start cursor
   
   # Claude (for strategy, content, design)
   ./scripts/session-manager.sh start claude
   ```

2. **Session note is created** in Obsidian with:
   - Timestamp and session ID
   - Initial git state
   - Session goal template
   - Log template

3. **Update session goal** in the generated note

### During Your Session

1. **Work normally** - make changes, write code, create content
2. **Update session log** in the Obsidian note as you work
3. **Note any decisions** or issues in the session file

### Committing Changes

1. **Use the integrated commit script:**
   ```bash
   ./scripts/commit-with-session.sh "Your commit message"
   ```

2. **What happens automatically:**
   - Pre-commit checks run
   - Session note updated with changes
   - Git commit executed
   - Obsidian sync runs
   - Session index updated

### Ending a Session

1. **Update session note** with:
   - What was accomplished
   - Any issues encountered
   - Handoff notes for next AI

2. **End the session:**
   ```bash
   ./scripts/session-manager.sh end
   ```

3. **Generate context** for the next AI:
   ```bash
   # For Claude
   ./scripts/claude-context-generator.sh clipboard
   
   # For Cursor
   ./scripts/cursor-context-generator.sh clipboard
   ```

### Handoff Process

1. **Copy the generated context** to clipboard
2. **Start new AI session** with the context
3. **Paste context** as your first message
4. **Continue working** with full context

## 🛠️ Available Commands

### Session Management
```bash
# Start session
./scripts/session-manager.sh start [claude|cursor]

# End session
./scripts/session-manager.sh end

# Check status
./scripts/session-manager.sh status
```

### Commit Workflow
```bash
# Commit with session tracking
./scripts/commit-with-session.sh [ai_type] [message]

# Examples
./scripts/commit-with-session.sh cursor "Fixed Material You tokens"
./scripts/commit-with-session.sh "Quick bug fix"
```

### Context Generation
```bash
# Generate and copy to clipboard
./scripts/claude-context-generator.sh clipboard
./scripts/cursor-context-generator.sh clipboard

# Generate and save to file
./scripts/claude-context-generator.sh file
./scripts/cursor-context-generator.sh file

# Show context (not copied)
./scripts/claude-context-generator.sh show
./scripts/cursor-context-generator.sh show
```

## 📁 File Structure

```
teardown-cafe/
├── .context/                          # Context exchange files
│   ├── last-change-summary.md         # Recent changes
│   ├── next-ai-context.md             # Handoff notes
│   ├── current-state.json             # Machine state
│   └── session-state.json             # Active session
├── scripts/                           # Workflow scripts
│   ├── session-manager.sh              # Session management
│   ├── commit-with-session.sh         # Integrated commits
│   ├── claude-context-generator.sh    # Claude context
│   └── cursor-context-generator.sh    # Cursor context
├── .vscode/                           # Cursor settings
│   ├── settings.json                  # Workspace settings
│   └── tasks.json                     # Custom tasks
└── teardown-cafe.code-workspace       # Multi-root workspace

Obsidian Notes Vault/
└── Teardown Cafe/
    ├── Sessions/                      # Session history
    │   └── YYYY-MM-DD-HHMM-{ai}-session.md
    ├── Session Index.md               # Master index
    ├── Workflow Dashboard.md          # Quick reference
    └── [existing files]
```

## 🎯 Cursor Integration

### Tasks Available in Cursor
- **Start Session (Cursor)** - Start Cursor AI session
- **Start Session (Claude)** - Start Claude session
- **End Session** - End current session
- **Commit with Session** - Commit with tracking
- **Generate Claude Context** - Create handoff context
- **Generate Cursor Context** - Create handoff context
- **Session Status** - Check current session
- **Quick Peek Session Notes** - Open session folder
- **Open Workflow Dashboard** - Open dashboard

### Keyboard Shortcuts
- `Cmd+Shift+P` → "Tasks: Run Task" → Select task
- All tasks are available in the Command Palette

### Multi-Root Workspace
- **Teardown Cafe** - Your main project
- **Obsidian Vault** - Documentation and notes
- Both visible in same Cursor window
- Quick navigation between projects

## 📊 Obsidian Integration

### Session Notes
Each session creates a detailed note with:
- **Session metadata** (ID, AI type, timestamps)
- **Initial git state** (branch, commit, status)
- **Session goal** (what you plan to accomplish)
- **Session log** (real-time updates)
- **Changes made** (auto-populated on commit)
- **Handoff notes** (for next AI)

### Auto-Generated Files
- **Session Index** - Chronological list of all sessions
- **Workflow Dashboard** - Real-time project status
- **Context files** - Machine-readable state

### Quick Access
- Navigate to `Teardown Cafe/Sessions/` for session history
- Use `Workflow Dashboard.md` for project overview
- Use `Session Index.md` for session navigation

## 🔄 Git Integration

### Automatic Hooks
- **Pre-commit** - Captures session state before commit
- **Post-commit** - Updates session note and syncs to Obsidian

### Commit Workflow
1. **Stage changes** automatically
2. **Run pre-commit checks** (linting, file sizes, etc.)
3. **Capture git diff** for session note
4. **Execute commit** with your message
5. **Update session note** with commit details
6. **Sync to Obsidian** automatically

## 🎯 Best Practices

### Session Management
- **Start sessions** for focused work periods
- **Update session logs** as you work
- **End sessions** when switching AIs
- **Generate context** before handoffs

### Commit Strategy
- **Commit frequently** to maintain history
- **Use descriptive messages** for context
- **Let the system track** the details
- **Review session notes** for context

### Context Handoffs
- **Always generate context** before switching AIs
- **Include specific goals** in handoff notes
- **Review recent changes** before starting
- **Use the generated prompts** as starting points

## 🆘 Troubleshooting

### Common Issues

**Session not found:**
```bash
./scripts/session-manager.sh status
# If no session, start one:
./scripts/session-manager.sh start cursor
```

**Context not generated:**
```bash
# Check if session is active
./scripts/session-manager.sh status

# Check context files
ls -la .context/
```

**Obsidian sync fails:**
```bash
# Check vault path in scripts
grep "OBSIDIAN_VAULT" scripts/*.sh

# Run sync manually
./sync-to-obsidian.sh
```

**Git conflicts:**
```bash
# Resolve conflicts first
git status
git add -A
git commit -m "Resolve conflicts"
```

### Debug Commands
```bash
# Check all session files
ls -la "/Users/aim/Documents/Obsidian Notes Vault/Teardown Cafe/Sessions/"

# View context files
cat .context/current-state.json

# Check git hooks
ls -la .git/hooks/

# Test scripts
./scripts/session-manager.sh status
./scripts/claude-context-generator.sh show
```

## 📈 Advanced Usage

### Custom Context
Edit `.context/next-ai-context.md` to add custom handoff notes.

### Session Templates
Customize session note templates in the scripts.

### Git Hooks
Modify `.git/hooks/pre-commit` and `.git/hooks/post-commit` for custom behavior.

### Workspace Settings
Edit `teardown-cafe.code-workspace` for custom workspace configuration.

## 🎉 Benefits

✅ **Complete change history** - Never lose track of what changed  
✅ **AI context awareness** - Each AI knows what the other did  
✅ **Obsidian integration** - All work documented automatically  
✅ **No new windows** - Everything in multi-root workspace  
✅ **Automatic commits** - Session-based git workflow  
✅ **Quick handoffs** - Context generators for each AI  
✅ **Visual diffs** - See exactly what changed  
✅ **Time tracking** - Know how long each session took  

---

**Ready to start collaborating!** 🚀

Use this workflow to maintain perfect context between Claude and Cursor AI while building your Teardown Cafe project.
