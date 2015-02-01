# aerogear-ios-json-patch [![Build Status](https://travis-ci.org/aerogear/aerogear-ios-json-patch.png)](https://travis-ci.org/aerogear/aerogear-ios-json-patch)
Json Patch Swift implementation of [JavaScript Object Notation (JSON) Patch
- RFC6902](https://tools.ietf.org/html/rfc6902). 
Taking care of: 

* making diff
* apply patch
* comply with [json patch test suite](https://github.com/json-patch/json-patch-tests/blob/master/tests.json)

100% Swift.

## Example Usage

TODO

## Adding the library to your project 
To add the library in your project, you can either use [Cocoapods](http://cocoapods.org) or manual install in your project. See the respective sections below for instructions:

### Using [Cocoapods](http://cocoapods.org)
At this time, Cocoapods support for Swift frameworks is supported in a [pre-release](http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/). In your ```Podfile``` add:

```
pod 'AeroGearJsonPatch'
```

and then:

```bash
pod install
```

to install your dependencies

### Manual Installation
Follow these steps to add the library in your Swift project:

1. Add AeroGearJsonPatch as a [submodule](http://git-scm.com/docs/git-submodule) in your project. Open a terminal and navigate to your project directory. Then enter:
```bash
git submodule add https://github.com/aerogear/aerogear-ios-json-patch.git
```
2. Open the `aerogear-ios-json-patch` folder, and drag the `AeroGearJsonPatch.xcodeproj` into the file navigator in Xcode.
3. In Xcode select your application target  and under the "Targets" heading section, ensure that the 'iOS  Deployment Target'  matches the application target of AeroGearJsonPatch.framework (Currently set to 8.0).
5. Select the  "Build Phases"  heading section,  expand the "Target Dependencies" group and add  `AeroGearJsonPatch.framework`.
7. Click on the `+` button at the top left of the panel and select "New Copy Files Phase". Rename this new phase to "Copy Frameworks", set the "Destination" to "Frameworks", and add `AeroGearJsonPatch.framework`.


If you run into any problems, please [file an issue](http://issues.jboss.org/browse/AEROGEAR) and/or ask our [user mailing list](https://lists.jboss.org/mailman/listinfo/aerogear-users). You can also join our [dev mailing list](https://lists.jboss.org/mailman/listinfo/aerogear-dev).  