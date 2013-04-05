# Colors - an OSX Screensaver

Colors was inspired by an [R](http://www.r-project.org) program created to test whether any two colors could actually clash.

The screensaver:

* generates a random 10-sided shape filled by a random color (with random opacity)
* on a random background
* refreshed every 2 seconds.

The screensaver project was created with [XCode 4.6.1](https://developer.apple.com/xcode/), on [OSX 10.8](http://en.wikipedia.org/wiki/OS_X_Mountain_Lion). The code will probably compile on other versions of OSX but the project `.xcodeproj` may not be compatible

## References

I used the [OSX Screensaver docs](https://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/OSX_Technology_Overview/CocoaApplicationLayer/CocoaApplicationLayer.html%23//apple_ref/doc/uid/TP40001067-CH274-SW15) and the [Write a Screen Saver: Part I](http://cocoadevcentral.com/articles/000088.php) tutorial from Cocoa Dev central.

> **Note:** the Cocao Dev Central article is from 2005, Xcode looks much different now.

## Building

The `.saver` file is not included in this repo.

You will need to download [XCode](https://developer.apple.com/xcode/), checkout this project, double click `Colors.xcodeproj`, then press "Build and Run".

> **Note:** installing [XCode 4.6.1](https://developer.apple.com/xcode/) will also provide a `git` client.

## Future Plans

At some point I intend to add a configuration sheet to allow the refresh rate, and number of polygon sides to be configured.
