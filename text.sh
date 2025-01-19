
#!/bin/bash

# Define a temporary file for the screenshot
TEMP_IMAGE=$(mktemp --suffix=.png)

# Capture a region of the screen using grim and slurp
grim -g "$(slurp)" "$TEMP_IMAGE"

# Process the image with Tesseract OCR
TEXT=$(tesseract "$TEMP_IMAGE" stdout -l spa)

# Copy the OCR result to the clipboard
echo "$TEXT" | wl-copy

# Notify the user
notify-send --expire-time=2000 "Text copied to clipboard" "$TEXT"

# Clean up the temporary file
rm "$TEMP_IMAGE"
