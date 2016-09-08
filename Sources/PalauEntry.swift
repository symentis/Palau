//
//  PalauEntry.swift
//  Palau
//
//  Created by symentis GmbH on 05.05.16.
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

// -------------------------------------------------------------------------------------------------
// MARK: - PalauEntry Protocol
// -------------------------------------------------------------------------------------------------

/// PalauEntry is the base protocol for PalauEntry or PalauArrayEntry
/// By extending the protocol we can provide the default functionality
/// to both types
public protocol PalauEntry {

  /// the ValueType must conform to PalauDefaultable
  associatedtype ValueType: PalauDefaultable

  /// the return type can be e.g. ValueType or [ValueType]
  associatedtype ReturnType

  /// the key in defaults
  var key: String { get }

  /// access to the defaults
  var defaults: NSUD { get }

  /// A function to change the incoming and outgoing value
  var ensure: (ReturnType?) -> ReturnType? { get }

  /// A function as callback after set
  var didSet: ((_ newValue: ReturnType?, _ oldValue: ReturnType?) -> Void)? { get }

  /// computed property for the return value
  var value: ReturnType? { get set }

  /// inititalizer
//  init(key: String,
//       defaults: NSUD,
//       ensure: @escaping (ReturnType?) -> ReturnType?
//  )

  init(key: String,
       defaults: NSUD,
       didSet: ((_ newValue: ReturnType?, _ oldValue: ReturnType?) -> Void)?,
       ensure: @escaping (ReturnType?) -> ReturnType?
  )

}

// -------------------------------------------------------------------------------------------------
// MARK: - PalauEntry Default Extension
// -------------------------------------------------------------------------------------------------

extension PalauEntry {

  // -----------------------------------------------------------------------------------------------
  // MARK: - Clear
  // -----------------------------------------------------------------------------------------------
  /// Use this function to remove a default value
  /// without additional calls of the ensure function
  public func clear() {
    withDidSet {
      self.defaults.removeObject(forKey: self.key)
    }
  }

  // -----------------------------------------------------------------------------------------------
  // MARK: - DidSet Observation
  // -----------------------------------------------------------------------------------------------

  /// private helper to take care of didSet
  func withDidSet(_ changeValue: () -> Void) {
    let callback: (() -> Void)?
    // check if callback is necessary as optional didSet is provided
    if let didSet = didSet {
      let old = value
      callback = { didSet(self.value, old) }
    } else {
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
  /// ```
  /// public static var intValueWithMinOf10: PalauDefaultsEntry<Int> {
  /// get {
  ///   return value("intValue")
  ///         .ensure(when: isEqual(0), use: 20)
  ///         .ensure(when: lessThan(10), use: 10)
  ///     }
  ///  set {}
  /// }
  /// ```
  public func ensure(when whenFunc: @escaping (ReturnType?) -> Bool,
                          use defaultValue: ReturnType) -> Self {
//    if let didSet = didSet {
//      return Self(key: key, defaults: defaults, didSet: didSet) {
//        let vx = self.ensure($0)
//        return whenFunc(vx) ? defaultValue : vx
//      }
//    }
    return Self(key: key, defaults: defaults, didSet: didSet) {
      let vx = self.ensure($0)
      return whenFunc(vx) ? defaultValue : vx
    }
  }

  /// Helper function to return a fallback in case the value is nil
  public func whenNil(use defaultValue: ReturnType) -> Self {
    return ensure(when: PalauDefaults.isEmpty, use: defaultValue)
  }

  // -----------------------------------------------------------------------------------------------
  // MARK: - Observer
  // -----------------------------------------------------------------------------------------------

  /// Add a callback when the value is set in the defaults
  /// - parameter callback: functions which receives the optional old and optional new vale
  /// - returns: PalauDefaultsEntry<T>
  public func didSet(_ callback: @escaping ((_ newValue: ReturnType?, _ oldValue: ReturnType?) -> Void)) -> Self {
    return Self(key: key, defaults: defaults, didSet: callback, ensure: ensure)
  }

}
