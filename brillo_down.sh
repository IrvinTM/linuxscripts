
#!/bin/bash

# Adjust the increment percentage
INCREMENT=5

# Increase brightness by 5% for all displays
com.sidevesh.Luminance --decrease-brightness --percentage $INCREMENT

# Get the current brightness of the first display (assuming display 1)
BRIGHTNESS=$(com.sidevesh.Luminance --get-percentage 1)

# Send a notification with the current brightness
notify-send "Brillo" "Current brightness is $BRIGHTNESS%"
