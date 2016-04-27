//
//  PalauDefaultsEntry.swift
//  Palau
//
//  Created by symentis GmbH on 26.04.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// A PalauDefaultsEntry
/// with String key
/// PalauDefaultable value
public struct PalauDefaultsEntry<T: PalauDefaultable> {

  /// The key of the entry
  public let key: String

  /// Access to the default
  let defaults: NSUD

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
  /// public static var intValueWithMinOf10: PalauDefaultsEntry<Int> {
  /// get {
  ///   return value(_autoPauseThresholdSeconds)
  ///         .ensure(when: isEqual(0), use: 20)
  ///         .ensure(when: lessThan(10), use: 10)
  ///     }
  ///  set {}
  /// }
  /// ````
  public func ensure(when when: T.ValueType? -> Bool,
                     use defaultValue: T.ValueType) -> PalauDefaultsEntry<T> {
    return PalauDefaultsEntry(key:key, defaults:defaults) {
      let vx = self.ensure($0)
      return when(vx) ? defaultValue : vx
    }
  }

  /// Helper function to return a fallback in case the value is nil
  public func whenNil(use defaultValue: T.ValueType) -> PalauDefaultsEntry<T> {
    return ensure(when:PalauDefaults.isEmpty, use:defaultValue)
  }
}
