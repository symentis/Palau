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


/// A PalauDefaultsArrayEntry
///
/// This entry takes care of list of values like
/// ```
/// public static var intValues: PalauDefaultsArrayEntry<Int>
///   get { return value("intValues") }
///   set { }
/// }
/// ```
/// The value of the PalauDefaultsArrayEntry is always an optional list e.g.
/// ```
/// // val is of type [Int]?
/// let values = PalauDefaults.intValues.value
/// ```
public struct PalauDefaultsArrayEntry<T: PalauDefaultable>: PalauEntry where T.ValueType == T {

  public typealias ValueType = T
  public typealias ReturnType = [T]
  /// for convenience
  public typealias PalauDidSetArrayFunction = (_ newValue: ReturnType?, _ oldValue: ReturnType?) -> Void
  public typealias PalauEnsureArrayFunction = (ReturnType?) -> ReturnType?

  /// The key of the entry
  public let key: String

  /// Access to the default
  public let defaults: NSUD

  /// A function to change the incoming and outgoing value
  public let ensure: PalauEnsureArrayFunction

  /// A function as callback after set
  public let didSet: PalauDidSetArrayFunction?

  /// a initializer

 public init(key: String, defaults: UserDefaults, didSet: (([T]?, [T]?) -> Void)? = nil, ensure: @escaping ([T]?) -> [T]?) {
    self.key = key
    self.defaults = defaults
    self.ensure = ensure
    self.didSet = didSet
  }

  /// The value
  /// use this property to get the Optional<ReturnType>
  /// or to set the ReturnType
  public var value: ReturnType? {
    get {
      return ensure(ValueType.get(key, from: defaults))
    }
    set {
      withDidSet {
        ValueType.set(self.ensure(newValue), forKey: self.key, in: self.defaults)
      }
    }
  }
}
