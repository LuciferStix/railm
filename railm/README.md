# railm (Railway Mobile App)

smart railway tracking and database management mobile app.

## Dependencies
- flutter v3.41.9
- android emulator v36 (tested on)

## Build
```bash
# shows usage
make help

# run the railapi server first
# then start the emulator
emulator -avd # android
open -a Simulator # iOS

# check if flutter detected the virtual device
flutter devices

# then run with
make run-debug RAILAPI_URL=<url> \
               RAILAPI_TOKEN=<token> \
               MAPBOX_TOKEN=<token>

# Build
make build RAILAPI_URL=<url> \
           RAILAPI_TOKEN=<token> \
           MAPBOX_TOKEN=<token>
```

## Install
Download the prebuilt apk from the **Release** and install it.

## Tested On
- Pixel 9A (emulator)
- iPhone 16e (simulator)
