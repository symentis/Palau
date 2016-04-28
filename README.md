<p align="center">
  <img src="https://raw.githubusercontent.com/symentis/Palau/master/Resources/palau-logo.png">
</p>

[![Build Status](https://travis-ci.org/symentis/Palau.svg)](https://travis-ci.org/symentis/Palau)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Palau.svg)](https://img.shields.io/cocoapods/v/Palau)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/Palau.svg?style=flat)](http://cocoadocs.org/docsets/Palau)
[![swiftyness](https://img.shields.io/badge/pure-swift-ff3f26.svg?style=flat)](https://swift.org/)
[![@elmkretzer](https://img.shields.io/badge/twitter-@elmkretzer-blue.svg?style=flat)](http://twitter.com/elmkretzer)
[![@madhavajay](https://img.shields.io/badge/twitter-@madhavajay-blue.svg?style=flat)](http://twitter.com/madhavajay)

#Palau: NSUserDefaults with Wings!

## Features

- [x] Easily store your Custom Types in NSUserDefaults
- [x] Most Standard Types Out-of-the-box
- [x] Per-property based Chainable Rules
- [x] Supports NSCoding and RawRepresentable
- [x] 300% Type Safe :P
- [x] 100% Unit Test Coverage
- [x] Swift 3 features coming!

## Already Included Types
### Swift
- [x] Bool
- [x] Int
- [x] UInt
- [x] Float
- [x] Double
- [x] String
- [x] Array
- [x] Dictionary

### Foundation
- [x] NSNumber
- [x] NSString
- [x] NSArray
- [x] NSDictionary
- [x] NSDate
- [x] NSData
- [x] NSURL
- [x] NSIndexPath
- [x] UIColor

## Requirements
- Swift 2.2
- iOS 8.0+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 7.3+

## Installation

### Carthage

To integrate Palau into your project using Carthage, add to your `Cartfile`:

```ogdl
github "symentis/Palau" ~> 1.0
```

Run `carthage update` to build the framework and drag the built `Palau.framework` into your Xcode project.
See more instructions on the [Carthage page](https://github.com/Carthage/Carthage).

### CocoaPods

To integrate Palau into your project using CocoaPods, add to your `Podfile`:

```ruby
use_frameworks!

pod 'Palau', '~> 1.0'
```

Run `pod install` to install the framework into your Xcode workspace.

## Usage
Import Palau

```swift
import Palau
```

Once you import the framework you can setup PalauDefaults like:

```swift
extension PalauDefaults {
  public static var name: PalauDefaultsEntry<String> {
    /// backingName is the key used in NSUserDefaults
    get { return value("backingName") }
    set { }
  }
}
```

### Set
By Default a Value will always be optional. 

If you want to set a value you call:

```swift
PalauDefaults.name.value = "Iam a great String value!"
```

### Get
Getting your value back is as easy as:
```swift
/// name is an Optional<String>
let name = PalauDefaults.name.value
```

### Delete
You can delete a property by setting it to: Nil
```swift
PalauDefaults.name.value = nil
```
Or
```swift
/// skip custom rules and delete
PalauDefaults.name.reset()
```

## Custom Rules

### Providing a Default Value
If you want to provide a default, when there is no value set,
you can write a custom rule.

We include two rule types by default: whenNil and ensure

```swift
import Palau
extension PalauDefaults {
  public static var color: PalauDefaultsEntry<UIColor> {
    /// Add as many chainable rules as you like
    get { return value("color").whenNil(use: UIColor.redColor())  }
    set { }
  }
}

/// is UIColor.redColor() 
let color: UIColor? = PalauDefaults.color.value
```

### Providing a Validator

You can also build up arbitrary rules for your value like:

```swift
/// Custom Validator Closure
let lessThan10: Int? -> Bool = {
  return $0.map { $0 < 10 } ?? false
}

public static var ensuredIntValue: PalauDefaultsEntry<Int> {
  get { return value("ensuredIntValue")
    .whenNil(use: 10)
    /// when: takes a closure in this case our Custom Validator
    .ensure(when: lessThan10, use: 10) }
  set { }
}

/// try setting the property to 8
PalauDefaults.ensuredIntValue.value = 8

/// property ensured to be >= 10
assert(PalauDefaults.ensuredIntValue.value == 10)
```

## Custom Types

In Swift 2.2 Classes and Protocols can be used to constrain the ValueType.
For example this is how Palau adds support for RawRepresentable via an Extension:

```swift
/// Extension for RawRepresentable types aka enums
extension PalauDefaultable where ValueType: RawRepresentable {

  public static func get(key: String, from defaults: NSUD) -> ValueType? {
    guard let val = defaults.objectForKey(key) as? ValueType.RawValue else { return nil }
    return ValueType(rawValue: val)
  }

  public static func set(value: ValueType?, forKey key: String, in defaults: NSUD) -> Void {
    guard let value = value?.rawValue as? AnyObject else { return defaults.removeObjectForKey(key) }
    defaults.setObject(value, forKey: key)
  }
}
```

Generally for Types which conform to NSCoding you can usually just provide an
extension like so:

```swift
/// Make UIColor PalauDefaultable
extension UIColor: PalauDefaultable {
  public typealias ValueType = UIColor
}
```

## Look Mum, even Structs!

```swift
// example Struct called Structy for demonstrating we can save a Struct with Palau
public struct Structy {
  let tuple: (String, String)
}

// our Structy PalauDefaultable extension allowing the mapping between PalauDefaults and the Type
// here we just map the two values to two keys named "1" and "2"
extension Structy: PalauDefaultable {
  public static func get(key: String, from defaults: NSUD) -> Structy? {
    guard let d = defaults.objectForKey(key) as? [String: AnyObject] ,
      let t1 = d["1"] as? String,
      let t2 = d["2"] as? String else { return nil }
    return Structy(tuple: (t1, t2))
  }

  public static func set(value: Structy?, forKey key: String, in defaults: NSUD) -> Void {
    guard let value = value else { return defaults.setObject(nil, forKey: key) }
    defaults.setObject(["1": value.tuple.0, "2": value.tuple.1], forKey: key)
  }
}

// now create a property on PalauDefaults
extension PalauDefaults {
  public static var structWithTuple: PalauDefaultsEntry<Structy> {
    get { return value("structy") }
    set { }
  }
}
```

## Limitations for Swift 2.2
We are waiting for extensions on Generic types.... yay!

## FAQ

### What's the origin of the name Palau?

Palau is named after the [Palau swiftlet](https://en.wikipedia.org/wiki/Palau_swiftlet), a species of swift, endemic to the island of Palau.

---

## Credits
Palau is owned and maintained by [Symentis GmbH](http://symentis.com).

Developed by: Elmar Kretzer &amp; Madhava Jay

Follow for more Swift Goodness:
[![Twitter](https://img.shields.io/badge/twitter-@elmkretzer-blue.svg?style=flat)](http://twitter.com/elmkretzer)
[![Twitter](https://img.shields.io/badge/twitter-@madhavajay-blue.svg?style=flat)](http://twitter.com/madhavajay)

##Logo

Awesome Logo by: [4th motion](http://4thmotion.com)

## String Test Fixtures
[Markus Kuhn](http://www.cl.cam.ac.uk/~mgk25/)

## License
Palau is released under the Apache 2.0 license. See LICENSE for details.

