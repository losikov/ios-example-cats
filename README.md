# iOS Native app for CATAAS (Cat As A Service)

## Setup & Build Instructions:
* Latest Xcode
    * `CMD+R` to run the app
    * `CMD+U` to run tests

> **_NOTE:_**  No 3rd party libraries.

## Features:
1. `Swift` + `UIKit` + `NSLayoutConstraint`, no `Storyboard`, `nibs`
    * Custom `UICollectionView` Layout:
        * 1x1 + 1x1
        * 2x1
        * 2x2
    * Images Prefetching
2. Image Cache with `URLCache` (works if app is restarted)
3. *Light* & *Dark* mode support
4. Basic *Unit Tests*

## Not supported:
1. Different layouts for *Portrait* and *Landscape* and optimized layouts for *iPad*
2. `Gif` images playback
3. AppIcon & Splash Screeen

## Optional to implement
1. Filter by **Tags**
2. **Cat** details and actions
3. UI Tests
