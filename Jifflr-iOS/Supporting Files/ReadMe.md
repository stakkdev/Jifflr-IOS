# BuiltWith

## Project Set Up 

This project uses [Components](https://github.com/thedistance/TheDistanceComponents).

In order to set up this project for use, follow these steps:

### Objective-C Bridging Header
* Set `${PRODUCT_NAME}/Supporting Files/Bridging-Header.h` as the **Bridging Header** in the app target's **Build Settings**.

### CocoaPods
* Update the `podfile` to correctly set the project and workspace to be the title of this project.
* Close Xcode and run `pod install` in the directory of the `podfile` to install pods. This will create the `.workspace` file - this should be used instead of the `.xcodeproj` file when working on the project.

### SwiftLint
* Create a new **Run Script** to **Build Phases** with `${PODS_ROOT}/SwiftLint/swiftlint`

### Fabric (Crashlytics)
* Setup Fabric (Crashlytics) as described here: [Fabric Installation Guide](https://fabric.io/kits/ios/crashlytics/install)

    - Create a new **Run Script** to **Build Phases** with `"${PODS_ROOT}/Fabric/run" <FABRIC_API_KEY> <BUILD_SECRET>`
    - Update the `info.plist` with the Fabric API key as described in the guide.

### Firebase (Google Analytics)
* Setup Firebase (Google Analytics) as described here: [Firebase Installation Guide](https://firebase.google.com/docs/ios/setup)

    - Create a Firebase Project and download the `GoogleService-Info.plist` file. Either overwrite the existing file in the template project or copy the details into the existing file.
    - Uncomment `FirebaseApp.configure()` in the `application:didFinishLaunchingWithOptions:` method.

### App Icon and Launch Screen
* Set up any App Icons and Launch Screen in the `Assets.xcassets` file.

### Good to go!
* Your project should now compile and run.
