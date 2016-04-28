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
  
  /// for convenience
  public typealias PalauDidSetFunction = (newValue: T.ValueType?, oldValue: T.ValueType?) -> Void
  public typealias PalauEnsureFunction = (T.ValueType?) -> T.ValueType?

  /// The key of the entry
  public let key: String

  /// Access to the default
  let defaults: NSUserDefaults

  /// A function to change the incoming and outgoing value
  let ensure: PalauEnsureFunction
  
  /// A function as callback after set
  let didSet: PalauDidSetFunction?
  
  /// a initializer
  init(key: String, defaults: NSUserDefaults, didSet: PalauDidSetFunction? = nil, ensure: PalauEnsureFunction) {
    self.key = key
    self.defaults = defaults
    self.ensure = ensure
    self.didSet = didSet
  }

  // ----------------------------------------------------------------------------------------------
  // MARK: - Public access
  // ----------------------------------------------------------------------------------------------

  /// Computed property value
  public var value: T.ValueType? {
    get { return ensure(T.get(key, from: defaults)) }
    set {
      let new = ensure(newValue)
      guard let didSet = didSet else {
         return T.set(new, forKey: key, in: defaults)
      }
      let old = ensure(T.get(key, from: defaults))
      T.set(new, forKey: key, in: defaults)
      didSet(newValue: new, oldValue: old)
    }
  }

  /// Use this function to remove a default value
  /// without additional calls of the ensure function
  //@available(*, deprecated=1.0, obsoleted=2.0, message="Name was ambiguous, use .clear()")
  @available(*, unavailable, renamed="clear")
  public func reset() {
    defaults.removeObjectForKey(key)
  }

  /// Use this function to remove a default value
  /// without additional calls of the ensure function
  public func clear() {
    defaults.removeObjectForKey(key)
  }
  
  // ----------------------------------------------------------------------------------------------
  // MARK: - Rules
  // ----------------------------------------------------------------------------------------------

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
    return PalauDefaultsEntry(key: key, defaults: defaults, didSet: didSet) {
      let vx = self.ensure($0)
      return when(vx) ? defaultValue : vx
    }
  }

  /// Helper function to return a fallback in case the value is nil
  public func whenNil(use defaultValue: T.ValueType) -> PalauDefaultsEntry<T> {
    return ensure(when: PalauDefaults.isEmpty, use: defaultValue)
  }
  
  // ----------------------------------------------------------------------------------------------
  // MARK: - Observer
  // ----------------------------------------------------------------------------------------------

  public func didSet(callback: PalauDidSetFunction) -> PalauDefaultsEntry<T> {
    // TODO: Chainable callbacks?
    return PalauDefaultsEntry(key: key, defaults: defaults, didSet: callback, ensure: ensure)
  }
  
}
