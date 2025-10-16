#!/bin/bash
# Obsidian Teardowns Index Auto-Updater
# Automatically updates the teardowns index in Obsidian vault when new teardowns are added

set -e

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Teardown Cafe → Obsidian Sync${NC}"
echo "=================================="

# Paths
TEARDOWN_DIR="$HOME/Documents/teardown-cafe/src/data/teardowns"
OBSIDIAN_VAULT="$HOME/Documents/Obsidian Notes Vault"  # Update this to match your vault location
OBSIDIAN_INDEX="$OBSIDIAN_VAULT/Projects/Teardowns Index.md"

# Verify teardown directory exists
if [ ! -d "$TEARDOWN_DIR" ]; then
    echo -e "${YELLOW}Warning:${NC} Teardown directory not found: $TEARDOWN_DIR"
    exit 1
fi

# Verify Obsidian vault exists
if [ ! -d "$OBSIDIAN_VAULT" ]; then
    echo -e "${YELLOW}Warning:${NC} Obsidian vault not found: $OBSIDIAN_VAULT"
    echo "Please update OBSIDIAN_VAULT path in this script"
    exit 1
fi

# Create Projects directory if it doesn't exist
mkdir -p "$(dirname "$OBSIDIAN_INDEX")"

echo "Scanning teardowns in: $TEARDOWN_DIR"
echo "Updating Obsidian note: $OBSIDIAN_INDEX"
echo ""

# Initialize counters
total_teardowns=0
easy_count=0
medium_count=0
hard_count=0

# Device type counters
declare -A device_counts

# Start building the new index
cat > "$OBSIDIAN_INDEX" << 'HEADER'
# 🔧 Teardowns Index

> **Note:** This is an automatically generated index linking to detailed teardowns on [Teardown Cafe](https://teardown.cafe)

## Active Projects

HEADER

# Process each teardown markdown file
for file in "$TEARDOWN_DIR"/*.md; do
    if [ ! -f "$file" ]; then
        continue
    fi
    
    filename=$(basename "$file" .md)
    ((total_teardowns++))
    
    # Extract frontmatter using awk
    title=$(awk '/^title:/ {$1=""; print substr($0,2)}' "$file" | tr -d '"')
    description=$(awk '/^description:/ {$1=""; print substr($0,2)}' "$file" | tr -d '"')
    pub_date=$(awk '/^pubDate:/ {print $2}' "$file")
    device=$(awk '/^device:/ {print $2}' "$file")
    difficulty=$(awk '/^difficulty:/ {print $2}' "$file")
    
    # Count by difficulty
    case $difficulty in
        easy) ((easy_count++)) ;;
        medium) ((medium_count++)) ;;
        hard) ((hard_count++)) ;;
    esac
    
    # Count by device type
    ((device_counts[$device]++))
    
    # Extract related notes
    related_notes=$(awk '/^relatedNotes:/,/^[a-z]/ {if ($0 ~ /^  - /) print $2}' "$file" | tr -d '"')
    
    # Format date
    formatted_date=$(date -j -f "%Y-%m-%d" "$pub_date" "+%B %d, %Y" 2>/dev/null || echo "$pub_date")
    
    # Capitalize difficulty
    difficulty_cap=$(echo "$difficulty" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
    
    # Add teardown entry to index
    cat >> "$OBSIDIAN_INDEX" << ENTRY

### $title
- **Date:** $formatted_date
- **Device:** ${device//-/ }
- **Difficulty:** $difficulty_cap
- **Status:** ✅ Complete
- **View Full Teardown:** [$title](https://teardown.cafe/teardowns/$filename)

**Quick Summary:** $description

ENTRY
    
    # Add related notes if they exist
    if [ ! -z "$related_notes" ]; then
        echo "**Related Notes:**" >> "$OBSIDIAN_INDEX"
        while IFS= read -r note; do
            if [ ! -z "$note" ]; then
                echo "- [[$note]]" >> "$OBSIDIAN_INDEX"
            fi
        done <<< "$related_notes"
    fi
    
    echo "---" >> "$OBSIDIAN_INDEX"
    echo ""
    
    echo -e "${GREEN}✓${NC} Added: $title"
done

# Add statistics section
cat >> "$OBSIDIAN_INDEX" << STATS

## Teardown Statistics

| Metric | Value |
|--------|-------|
| Total Teardowns | $total_teardowns |
| Devices Documented | $total_teardowns |
| Difficulty Breakdown | Easy: $easy_count, Medium: $medium_count, Hard: $hard_count |
| Latest Update | $(date "+%B %d, %Y") |

## Categories

### By Device Type
STATS

# Add device type counts
for device in "${!device_counts[@]}"; do
    device_display=$(echo "$device" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')
    echo "- **$device_display:** ${device_counts[$device]}" >> "$OBSIDIAN_INDEX"
done

# Add difficulty breakdown
cat >> "$OBSIDIAN_INDEX" << FOOTER

### By Difficulty
- **Easy:** $easy_count
- **Medium:** $medium_count  
- **Hard:** $hard_count

---

## About Teardown Cafe

Teardown Cafe is a technical blog documenting device disassembly, component analysis, and build projects. Each teardown includes:

- High-quality photography
- Component identification
- Build quality assessment
- Repairability evaluation
- Performance benchmarks
- Related knowledge base links

**Visit:** [teardown.cafe](https://teardown.cafe)

---

*Last Updated: $(date "+%B %d, %Y at %I:%M %p")*
*Auto-generated from teardown-cafe repository*
FOOTER

echo ""
echo "=================================="
echo -e "${GREEN}✓ Obsidian index updated successfully!${NC}"
echo ""
echo "Summary:"
echo "  Total teardowns: $total_teardowns"
echo "  Updated: $OBSIDIAN_INDEX"
echo ""
echo "Obsidian will auto-reload this note if the app is open."
