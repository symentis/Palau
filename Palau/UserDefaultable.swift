//
//  UserDefaultable.swift
//  Palau
//
//  Created by symentis GmbH on 26.04.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
//

import Foundation

#if os(iOS)
  import UIKit
#endif

#if os(tvOS)
  import UIKit
#endif

#if os(watchOS)
  import WatchKit
#endif

// -------------------------------------------------------------------------------------------------
// MARK: - UserDefaultable
// -------------------------------------------------------------------------------------------------

public typealias NSUD = NSUserDefaults

/// UserDefaultable Protocol
/// Types that can be written to defaults should implement this
/// By default we provide an implementation for most of the basic types
public protocol UserDefaultable {

  /// The associatedtype for the Value
  associatedtype ValueType

  /// Static function to get an optional ValueType out of the
  /// provided NSUserDefaults with the key
  /// - param key: The key used in the NSUserDefaults
  /// - param defaults: The NSUserDefaults
  /// - returns: ValueType?
  static func get(key: String, from defaults: NSUD) -> ValueType?

  /// Static function to set an optional ValueType in the provided NSUserDefaults with the key
  /// - param value: The optional value to be stored
  /// - param key: The key used in the NSUserDefaults
  /// - param defaults: The NSUserDefaults
  /// - returns: Void
  static func set(value: ValueType?, forKey key: String, in defaults: NSUD) -> Void
}


// -------------------------------------------------------------------------------------------------
// MARK: - Extension Default
//
// The extension will provide set and get for basic types like String, Int and so forth
// -------------------------------------------------------------------------------------------------

/// Extension for basic types like Int, String and so forth
extension UserDefaultable {

  public static func get(key: String, from defaults: NSUD) -> ValueType? {
    return defaults.objectForKey(key) as? ValueType
  }

  public static func set(value: ValueType?, forKey key: String, in defaults: NSUD) -> Void {
    guard let value = value as? AnyObject else { return defaults.removeObjectForKey(key) }
    defaults.setObject(value, forKey: key)
  }
}

// -------------------------------------------------------------------------------------------------
// MARK: - RawRepresentable
//
// The extension will provide set and get for RawRepresentable
// -------------------------------------------------------------------------------------------------

/// Extension for RawRepresentable types aka enums
extension UserDefaultable where ValueType: RawRepresentable {

  public static func get(key: String, from defaults: NSUD) -> ValueType? {
    guard let val = defaults.objectForKey(key) as? ValueType.RawValue else { return nil }
    return ValueType(rawValue: val)
  }

  public static func set(value: ValueType?, forKey key: String, in defaults: NSUD) -> Void {
    guard let value = value?.rawValue as? AnyObject else { return defaults.removeObjectForKey(key) }
    defaults.setObject(value, forKey: key)
  }
}

// -------------------------------------------------------------------------------------------------
// MARK: - NSCoding
//
// The extension will provide set and get for NSCoding types
// -------------------------------------------------------------------------------------------------

/// Extension for NSCoding types
extension UserDefaultable where ValueType: NSCoding {

  public static func get(key: String, from defaults: NSUD) -> ValueType? {
    guard let data = defaults.objectForKey(key) as? NSData,
      let value = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? ValueType else { return nil }
    return value
  }

  public static func set(value: ValueType?, forKey key: String, in defaults: NSUD) -> Void {
    guard let value = value as? AnyObject else { return defaults.removeObjectForKey(key) }
    let data = NSKeyedArchiver.archivedDataWithRootObject(value)
    defaults.setObject(data, forKey: key)
  }
}

// -------------------------------------------------------------------------------------------------
// MARK: - Implementations
// -------------------------------------------------------------------------------------------------

//
/*
 TODO Swift 3:

 Swift 3 will probably give us extensions on generic types.
 This will make it easier for Array and Dictionary, Set
 Maybe like

 extension CollectionType<Element>: UserDefaultable {
  public typealias ValueType = CollectionType<Element>
 }
*/

/// Make Bool UserDefaultable
extension Bool: UserDefaultable {
  public typealias ValueType = Bool
}

/// Make Int UserDefaultable
extension Int: UserDefaultable {
  public typealias ValueType = Int
}

/// Make UInt UserDefaultable
extension UInt: UserDefaultable {
  public typealias ValueType = UInt
}

/// Make Float UserDefaultable
extension Float: UserDefaultable {
  public typealias ValueType = Float
}

/// Make Double UserDefaultable
extension Double: UserDefaultable {
  public typealias ValueType = Double
}

/// Make NSNumber UserDefaultable
extension NSNumber: UserDefaultable {
  public typealias ValueType = NSNumber
}

/// Make String UserDefaultable
extension String: UserDefaultable {
  public typealias ValueType = String
}

/// Make NSString UserDefaultable
extension NSString: UserDefaultable {
  public typealias ValueType = NSString
}

/// Make Array UserDefaultable
extension Array: UserDefaultable {
  public typealias ValueType = Array
}

/// Make NSArray UserDefaultable
extension NSArray: UserDefaultable {
  public typealias ValueType = NSArray
}

/// Make Dictionary UserDefaultable
extension Dictionary: UserDefaultable {
  public typealias ValueType = Dictionary
}

/// Make NSDictionary UserDefaultable
extension NSDictionary: UserDefaultable {
  public typealias ValueType = NSDictionary
}

/// Make NSDate UserDefaultable
extension NSDate: UserDefaultable {
  public typealias ValueType = NSDate
}

/// Make NSData UserDefaultable
extension NSData: UserDefaultable {
  public typealias ValueType = NSData
}

/// Make NSURL UserDefaultable
extension NSURL: UserDefaultable {
  public typealias ValueType = NSURL
}

/// Make NSIndexPath UserDefaultable
extension NSIndexPath: UserDefaultable {
  public typealias ValueType = NSIndexPath
}

/// Make NSIndexPath UserDefaultable
extension UIColor: UserDefaultable {
  public typealias ValueType = UIColor
}
