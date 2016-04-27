//
//  UserDefaultsEntry.swift
//  Palau
//
//  Created by symentis GmbH on 26.04.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
//

import Foundation

/// A UserDefaultsEntry
/// with String key
/// UserDefaultable value
public struct UserDefaultsEntry<T: UserDefaultable> {

  /// The key of the entry
  public let key: String

  /// Access to the default
  let defaults: NSUserDefaults

  /// A function to change the incoming and outgoing value
  let ensure: (T.ValueType? -> T.ValueType?)

  // ----------------------------------------------------------------------------------------------
  // MARK: - Public access
  // ----------------------------------------------------------------------------------------------

  /// Computed property value
  public var value: T.ValueType? {
    get { return ensure(T.get(key, from: defaults)) }
    set { T.set(ensure(newValue), forKey: key, in: defaults) }
  }

  /// Use this function to remove a default value
  /// without additional calls of the ensure function
  public func reset() {
    defaults.removeObjectForKey(key)
  }

  /// Helper function to take care of the value thats is read and written
  /// usage like:
  /// The functions provided for 'when' parameter can be implemented for any use case
  /// ````
  /// public static var intValueWithMinOf10: UserDefaultsEntry<Int> {
  /// get {
  ///   return value(_autoPauseThresholdSeconds)
  ///         .ensure(when: isEqual(0), use: 20)
  ///         .ensure(when: lessThan(10), use: 10)
  ///     }
  ///  set {}
  /// }
  /// ````
  public func ensure(when when: T.ValueType? -> Bool,
                          use defaultValue: T.ValueType) -> UserDefaultsEntry<T> {
    return UserDefaultsEntry(key:key, defaults:defaults) {
      let vx = self.ensure($0)
      return when(vx) ? defaultValue : vx
    }
  }

  /// Helper function to return a fallback in case the value is nil
  public func whenNil(use defaultValue: T.ValueType) -> UserDefaultsEntry<T> {
    return ensure(when:UserDefaults.isEmpty, use:defaultValue)
  }
}
