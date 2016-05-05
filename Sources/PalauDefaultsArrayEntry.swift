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
/// PalauDefaultable array value
public struct PalauDefaultsArrayEntry<T: PalauDefaultable> {

  /// for convenience
  public typealias PalauDidSetArrayFunction = (newValue: [T.ValueType]?, oldValue: [T.ValueType]?) -> Void
  public typealias PalauEnsureArrayFunction = ([T.ValueType]?) -> [T.ValueType]?

  /// The key of the entry
  public let key: String

  /// Access to the default
  let defaults: NSUD

  /// A function to change the incoming and outgoing value
  let ensure: PalauEnsureArrayFunction

  /// A function as callback after set
  let didSet: PalauDidSetArrayFunction?

  /// a initializer
  init(key: String, defaults: NSUserDefaults, didSet: PalauDidSetArrayFunction? = nil, ensure: PalauEnsureArrayFunction) {
    self.key = key
    self.defaults = defaults
    self.ensure = ensure
    self.didSet = didSet
  }

  // -----------------------------------------------------------------------------------------------
  // MARK: - Public access
  // -----------------------------------------------------------------------------------------------

  /// Computed property array value
  public var value: [T.ValueType]? {
    get { return ensure(T.get(key, from: defaults)) }
    set {
      withDidSet {
        T.set(self.ensure(newValue), forKey: self.key, in: self.defaults)
      }
    }
  }

  /// Use this function to remove a default value
  /// without additional calls of the ensure function
  //@available(*, deprecated=1.0, obsoleted=2.0, message="Name was ambiguous, use .clear()")
  @available(*, deprecated=1.0, renamed="clear")
  public func reset() {
    clear()
  }

  /// Use this function to remove a default value
  /// without additional calls of the ensure function
  public func clear() {
    withDidSet {
      self.defaults.removeObjectForKey(self.key)
    }
  }

  /// private helper to take care of didSet
  private func withDidSet(changeValue: () -> Void) {
    // check if callback necessary
    let callback: (() -> Void)?
    switch didSet {
    // get old value for callback
    case let didSet?:
      let old = ensure(T.get(key, from: defaults))
      callback = {
        didSet(newValue: self.value, oldValue: old)
      }
    // do nothing
    default:
      callback = nil
    }
    // perform remove
    changeValue()
    // perform optional callback
    callback?()
  }

  // -----------------------------------------------------------------------------------------------
  // MARK: - Rules
  // -----------------------------------------------------------------------------------------------

  /// Helper function to take care of the value thats is read and written
  /// usage like:
  /// The functions provided for 'when' parameter can be implemented for any use case
  /// ````
  /// public static var intValueWithMinOf10: PalauDefaultsArrayEntry<Int> {
  /// get {
  ///   return value(_autoPauseThresholdSeconds)
  ///         .ensure(when: { $0 == nil }, use: [20, 20])
  ///         .ensure(when: { $0?.count < 2 }, use: [20, 20])
  ///     }
  ///  set {}
  /// }
  /// ````
  public func ensure(when when: [T.ValueType]? -> Bool,
                          use defaultValue: [T.ValueType]) -> PalauDefaultsArrayEntry<T> {
    return PalauDefaultsArrayEntry(key: key, defaults: defaults, didSet: didSet) {
      let vx = self.ensure($0)
      return when(vx) ? defaultValue : vx
    }
  }

  /// Helper function to return a fallback in case the value is nil
  public func whenNil(use defaultValue: [T.ValueType]) -> PalauDefaultsArrayEntry<T> {
    return ensure(when: PalauDefaults.isEmpty, use: defaultValue)
  }

  // -----------------------------------------------------------------------------------------------
  // MARK: - Observer
  // -----------------------------------------------------------------------------------------------

  /// Add a callback when the value is set in the defaults
  /// - parameter callback: functions which receives the optional old and optional new values
  /// - returns: PalauDefaultsArrayEntry<T>
  public func didSet(callback: PalauDidSetArrayFunction) -> PalauDefaultsArrayEntry<T> {
    return PalauDefaultsArrayEntry(key: key, defaults: defaults, didSet: callback, ensure: ensure)
  }
  
}
