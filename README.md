FloatRatingView
=================

A simple rating view for iOS written in Swift! Supports whole, half or floating point values. I couldn't find anything that easily set floating point ratings, so I made this control based on a [Ray Wenderlich tutorial](http://goo.gl/B49Al4). Some of the best iOS tutorials that I've come across.

Check out the post on medium for a full write-up.<br />
https://medium.com/@glenyi/float-rating-view-in-swift-e740b6b9404d

![FloatRatingView Demo](https://raw.githubusercontent.com/strekfus/FloatRatingView/master/FloatRatingView.gif "FloatRatingView Demo")

Usage
-----

Initialize from a nib/xib or programmatically. Set the empty and full image, then you're pretty much good to go! Check out the demo app to see how it can be used.

Release v4.0 is updated for Swift 5.0 while v1.0.3 is on Swift 2.3.

Usage in an Objective-C Project
-------------------------------
 1. Import the Swift File
 2. Ensure the build settings in your project are set to enable Swift usage (see [here](http://stackoverflow.com/questions/25774085/xcode-gm-ios-8-gm-swift-today-extension-crash-in-simulator-and-device-library-n) and [here](http://stackoverflow.com/questions/24002836/dyld-library-not-loaded-rpath-libswift-stdlib-core-dylib/25247890#25247890))
 3. `import "YOUR_PROJECT_NAME-Swift.h"` in your Objective-C files where you want to use `FloatRatingView`

Pod Installation
----------------

For Swift 2.3 projects just add the following to your podfile:
```
pod 'FloatRatingView', '~> 1.0.3'
```

For Swift 5.0 projects:
```
pod 'FloatRatingView', '~> 4'
```

How it works
------------

The concept is a little different from the source tutorial. The float rating view lays the full image views on top of the empty image views then sets the CALayer mask property to partially hide full images. The full image view mask frame is calculated whenever needed for half or floating point values.
