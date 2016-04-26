//
//  PalauTests.swift
//  PalauTests
//
//  Created by symentis GmbH on 26.04.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
//

import XCTest
import Foundation
import Darwin

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

  // ----------------------------------------------------------------------------------------------
  // MARK: - Internal Helper
  // ----------------------------------------------------------------------------------------------

  /// Helper for checking values
  /// - parameter entry: UserDefaultsEntry
  /// - parameter value: T.ValueType
  func checkValue<T where
    T: UserDefaultable,
    T.ValueType: Equatable
    >(inout entry: UserDefaultsEntry<T>, value: T.ValueType) {

    // nil the entry
    entry.value = nil
    print(entry, "set to nil")
    assert(entry.value == nil)

    // set the value
    entry.value = value
    print(entry, "set to", value)

    // check the force unwrapped value in the entry match the original value
    assert(entry.value! == value)

    // clear it another way
    entry.reset()
    print(entry, "set again to nil")
    assert(entry.value == nil)

    // set it again
    entry.value = value
    print(entry, "set again to", value)

    // check it still matches
    assert(entry.value! == value)
    print("Done")
  }

  // ----------------------------------------------------------------------------------------------
  // MARK: - Test Types
  // ----------------------------------------------------------------------------------------------

  func getFixtureFile(name: String, ext: String) -> String? {
    // lets get some files from the test bundle
    let bundle = NSBundle(forClass: self.dynamicType)
    return bundle.pathForResource("Fixtures/" + name, ofType: ext)
  }

  // test String and NSString
  func testStringValue() throws {
    let strings = [
      "German äöü ß",
      "Kanji 漢字",
      "Korean 한국어/조선말",
      "Traditional Chinese 中文維基百科",
      "Simplified Chinese 中文维基百科",
      "Pinyin Zhōngwén Wéijī Bǎikē",
      "Emoticons 👻🐦😺👿🈲🗿"
    ]

    // test these strings
    for s in strings {
      checkValue(&UserDefaults.stringValue, value: s)
      checkValue(&UserDefaults.nsStringValue, value: NSString(string: s))
    }

    // test a html file
    let htmlString = try String(contentsOfFile: getFixtureFile("example", ext:"html")!)
    checkValue(&UserDefaults.stringValue, value: htmlString)
    checkValue(&UserDefaults.nsStringValue, value: NSString(string: htmlString))

    // test a crazy UTF-8 example
    let utf8String = try String(contentsOfFile: getFixtureFile("UTF-8-demo", ext:"txt")!)
    checkValue(&UserDefaults.stringValue, value: utf8String)
    checkValue(&UserDefaults.nsStringValue, value: NSString(string: utf8String))

    // test quickbrownfox in multiple languages
    let quickBrownString = try String(contentsOfFile: getFixtureFile("quickbrown", ext:"txt")!)
    checkValue(&UserDefaults.stringValue, value: quickBrownString)
    checkValue(&UserDefaults.nsStringValue, value: NSString(string: quickBrownString))
  }

  func testBoolValue() {
    checkValue(&UserDefaults.boolValue, value: true)
    checkValue(&UserDefaults.boolValue, value: false)
    checkValue(&UserDefaults.boolValue, value: CBool(true))
    checkValue(&UserDefaults.boolValue, value: CBool(false))
    checkValue(&UserDefaults.boolValue, value: BooleanLiteralType(true))
    checkValue(&UserDefaults.boolValue, value: BooleanLiteralType(false))
  }

  func testIntValue() {
    // test some vanilla ints
    for i in [1, 2, 3, 4, 5, 6, 100, -44] {
      checkValue(&UserDefaults.intValue, value: i)
    }

    // test max 64 bit unsigned int nine quintillion
    let reallyBigInt = 9_223_372_036_854_775_807
    checkValue(&UserDefaults.intValue, value: reallyBigInt)

    // test max 64 bit signed int negative nine quintillion
    let reallyNegativeBigInt = -9_223_372_036_854_775_808
    checkValue(&UserDefaults.intValue, value: reallyNegativeBigInt)

    let binaryInteger = 0b10001       // 17 in binary notation
    checkValue(&UserDefaults.intValue, value: binaryInteger)

    let octalInteger = 0o21           // 17 in octal notation
    checkValue(&UserDefaults.intValue, value: octalInteger)

    let hexadecimalInteger = 0x11     // 17 in hexadecimal notation
    checkValue(&UserDefaults.intValue, value: hexadecimalInteger)

    let reallyBitUnsignedInt: UInt = 9_223_372_036_854_775_807
    checkValue(&UserDefaults.uIntValue, value: reallyBitUnsignedInt)
  }

  func testNSNumberValue() {
    for i in [1, 2, 3, 4, 5, 6, 100, -44] {
      let testNumber: NSNumber = NSNumber(integer: i)
      checkValue(&UserDefaults.nsNumberValue, value: testNumber)
    }

    // really big int as NSNumber
    let reallyBigNSNumber: NSNumber = NSNumber(integer: 9_223_372_036_854_775_807)
    checkValue(&UserDefaults.nsNumberValue, value: reallyBigNSNumber)

    let nsDecimalNumber = NSDecimalNumber(integer: 1)
    checkValue(&UserDefaults.nsNumberValue, value: nsDecimalNumber)
  }

  func testFloatValue() {
    // some weird double literals
    let decimalFloat: Float = 12.1875
    checkValue(&UserDefaults.floatValue, value: decimalFloat)

    let exponentFloat: Float = 1.21875e1
    checkValue(&UserDefaults.floatValue, value: exponentFloat)

    let hexadecimalFloat: Float = 0xC.3p0
    checkValue(&UserDefaults.floatValue, value: hexadecimalFloat)

    let paddedDouble: Float = 000123.456
    checkValue(&UserDefaults.floatValue, value: paddedDouble)

    let justOverOneMillion: Float = 1_000_000.000_000_1
    checkValue(&UserDefaults.floatValue, value: justOverOneMillion)

    let fmin = FLT_MIN
    checkValue(&UserDefaults.floatValue, value: fmin)

    let fmax = FLT_MAX
    checkValue(&UserDefaults.floatValue, value: fmax)

    let inf = Float.infinity
    checkValue(&UserDefaults.floatValue, value: inf)
  }

  func testDoubleValue() {
    // some weird double literals
    let decimalDouble = 12.1875
    checkValue(&UserDefaults.doubleValue, value: decimalDouble)

    let exponentDouble = 1.21875e1
    checkValue(&UserDefaults.doubleValue, value: exponentDouble)

    let hexadecimalDouble = 0xC.3p0
    checkValue(&UserDefaults.doubleValue, value: hexadecimalDouble)

    let paddedDouble = 000123.456
    checkValue(&UserDefaults.doubleValue, value: paddedDouble)

    let justOverOneMillion = 1_000_000.000_000_1
    checkValue(&UserDefaults.doubleValue, value: justOverOneMillion)


    let dmin = DBL_MIN
    checkValue(&UserDefaults.doubleValue, value: dmin)

    let dmax = DBL_MAX
    checkValue(&UserDefaults.doubleValue, value: dmax)

    let inf = Double.infinity
    checkValue(&UserDefaults.doubleValue, value: inf)
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

  func testNSArrayValue() {
    let array = NSArray(array: [1, NSDate(), NSString(string: "test")])
    checkValue(&UserDefaults.nsArrayValue, value: array)

    let mutableArray = NSMutableArray(array: [1, NSDate(), NSString(string: "test")])
    checkValue(&UserDefaults.nsArrayValue, value: mutableArray)
  }

  func testStringArrayValue() {
    // We can't use the checkValue method here until we get Swift 3
    // TODO Swift 3: Array/Dictionary: UserDefaultable where Element: UserDefaultable
    UserDefaults.stringArrayValue.value = nil
    assert(UserDefaults.stringArrayValue.value == nil)
    UserDefaults.stringArrayValue.value = ["a", "b"]
    assert(UserDefaults.stringArrayValue.value! == ["a", "b"])
  }

  func testStringMapValue() {
    // We can't use the checkValue method here until we get Swift 3
    // TODO Swift 3: Array/Dictionary: UserDefaultable where Element: UserDefaultable
    UserDefaults.stringMapValue.value = nil
    assert(UserDefaults.stringMapValue.value == nil)
    UserDefaults.stringMapValue.value = ["a": "b", "b": "a"]
    assert(UserDefaults.stringMapValue.value! ==  ["a": "b", "b": "a"])
  }

  func testNSDictionaryValue() {
    let dictionary = NSDictionary(dictionary: ["key": "value", NSDate(): NSNumber(integer: 1)])
    checkValue(&UserDefaults.nsDictionaryValue, value: dictionary)

    let mutableDictionary = NSMutableDictionary(dictionary: ["key": "value", NSDate(): NSNumber(integer: 1)])
    checkValue(&UserDefaults.nsDictionaryValue, value: mutableDictionary)
  }

  func testNSDataValue() {
    let data = NSData(contentsOfFile: getFixtureFile("UTF-8-demo", ext:"txt")!)!
    checkValue(&UserDefaults.dataValue, value: data)
  }

  func testNSUrlValue() {
    let url = NSURL(string: "http://symentis.com")!
    checkValue(&UserDefaults.nsUrlValue, value: url)
  }

  func testNSIndexPathValue() {
    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
    checkValue(&UserDefaults.nsIndexPath, value: indexPath)
  }

  func testEnumValue() {
    for e in [TestEnum.CaseA, TestEnum.CaseB, TestEnum.CaseC] {
      checkValue(&UserDefaults.enumValue, value: e)
    }
  }

}

// ----------------------------------------------------------------------------------------------
// MARK: - Test Related Helpers
// ----------------------------------------------------------------------------------------------

let isEmpty: Int? -> Bool = {
  return $0 == nil
}

let lessThan10: Int? -> Bool = {
  return $0.map { $0 < 10 } ?? false
}

extension UserDefaults {

  public static var boolValue: UserDefaultsEntry<Bool> {
    get { return value("boolValue") }
    set { }
  }

  public static var intValue: UserDefaultsEntry<Int> {
    get { return value("intValue") }
    set { }
  }

  public static var ensuredIntValue: UserDefaultsEntry<Int> {
    get { return value("ensuredIntValue")
      .ensure(when: isEmpty, use: 10)
      .ensure(when: lessThan10, use: 10) }
    set { }
  }

  public static var uIntValue: UserDefaultsEntry<UInt> {
    get { return value("uIntValue") }
    set { }
  }

  public static var floatValue: UserDefaultsEntry<Float> {
    get { return value("floatValue") }
    set { }
  }

  public static var doubleValue: UserDefaultsEntry<Double> {
    get { return value("doubleValue") }
    set { }
  }

  public static var nsNumberValue: UserDefaultsEntry<NSNumber> {
    get { return value("nsNumberValue") }
    set { }
  }

  public static var stringValue: UserDefaultsEntry<String> {
    get { return value("stringValue") }
    set { }
  }

  public static var nsStringValue: UserDefaultsEntry<NSString> {
    get { return value("nsStringValue") }
    set { }
  }

  public static var stringArrayValue: UserDefaultsEntry<[String]> {
    get { return value("stringArrayValue") }
    set { }
  }

  public static var nsArrayValue: UserDefaultsEntry<NSArray> {
    get { return value("nsArrayValue") }
    set { }
  }

  public static var stringMapValue: UserDefaultsEntry<[String: String]> {
    get { return value("stringMapValue") }
    set { }
  }

  public static var nsDictionaryValue: UserDefaultsEntry<NSDictionary> {
    get { return value("nsDictionaryValue") }
    set { }
  }

  public static var dateValue: UserDefaultsEntry<NSDate> {
    get { return value("dateValue") }
    set { }
  }

  public static var dataValue: UserDefaultsEntry<NSData> {
    get { return value("dataValue") }
    set { }
  }

  public static var nsUrlValue: UserDefaultsEntry<NSURL> {
    get { return value("nsUrlValue") }
    set { }
  }

  public static var nsIndexPath: UserDefaultsEntry<NSIndexPath> {
    get { return value("nsIndexPath") }
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
