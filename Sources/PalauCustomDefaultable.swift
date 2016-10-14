//
//  PalauCustomDefaultable.swift
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
// MARK: - PalauCustomDefaultable
// -------------------------------------------------------------------------------------------------

/// PalauCustomDefaultable Protocol
/// Custom Types likes Structs that can be written to defaults should implement this
///```
///extension Structy: PalauCustomDefaultable {
///
///  public static func toIntermediate(s: Structy) -> [String: AnyObject] {
///    return ["1": s.tuple.0, "2": s.tuple.1]
///  }
///
///  public static func fromIntermediate(dict: [String: AnyObject]) -> Structy? {
///    guard let t1 = dict["1"] as? String,
///      t2 = dict["2"] as? String else { return nil }
///    return Structy(tuple: (t1, t2))
///  }
///
///}
///```
public protocol PalauCustomDefaultable: PalauDefaultable {

  /// typically a `[String: AnyObject]`
  associatedtype IntermediateType

  /// function to map Self to IntermediateType like [String: AnyObject]
  static func toIntermediate(_: Self) -> IntermediateType

  /// function to map IntermediateType to Self
  static func fromIntermediate(_: IntermediateType) -> Self?

}

// -------------------------------------------------------------------------------------------------
// MARK: - PalauCustomDefaultable Extension
// -------------------------------------------------------------------------------------------------

/// We provide get and set functionality out-of-the box
public extension PalauCustomDefaultable {

  /// default implementation
  static func get(_ key: String, from defaults: NSUD) -> Self? {
    guard let d = defaults.object(forKey: key) as? IntermediateType else { return nil }
    return fromIntermediate(d)
  }

  /// default implementation
  static func get(_ key: String, from defaults: NSUD) -> [Self]? {
    guard let d = defaults.object(forKey: key) as? [IntermediateType] else { return nil }
    let v = d.flatMap(fromIntermediate)
    return v
  }

  /// default implementation
  static func set(_ value: Self?, forKey key: String, in defaults: NSUD) -> Void {
    guard let value = value else { return defaults.set(nil, forKey: key) }
    defaults.set(toIntermediate(value), forKey: key)
  }

  /// default implementation
  static func set(_ value: [Self]?, forKey key: String, in defaults: NSUD) -> Void {
    guard let value = value else { return defaults.set(nil, forKey: key) }
    let v = value.flatMap(toIntermediate)
    defaults.set(v, forKey: key)
  }

}
