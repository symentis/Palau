//
//  PalauTestHelpers.swift
//  Palau
//
//  Created by symentis on 05.05.16.
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

import Palau
// -------------------------------------------------------------------------------------------------
// MARK: - Test Related Helpers
// -------------------------------------------------------------------------------------------------


let lessThanTwo: [Int]? -> Bool = {
  return $0?.count < 2
}

let lessThan10: Int? -> Bool = {
  return $0.map { $0 < 10 } ?? false
}

public enum TestEnum: Int {
  case CaseA
  case CaseB
  case CaseC
}

extension TestEnum: PalauDefaultable {
  public typealias ValueType = TestEnum
}

// -------------------------------------------------------------------------------------------------
// MARK: - Struct Example
// -------------------------------------------------------------------------------------------------

// example Struct called Structy for demonstrating we can save a Struct with Palau
public struct Structy {
  let tuple: (String, String)
}

// our Structy PalauDefaultable extension allowing the mapping between PalauDefaults and the Type
// here we just map the two values to two keys named "1" and "2"
extension Structy: PalauDefaultable {

  private static func toDict(from s: Structy) -> [String: AnyObject] {
    return ["1": s.tuple.0, "2": s.tuple.1]
  }

  private static func fromDict(dict: [String: AnyObject]) -> Structy? {
    guard let t1 = dict["1"] as? String,
      t2 = dict["2"] as? String else { return nil }
    return Structy(tuple: (t1, t2))
  }

  public static func get(key: String, from defaults: NSUD) -> Structy? {
    guard let d = defaults.objectForKey(key) as? [String: AnyObject] else { return nil }
    return fromDict(d)
  }

  public static func get(key: String, from defaults: NSUD) -> [Structy]? {
    guard let d = defaults.objectForKey(key) as? [[String: AnyObject]] else { return nil }
    return d.flatMap(fromDict)
  }

  public static func set(value: Structy?, forKey key: String, in defaults: NSUD) -> Void {
    guard let value = value else { return defaults.setObject(nil, forKey: key) }
    defaults.setObject(toDict(from: value), forKey: key)
  }

  public static func set(value: [Structy]?, forKey key: String, in defaults: NSUD) -> Void {
    guard let value = value else { return defaults.setObject(nil, forKey: key) }
    defaults.setObject(value.map(toDict), forKey: key)
  }
}

// make our struct equatable for our test
extension Structy: Equatable {}

// we need a global == infix operator that supports Structy == Structy
public func == (lhs: Structy, rhs: Structy) -> Bool {
  return lhs.tuple.0 == rhs.tuple.0 && lhs.tuple.1 == rhs.tuple.1
}
