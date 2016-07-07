//
//  PalauDefaults.swift
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

/// PalauDefaults
///
/// PalauDefaults wrap the NSUserDefaults
/// The easiest usage is:
/// - extension on PalauDefaults with:
/// ```
///   public static var name: PalauDefaultsEntry<String> {
///   get { return value("name") }
///   set { }
/// }
/// ```
public struct PalauDefaults {

  /// The underlying defaults
  public static var defaults: NSUD {
    return NSUD.standard
  }

  /// Pure - will always return the provided value
  /// used ase base ensure function
  /// - parameter value: T
  /// - returns: T
  public static func pure<T>(_ value: T) -> T {
    return value
  }

  /// isEmpty - will return a Bool of Emptyness
  /// used by whenNil method
  /// - parameter value: T?
  /// - returns: Bool
  public static func isEmpty<T>(_ value: T?) -> Bool {
    return value == nil
  }

  /// Generate a PalauDefaultsEntry of Type T for provided key
  /// - parameter key: String, name of the entry
  /// - returns: DefaultValue
  public static func value<T>(_ key: String) -> PalauDefaultsEntry<T> {
    return PalauDefaultsEntry(key:key, defaults:defaults, ensure: pure)
  }

  /// Generate a PalauDefaultsEntry of Type T for provided key
  /// - parameter key: String, name of the entry
  /// - returns: DefaultValue
  public static func value<T>(_ key: String) -> PalauDefaultsArrayEntry<T> {
    return PalauDefaultsArrayEntry(key:key, defaults:defaults, ensure: pure)
  }
}
