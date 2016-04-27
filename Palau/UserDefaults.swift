//
//  PalauDefaults.swift
//  Palau
//
//  Created by symentis GmbH on 26.04.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
//

import Foundation

/// PalauDefaults
///
/// PalauDefaults wrap the NSUserDefaults
/// The easiest usage is:
/// - extension on PalauDefaults with:
/// ````
///   public static var name: PalauDefaultsEntry<String> {
///   get { return value("name") }
///   set { }
/// }
/// ````
public struct PalauDefaults {

  /// The underlying defaults
  public static var defaults: NSUserDefaults {
    return NSUserDefaults.standardUserDefaults()
  }

  /// Pure - will always return the provided value
  /// used ase base ensure function
  /// - parameter value: T
  /// - returns: T
  public static func pure<T>(value: T) -> T {
    return value
  }

  /// isEmpty - will return a Bool of Emptyness
  /// used by whenNil method
  /// - parameter value: T?
  /// - returns: Bool
  public static func isEmpty<T>(value: T?) -> Bool {
    return value == nil
  }

  /// Generate a PalauDefaultsEntry of Type T for provided key
  /// - parameter key: String, name of the entry
  /// - returns: DefaultValue
  public static func value<T>(key: String) -> PalauDefaultsEntry<T> {
    return PalauDefaultsEntry(key:key, defaults:defaults, ensure: pure)
  }
}
