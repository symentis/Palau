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

public typealias NSUD = NSUserDefaults

/// UserDefaultable Protocol
/// Types that can be written to defaults should implement this
public protocol UserDefaultable {

  associatedtype ValueType

  /// Obviously: Get the value
  static func get(key: String, from defaults: NSUD) -> ValueType?

  /// Obviously: Set the value
  static func set(value: ValueType?, forKey key: String, in defaults: NSUD) -> Void
}


// ------------------------------------------------------------------------------------------------
// MARK: - Extension Default
// ------------------------------------------------------------------------------------------------

extension UserDefaultable {

  public static func get(key: String, from defaults: NSUD) -> ValueType? {
    return defaults.objectForKey(key) as? ValueType
  }

  public static func set(value: ValueType?, forKey key: String, in defaults: NSUD) -> Void {
    guard let value = value as? AnyObject else { return defaults.removeObjectForKey(key) }
    defaults.setObject(value, forKey: key)
  }
}

// ------------------------------------------------------------------------------------------------
// MARK: - RawRepresentable
// ------------------------------------------------------------------------------------------------

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

// ------------------------------------------------------------------------------------------------
// MARK: - NSCoding
// ------------------------------------------------------------------------------------------------

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

// ------------------------------------------------------------------------------------------------
// MARK: - Implementations
// ------------------------------------------------------------------------------------------------

// TODO Swift 3: CollectionType: UserDefaultable where Element: UserDefaultable
/*
 /// Make Set UserDefaultable
 extension Set: UserDefaultable {
 public typealias ValueType = Set

 public static func get<T>(key: String, from defaults: NSUD) -> Set<T>? {
 guard let array = defaults.objectForKey(key) as? [T] else { return nil }
 return Set<T>(array)
 }

 public static func set<T>(value: Set<T>?, forKey key: String, in defaults: NSUD) -> Void {
 guard let set = value, let value = Array(set) as? AnyObject else { return defaults.removeObjectForKey(key) }
 defaults.setObject(value, forKey: key)
 }
 }

 extension CollectionType where Element: UserDefaultable {
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
  public typealias ValueType = Dictionary<Key, Value>
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
