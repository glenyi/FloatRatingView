FloatRatingView
=================

A simple rating view for iOS written in Swift! Supports whole, half or floating point values. I couldn't find anything that easily set floating point ratings, so I made this control based on a [Ray Wenderlich tutorial](http://goo.gl/B49Al4). Some of the best iOS tutorials that I've come across.

![FloatRatingView Demo](https://raw.github.com/strekfus/FloatRatingView/master/FloatRatingViewDemo.gif "FloatRatingView Demo")

Usage
-----

Initialize from a nib/xib or programmatically. Set the empty and full image, then you're pretty much good to go! Check out the demo app to see how it can be used.

How it works
------------

The concept is a little different from the source tutorial. The float rating view lays the full image views on top of the empty image views then sets the CALayer mask property to partially hide full images. The full image view mask frame is calculated whenever needed for half or floating point values.