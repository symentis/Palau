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

  let key: String
  let defaults: NSUserDefaults
  let ensure: (T.ValueType? -> T.ValueType?)

  public var value: T.ValueType? {
    get { return ensure(T.get(key, fromDefaults: defaults)) }
    set { T.set(ensure(newValue), forKey: key, inDefaults: defaults) }
  }

  public func reset() {
    defaults.removeObjectForKey(key)
  }

  public func ensure(when when: T.ValueType? -> Bool,
                          use defaultValue: T.ValueType) -> UserDefaultsEntry<T> {
    return UserDefaultsEntry(key:key, defaults:defaults) {
      let vx = self.ensure($0)
      return when(vx) ? defaultValue : vx
    }
  }
}
