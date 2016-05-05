//
//  PalauEntry.swift
//  Palau
//
//  Created by Elmar Kretzer on 05.05.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
//

import Foundation

// -----------------------------------------------------------------------------------------------
// MARK: - PalauEntry Protocol
// -----------------------------------------------------------------------------------------------

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
  var didSet: ((newValue: ReturnType?, oldValue: ReturnType?) -> Void)? { get }

  /// computed property for the return value
  var value: ReturnType? { get set }

  /// inititalizer
  init(key: String,
       defaults: NSUD,
       didSet: ((newValue: ReturnType?, oldValue: ReturnType?) -> Void)?,
       ensure: (ReturnType?) -> ReturnType?
  )

}

// -----------------------------------------------------------------------------------------------
// MARK: - PalauEntry Default Extension
// -----------------------------------------------------------------------------------------------

extension PalauEntry {

  // ---------------------------------------------------------------------------------------------
  // MARK: - Clear
  // ---------------------------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------------------------
  // MARK: - DidSet Observation
  // ---------------------------------------------------------------------------------------------

  /// private helper to take care of didSet
  func withDidSet(changeValue: () -> Void) {
    let callback: (() -> Void)?
    // check if callback is necessary as optional didSet is provided
    if let didSet = didSet {
      let old = value
      callback = { didSet(newValue: self.value, oldValue: old) }
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
  /// ````
  /// public static var intValueWithMinOf10: PalauDefaultsEntry<Int> {
  /// get {
  ///   return value("intValue")
  ///         .ensure(when: isEqual(0), use: 20)
  ///         .ensure(when: lessThan(10), use: 10)
  ///     }
  ///  set {}
  /// }
  /// ````
  public func ensure(when when: ReturnType? -> Bool,
                          use defaultValue: ReturnType) -> Self {
    return Self(key: key, defaults: defaults, didSet: didSet) {
      let vx = self.ensure($0)
      return when(vx) ? defaultValue : vx
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
  public func didSet(callback: ((newValue: ReturnType?, oldValue: ReturnType?) -> Void)) -> Self {
    return Self(key: key, defaults: defaults, didSet: callback, ensure: ensure)
  }

}
