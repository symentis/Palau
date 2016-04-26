//
//  UserDefaultable.swift
//  Palau
//
//  Created by symentis GmbH on 26.04.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
//

import Foundation

// ------------------------------------------------------------------------------------------------
// MARK: - UserDefaultable
// ------------------------------------------------------------------------------------------------

/// UserDefaultable Protocol
/// Types that can be written to defaults should implement this
public protocol UserDefaultable {

  associatedtype ValueType

  /// Obviously: Get the value
  static func get(key: String, fromDefaults defaults: NSUserDefaults) -> ValueType?

  /// Obviously: Set the value
  static func set(value: ValueType?, forKey key: String, inDefaults defaults: NSUserDefaults) -> Void
}


// ------------------------------------------------------------------------------------------------
// MARK: - Extension Default
// ------------------------------------------------------------------------------------------------

extension UserDefaultable {

  public static func get(key: String, fromDefaults defaults: NSUserDefaults) -> ValueType? {
    return defaults.objectForKey(key) as? ValueType
  }

  public static func set(value: ValueType?, forKey key: String, inDefaults defaults: NSUserDefaults) -> Void {
    guard let value = value as? AnyObject else { return defaults.removeObjectForKey(key) }
    defaults.setObject(value, forKey: key)
  }
}

// ------------------------------------------------------------------------------------------------
// MARK: - RawRepresentable
// ------------------------------------------------------------------------------------------------

extension UserDefaultable where ValueType: RawRepresentable {

  public static func get(key: String, fromDefaults defaults: NSUserDefaults) -> ValueType? {
    guard let val = defaults.objectForKey(key) as? ValueType.RawValue else { return nil }
    return ValueType(rawValue: val)
  }

  public static func set(value: ValueType?, forKey key: String, inDefaults defaults: NSUserDefaults) -> Void {
    guard let value = value?.rawValue as? AnyObject else { return defaults.removeObjectForKey(key) }
    defaults.setObject(value, forKey: key)
  }
}

// ------------------------------------------------------------------------------------------------
// MARK: - NSCoding
// ------------------------------------------------------------------------------------------------

extension UserDefaultable where ValueType: NSCoding {

  public static func get(key: String, fromDefaults defaults: NSUserDefaults) -> ValueType? {
    guard let data = defaults.objectForKey(key) as? NSData,
      let value = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? ValueType else { return nil }
    return value
  }

  public static func set(value: ValueType?, forKey key: String, inDefaults defaults: NSUserDefaults) -> Void {
    guard let value = value as? AnyObject else { return defaults.removeObjectForKey(key) }
    let data = NSKeyedArchiver.archivedDataWithRootObject(value)
    defaults.setObject(data, forKey: key)
  }
}

// ------------------------------------------------------------------------------------------------
// MARK: - Implementations
// ------------------------------------------------------------------------------------------------

/*
 wait for extension Array: UserDefaultable where Element: UserDefaultable in swift 3

 extension Dictionary: UserDefaultable {
 public typealias ValueType = Dictionary<Key, Value>
 }

 extension Array where Element: UserDefaultable {
 public typealias ValueType = Array<Element>
 }
 */

extension Dictionary: UserDefaultable {
  public typealias ValueType = Dictionary<Key, Value>
}

extension Array: UserDefaultable {
  public typealias ValueType = Array
}

/// Make the Int UserDefaultable
extension Int: UserDefaultable {
  public typealias ValueType = Int
}

/// Make the Double UserDefaultable
extension Double: UserDefaultable {
  public typealias ValueType = Double
}

/// Make the Float UserDefaultable
extension Float: UserDefaultable {
  public typealias ValueType = Float
}

/// Make the String UserDefaultable
extension String: UserDefaultable {
  public typealias ValueType = String
}

/// Make the Bool UserDefaultable
extension Bool: UserDefaultable {
  public typealias ValueType = Bool
}

/// Make the NSDate UserDefaultable
extension NSDate: UserDefaultable {
  public typealias ValueType = NSDate
}
