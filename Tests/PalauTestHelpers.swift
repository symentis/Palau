//
//  PalauTestHelpers.swift
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
import XCTest

import Palau

// -------------------------------------------------------------------------------------------------
// MARK: - PalauTestCase
// -------------------------------------------------------------------------------------------------

class PalauTestCase: XCTestCase {

  override func setUp() {
    super.setUp()
    cleanUpSimulatorDefaultsForSure()
  }

  override func tearDown() {
    super.tearDown()
    cleanUpSimulatorDefaultsForSure()
  }

  func cleanUpSimulatorDefaultsForSure() {
    UserDefaults.resetStandardUserDefaults()
    for (k, _) in UserDefaults.standard.dictionaryRepresentation() {
      UserDefaults.standard.removeObject(forKey: k)
    }
  }


  func getFixtureFile(_ name: String, ext: String) -> String? {
    // lets get some files from the test bundle
    let bundle = Bundle(for: type(of: self))
    return bundle.path(forResource: name, ofType: ext)
  }

}

// -------------------------------------------------------------------------------------------------
// MARK: - Test Related Helpers
// -------------------------------------------------------------------------------------------------

let lessThanTwo: ([Int]?) -> Bool = {
  return ($0?.count)! < 2
}

let lessThan10: (Int?) -> Bool = {
  return $0.map { $0 < 10 } ?? false
}

//swiftlint:disable type_name
public enum TestEnum: Int {
  case caseA
  case caseB
  case caseC
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
extension Structy: PalauCustomDefaultable {

  public static func toIntermediate(_ s: Structy) -> [String: AnyObject] {
    return ["1": s.tuple.0 as AnyObject, "2": s.tuple.1 as AnyObject]
  }

  // swiftlint:disable conditional_binding_cascade
  public static func fromIntermediate(_ dict: [String: AnyObject]) -> Structy? {
    guard let t1 = dict["1"] as? String, let t2 = dict["2"] as? String else { return nil }
    return Structy(tuple: (t1, t2))
  }

}

// make our struct equatable for our test
extension Structy: Equatable {}

// we need a global == infix operator that supports Structy == Structy
public func == (lhs: Structy, rhs: Structy) -> Bool {
  return lhs.tuple.0 == rhs.tuple.0 && lhs.tuple.1 == rhs.tuple.1
}
