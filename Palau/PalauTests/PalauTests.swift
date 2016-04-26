//
//  PalauTests.swift
//  PalauTests
//
//  Created by symentis GmbH on 26.04.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
//

import XCTest
import Foundation
@testable import Palau

class PalauTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // make sure to reste the defaults each time
    NSUserDefaults.resetStandardUserDefaults()
  }

  override func tearDown() {
    super.tearDown()
  }


  /// Helper for checking values
  func checkValue<T where
    T: UserDefaultable,
    T.ValueType: Equatable
    >(inout entry: UserDefaultsEntry<T>, value: T.ValueType) {
    entry.value = nil
    print(entry, "set to nil")
    assert(entry.value == nil)
    entry.value = value
    print(entry, "set to", value)
    assert(entry.value! == value)
    entry.reset()
    print(entry, "set again to nil")
    assert(entry.value == nil)
    entry.value = value
    print(entry, "set again to", value)
    assert(entry.value! == value)
    print("Done")
  }

  func testStringValue() {
    for s in ["a", "zzz", "CCCC", "👻"] {
      checkValue(&UserDefaults.stringValue, value: s)
    }
  }

  func testBoolValue() {
    checkValue(&UserDefaults.boolValue, value: true)
    checkValue(&UserDefaults.boolValue, value: false)
  }

  func testIntValue() {
    for i in [1, 2, 3, 4, 5, 6, 100, -44] {
      checkValue(&UserDefaults.intValue, value: i)
    }
  }

  func testDateValue() {
    checkValue(&UserDefaults.dateValue, value: NSDate())
  }

  func testEnsuredIntValue() {
    UserDefaults.ensuredIntValue.value = nil
    assert(UserDefaults.ensuredIntValue.value == 10)
    UserDefaults.ensuredIntValue.value = 12
    assert(UserDefaults.ensuredIntValue.value == 12)
    UserDefaults.ensuredIntValue.value = 8
    assert(UserDefaults.ensuredIntValue.value == 10)
  }


  func testStringArrayValue() {
    // wait for extension Array: UserDefaultable where Element: UserDefaultable in swift 3
    UserDefaults.stringArrayValue.value = nil
    assert(UserDefaults.stringArrayValue.value == nil)
    UserDefaults.stringArrayValue.value = ["a", "b"]
    assert(UserDefaults.stringArrayValue.value! == ["a", "b"])
  }

  func testNSStringValue() {
    checkValue(&UserDefaults.nsStringValue, value: NSString(string: "abc"))
  }

  func testStringMapValue() {
    // wait for extension Array: UserDefaultable where Element: UserDefaultable in swift 3
    UserDefaults.stringMapValue.value = nil
    assert(UserDefaults.stringMapValue.value == nil)
    UserDefaults.stringMapValue.value = ["a": "b", "b": "a"]
    assert(UserDefaults.stringMapValue.value! ==  ["a": "b", "b": "a"])
  }

  func testenumValue() {
    for e in [TestEnum.CaseA, TestEnum.CaseB, TestEnum.CaseC] {
      checkValue(&UserDefaults.enumValue, value: e)
    }
  }

}


let isEmpty: Int? -> Bool = {
  return $0 == nil
}

let lessThan10: Int? -> Bool = {
  return $0.map { $0 < 10 } ?? false
}

extension NSString: UserDefaultable {
  public typealias ValueType = NSString
}

extension UserDefaults {

  public static var ensuredIntValue: UserDefaultsEntry<Int> {
    get { return value("ensuredIntValue")
      .ensure(when: isEmpty, use: 10)
      .ensure(when: lessThan10, use: 10) }
    set { }
  }

  public static var stringValue: UserDefaultsEntry<String> {
    get { return value("stringValue") }
    set { }
  }

  public static var stringMapValue: UserDefaultsEntry<[String: String]> {
    get { return value("stringMapValue") }
    set { }
  }

  public static var nsStringValue: UserDefaultsEntry<NSString> {
    get { return value("nsstringValue") }
    set { }
  }

  public static var stringArrayValue: UserDefaultsEntry<[String]> {
    get { return value("stringArrayValue") }
    set { }
  }

  public static var boolValue: UserDefaultsEntry<Bool> {
    get { return value("boolValue") }
    set { }
  }

  public static var intValue: UserDefaultsEntry<Int> {
    get { return value("intValue") }
    set { }
  }

  public static var dateValue: UserDefaultsEntry<NSDate> {
    get { return value("dateValue") }
    set { }
  }

  public static var enumValue: UserDefaultsEntry<TestEnum> {
    get { return value("testEnumValue") }
    set { }
  }

}

public enum TestEnum: Int {
  case CaseA
  case CaseB
  case CaseC
}

extension TestEnum: UserDefaultable {
  public typealias ValueType = TestEnum
}
