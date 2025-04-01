# StreamTheVote2024.com
Stream The Vote is an interactive website that helps fellow citizens monitor drop box activity to ensure election integrity. 

### Development Notes
https://streamthevote2024.com is a Flutter WebAssembly app that pulls location data from a REST API backend. Android, Windows, and Linux (Raspberry Pi) versions have been tested and make the same API calls as the WebAssembly app. Zooming around the map by clicking map locations is an excellent experience on a 120Hz display.

### Structure
The application uses the provider package for state management. It is designed to handle mouse, keyboard, and touch input equally well. The experience is especially nice on touch-first devices. Four API calls are made to collect states, counties, cities, and locations. 

A list and map both reference the objects created from the API calls. Clicking on a state, county, or city averages all location lats/longs underneath it and zooms to the center. Once a location on the map is clicked, more information is shown in a slide-up popup.

### Building
As you would with any Flutter app, clone the repo and pull required packages.

Note that the web version will not connect to the API due to browser CORS policy. To fully test the web version you will need to set up an API on the same server running the app. 

Instead, for testing purposes, it is suggested to build for Android, Windows, or Linux since these can connect to the existing API with no issues.


```shell
# pull packages
flutter pub get

# test web version (API calls won't work without setting one up)
flutter build web 
flutter run -d web-server

# test device versions (existing API calls will work)
flutter build apk
flutter build windows
flutter build linux

```

