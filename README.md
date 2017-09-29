# Lazer Tag
This is a version of lazer tag played on iOS

## Requirements for playing
- Your phone must be an iPhone 6 or higher (iPhone SE is good), so that it can support apple's augmented reality API
- Phone must be running iOS 11.0.0 or higher
- Your main camera must be fully functioning
- You must have a server to host your matches

## Requirements for building
- Cocoa Pods https://cocoapods.org/app
- xCode 9.0 or higher

## Running the app
This app uses sockets.io to communicate between devices, this is a dependency handled via cocoa pods. Once you clone this repo, launch cocoa pods and install the dependencies (you can also do this via the command line if you're all old school like).
Launch the iOS-Secret-Master.xcworkspace file, not the iOS-Secret-Master.xcodeproj (the latter will not include your sockets dependency)
You can now build and run the app as normal (or as normal as it gets with swift).

Remember
- To set your new developer profile in xcode
- Setup and run a server to handle your games (slicker management forthcoming)
- Don't expect everything to run happily, this was build in a week, and mostly in a night.
