#!/bin/bash

# Setup script for Teardown Cafe + Obsidian workspace
echo "🚀 Setting up Teardown Cafe + Obsidian workspace..."

# Check if Obsidian vault exists
OBSIDIAN_VAULT="$HOME/Documents/Obsidian Notes Vault"
if [ ! -d "$OBSIDIAN_VAULT" ]; then
    echo "❌ Obsidian vault not found at: $OBSIDIAN_VAULT"
    echo "Please update the path in this script to match your Obsidian vault location"
    echo "Common locations:"
    echo "  - $HOME/Documents/Obsidian Notes Vault"
    echo "  - $HOME/Obsidian Notes Vault"
    echo "  - $HOME/Documents/Obsidian"
    exit 1
fi

echo "✅ Found Obsidian vault at: $OBSIDIAN_VAULT"

# Update workspace file with correct path
WORKSPACE_FILE="teardown-cafe.code-workspace"
if [ -f "$WORKSPACE_FILE" ]; then
    # Replace the placeholder path with actual path
    sed -i.bak "s|../Obsidian Notes Vault|$OBSIDIAN_VAULT|g" "$WORKSPACE_FILE"
    rm "$WORKSPACE_FILE.bak"
    echo "✅ Updated workspace file with correct Obsidian path"
else
    echo "❌ Workspace file not found: $WORKSPACE_FILE"
    exit 1
fi

# Create Obsidian context folder if it doesn't exist
OBSIDIAN_CONTEXT="$OBSIDIAN_VAULT/Teardown Cafe"
if [ ! -d "$OBSIDIAN_CONTEXT" ]; then
    mkdir -p "$OBSIDIAN_CONTEXT"
    echo "✅ Created Obsidian context folder: $OBSIDIAN_CONTEXT"
fi

# Copy context files to Obsidian
if [ -f "obsidian-context-filter.md" ]; then
    cp "obsidian-context-filter.md" "$OBSIDIAN_CONTEXT/"
    echo "✅ Copied context filter to Obsidian"
fi

if [ -f "claude-cursor-collaboration-prompt.md" ]; then
    cp "claude-cursor-collaboration-prompt.md" "$OBSIDIAN_CONTEXT/"
    echo "✅ Copied collaboration prompts to Obsidian"
fi

if [ -f "simple-workflow-guide.md" ]; then
    cp "simple-workflow-guide.md" "$OBSIDIAN_CONTEXT/"
    echo "✅ Copied workflow guide to Obsidian"
fi

echo ""
echo "🎉 Setup complete! Now you can:"
echo "1. Open the workspace file: teardown-cafe.code-workspace"
echo "2. Or run: code teardown-cafe.code-workspace"
echo ""
echo "This will open both your teardown-cafe project and Obsidian vault in the same window!"
