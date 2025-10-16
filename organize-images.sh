#!/bin/bash
# Teardown Image Organizer
# Copies and renames images for the Raspberry Pi 5 NVMe teardown

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Teardown Cafe - Image Organizer${NC}"
echo "=================================="
echo ""

# Source directory (where you downloaded the images from chat)
SOURCE_DIR="$HOME/Downloads"

# Destination
DEST_DIR="$HOME/Documents/teardown-cafe/public/images/raspberry-pi-5-nvme"

# Create destination if it doesn't exist
mkdir -p "$DEST_DIR"

# Image mapping: original filename -> new descriptive name
declare -A images=(
    ["IMG20251015184233.jpg"]="01-components-overview.jpg"
    ["IMG20251015192501.jpg"]="02-raspberry-pi-5-ports.jpg"
    ["IMG20251015192851.jpg"]="03-hat-installation-with-fan.jpg"
    ["IMG20251015193917.jpg"]="04-case-fitting-test.jpg"
    ["IMG20251015201625.jpg"]="05-hat-assembly-layers.jpg"
    ["IMG20251015224411.jpg"]="06-final-assembly.jpg"
)

echo "Looking for images in: $SOURCE_DIR"
echo "Copying to: $DEST_DIR"
echo ""

copied=0
missing=0

for original in "${!images[@]}"; do
    new_name="${images[$original]}"
    source_file="$SOURCE_DIR/$original"
    dest_file="$DEST_DIR/$new_name"
    
    if [ -f "$source_file" ]; then
        cp "$source_file" "$dest_file"
        echo -e "${GREEN}✓${NC} Copied: $original → $new_name"
        ((copied++))
    else
        echo "✗ Missing: $original (expected at $source_file)"
        ((missing++))
    fi
done

echo ""
echo "=================================="
echo "Summary:"
echo "  Copied: $copied images"
if [ $missing -gt 0 ]; then
    echo "  Missing: $missing images"
    echo ""
    echo "If images are missing, download them from the Claude chat"
    echo "and place them in: $SOURCE_DIR"
else
    echo -e "${GREEN}  All images successfully copied!${NC}"
fi
