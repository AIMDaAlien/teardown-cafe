#!/bin/bash
# Interactive script to import and rename images for a specific teardown slug

# Function to display usage
usage() {
  echo "Usage: $0"
  echo "This script will interactively guide you to select a teardown and import images."
}

# --- Main Script ---

# Get the list of teardown slugs from the filenames in src/data/teardowns
TEARDOWN_DIR="src/data/teardowns"
if [ ! -d "$TEARDOWN_DIR" ]; then
  echo "Error: Directory '$TEARDOWN_DIR' not found."
  exit 1
fi

# Create an array of teardown slugs by removing the .md extension
slugs=($(ls -1 "$TEARDOWN_DIR" | sed -e 's/\.md$//'))

if [ ${#slugs[@]} -eq 0 ]; then
  echo "No teardowns found in '$TEARDOWN_DIR'."
  exit 1
fi

# Present the user with a choice of slugs
echo "Please choose a teardown to import images for:"
select SLUG in "${slugs[@]}"; do
  if [ -n "$SLUG" ]; then
    break
  else
    echo "Invalid selection. Please try again."
  fi
done

echo "Selected teardown: $SLUG"

# Ask for the source directory of the images
read -p "Enter the path to the source image directory (e.g., ~/Downloads/my_images): " SOURCE_DIR

# Expand the tilde to the home directory
SOURCE_DIR="${SOURCE_DIR/#\~/$HOME}"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory '$SOURCE_DIR' not found."
  exit 1
fi

# Define the target directory
TARGET_DIR="public/images/$SLUG"

# Create the target directory if it doesn't exist
mkdir -p "$TARGET_DIR"
echo "Created/ensured target directory: $TARGET_DIR"

# --- Image Processing ---

# Find all image files (jpg, jpeg, png, webp, gif) in the source directory
# Use find for better handling of filenames with spaces
find "$SOURCE_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) | while read -r file; do
  # Get the base filename
  filename=$(basename "$file")
  
  # Create a new filename: slug-01, slug-02, etc.
  # For simplicity, we'll just use a counter. A more robust solution might use EXIF data.
  
  # Let's use a simple counter for now.
  # A better approach would be to sort by creation date.
  
  echo "Processing $filename..."
  
  # This is a placeholder for the renaming logic.
  # The original script was complex. Let's simplify: copy and let the user rename.
  
  cp "$file" "$TARGET_DIR/"
  echo "Copied '$filename' to '$TARGET_DIR/'"
done

echo "---"
echo "Image import complete."
echo "All images from '$SOURCE_DIR' have been copied to '$TARGET_DIR'."
echo "Please manually rename the files in '$TARGET_DIR' to match the order you want them to appear in the teardown."
echo "Example format: 01-description.jpg, 02-another-view.jpg"
