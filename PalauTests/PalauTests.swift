//
//  PalauTests.swift
//  PalauTests
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

import XCTest
import Foundation
import CoreGraphics

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

  // -----------------------------------------------------------------------------------------------
  // MARK: - Internal Helper
  // -----------------------------------------------------------------------------------------------

  /// Helper for checking values
  /// - parameter entry: PalauDefaultsEntry
  /// - parameter value: T.ValueType
  func checkValue<T where
    T: PalauDefaultable,
    T.ValueType: Equatable
    >(inout entry: PalauDefaultsEntry<T>, value: T.ValueType) {

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
    entry.clear()
    print(entry, "set again to nil")
    assert(entry.value == nil)

    // set it again
    entry.value = value
    print(entry, "set again to", value)

    // check it still matches
    assert(entry.value! == value)
    print("Done")
  }

  // -----------------------------------------------------------------------------------------------
  // MARK: - Test Types
  // -----------------------------------------------------------------------------------------------

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
      checkValue(&PalauDefaults.stringValue, value: s)
      checkValue(&PalauDefaults.nsStringValue, value: NSString(string: s))
    }

    // test a html file
    let htmlString = try String(contentsOfFile: getFixtureFile("example", ext:"html")!)
    checkValue(&PalauDefaults.stringValue, value: htmlString)
    checkValue(&PalauDefaults.nsStringValue, value: NSString(string: htmlString))

    // test a crazy UTF-8 example
    let utf8String = try String(contentsOfFile: getFixtureFile("UTF-8-demo", ext:"txt")!)
    checkValue(&PalauDefaults.stringValue, value: utf8String)
    checkValue(&PalauDefaults.nsStringValue, value: NSString(string: utf8String))

    // test quickbrownfox in multiple languages
    let quickBrownString = try String(contentsOfFile: getFixtureFile("quickbrown", ext:"txt")!)
    checkValue(&PalauDefaults.stringValue, value: quickBrownString)
    checkValue(&PalauDefaults.nsStringValue, value: NSString(string: quickBrownString))
  }

  func testBoolValue() {
    checkValue(&PalauDefaults.boolValue, value: true)
    checkValue(&PalauDefaults.boolValue, value: false)
    checkValue(&PalauDefaults.boolValue, value: CBool(true))
    checkValue(&PalauDefaults.boolValue, value: CBool(false))
    checkValue(&PalauDefaults.boolValue, value: BooleanLiteralType(true))
    checkValue(&PalauDefaults.boolValue, value: BooleanLiteralType(false))
  }

  #if __LP64__
  func test64bitOnly () {

    // test max 64 bit unsigned int nine quintillion
    let reallyBigInt = 9_223_372_036_854_775_807
    checkValue(&PalauDefaults.intValue, value: reallyBigInt)

    // test max 64 bit signed int negative nine quintillion
    let reallyNegativeBigInt = -9_223_372_036_854_775_808
    checkValue(&PalauDefaults.intValue, value: reallyNegativeBigInt)

    let reallyBitUnsignedInt: UInt = 9_223_372_036_854_775_807
    checkValue(&PalauDefaults.uIntValue, value: reallyBitUnsignedInt)

    // really big int as NSNumber
    let reallyBigNSNumber: NSNumber = NSNumber(integer: 9_223_372_036_854_775_807)
    checkValue(&PalauDefaults.nsNumberValue, value: reallyBigNSNumber)
  }
  #endif

  func testIntValue() {
    // test some vanilla ints
    for i in [1, 2, 3, 4, 5, 6, 100, -44] {
      checkValue(&PalauDefaults.intValue, value: i)
    }

    let binaryInteger = 0b10001       // 17 in binary notation
    checkValue(&PalauDefaults.intValue, value: binaryInteger)

    let octalInteger = 0o21           // 17 in octal notation
    checkValue(&PalauDefaults.intValue, value: octalInteger)

    let hexadecimalInteger = 0x11     // 17 in hexadecimal notation
    checkValue(&PalauDefaults.intValue, value: hexadecimalInteger)
  }

  func testNSNumberValue() {
    for i in [1, 2, 3, 4, 5, 6, 100, -44] {
      let testNumber: NSNumber = NSNumber(integer: i)
      checkValue(&PalauDefaults.nsNumberValue, value: testNumber)
    }

    let nsDecimalNumber = NSDecimalNumber(integer: 1)
    checkValue(&PalauDefaults.nsNumberValue, value: nsDecimalNumber)
  }

  func testFloatValue() {
    // some weird double literals
    let decimalFloat: Float = 12.1875
    checkValue(&PalauDefaults.floatValue, value: decimalFloat)

    let exponentFloat: Float = 1.21875e1
    checkValue(&PalauDefaults.floatValue, value: exponentFloat)

    let hexadecimalFloat: Float = 0xC.3p0
    checkValue(&PalauDefaults.floatValue, value: hexadecimalFloat)

    let paddedDouble: Float = 000123.456
    checkValue(&PalauDefaults.floatValue, value: paddedDouble)

    let justOverOneMillion: Float = 1_000_000.000_000_1
    checkValue(&PalauDefaults.floatValue, value: justOverOneMillion)

    let fmin = FLT_MIN
    checkValue(&PalauDefaults.floatValue, value: fmin)

    let fmax = FLT_MAX
    checkValue(&PalauDefaults.floatValue, value: fmax)

    let inf = Float.infinity
    checkValue(&PalauDefaults.floatValue, value: inf)
  }

  func testDoubleValue() {
    // some weird double literals
    let decimalDouble = 12.1875
    checkValue(&PalauDefaults.doubleValue, value: decimalDouble)

    let exponentDouble = 1.21875e1
    checkValue(&PalauDefaults.doubleValue, value: exponentDouble)

    let hexadecimalDouble = 0xC.3p0
    checkValue(&PalauDefaults.doubleValue, value: hexadecimalDouble)

    let paddedDouble = 000123.456
    checkValue(&PalauDefaults.doubleValue, value: paddedDouble)

    let justOverOneMillion = 1_000_000.000_000_1
    checkValue(&PalauDefaults.doubleValue, value: justOverOneMillion)


    let dmin = DBL_MIN
    checkValue(&PalauDefaults.doubleValue, value: dmin)

    let dmax = DBL_MAX
    checkValue(&PalauDefaults.doubleValue, value: dmax)

    let inf = Double.infinity
    checkValue(&PalauDefaults.doubleValue, value: inf)
  }

  func testDateValue() {
    checkValue(&PalauDefaults.dateValue, value: NSDate())
  }

  func testEnsuredIntValue() {
    PalauDefaults.ensuredIntValue.value = nil
    assert(PalauDefaults.ensuredIntValue.value == 10)
    PalauDefaults.ensuredIntValue.value = 12
    assert(PalauDefaults.ensuredIntValue.value == 12)
    PalauDefaults.ensuredIntValue.value = 8
    assert(PalauDefaults.ensuredIntValue.value == 10)
  }

  func testNSArrayValue() {
    let array = NSArray(array: [1, NSDate(), NSString(string: "test")])
    checkValue(&PalauDefaults.nsArrayValue, value: array)

    let mutableArray = NSMutableArray(array: [1, NSDate(), NSString(string: "test")])
    checkValue(&PalauDefaults.nsArrayValue, value: mutableArray)
  }

  func testStringArrayValue() {
    // We can't use the checkValue method here until we get Swift 3
    // TODO Swift 3: Array/Dictionary: PalauDefaultable where Element: PalauDefaultable
    PalauDefaults.stringArrayValue.value = nil
    assert(PalauDefaults.stringArrayValue.value == nil)
    PalauDefaults.stringArrayValue.value = ["a", "b"]
    assert(PalauDefaults.stringArrayValue.value! == ["a", "b"])
  }

  func testStringMapValue() {
    // We can't use the checkValue method here until we get Swift 3
    // TODO Swift 3: Array/Dictionary: PalauDefaultable where Element: PalauDefaultable
    PalauDefaults.stringMapValue.value = nil
    assert(PalauDefaults.stringMapValue.value == nil)
    PalauDefaults.stringMapValue.value = ["a": "b", "b": "a"]
    assert(PalauDefaults.stringMapValue.value! ==  ["a": "b", "b": "a"])
  }

  func testNSDictionaryValue() {
    let dictionary = NSDictionary(dictionary: ["key": "value", NSDate(): NSNumber(integer: 1)])
    checkValue(&PalauDefaults.nsDictionaryValue, value: dictionary)

    let mutableDictionary = NSMutableDictionary(
      dictionary: ["key": "value", NSDate(): NSNumber(integer: 1)]
    )
    checkValue(&PalauDefaults.nsDictionaryValue, value: mutableDictionary)
  }

  func testNSDataValue() {
    let data = NSData(contentsOfFile: getFixtureFile("UTF-8-demo", ext:"txt")!)!
    checkValue(&PalauDefaults.dataValue, value: data)
  }

  func testNSUrlValue() {
    let url = NSURL(string: "http://symentis.com")!
    checkValue(&PalauDefaults.nsUrlValue, value: url)
  }

  func testNSIndexPathValue() {
    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
    checkValue(&PalauDefaults.nsIndexPathValue, value: indexPath)
  }

  // test if we can get a default UIColor from a property
  func testUIColorDefaultValue() {
    let redColor = PalauDefaults.ensuredUIColorValue.value
    let redColor2 = PalauDefaults.whenNilledUIColorValue.value

    // UIColor sometimes returns different versions UIDeviceRGBColorSpace / UIDeviceWhiteColorSpace
    assert(CGColorEqualToColor(redColor!.CGColor, UIColor.redColor().CGColor))
    assert(redColor2 == UIColor.redColor())
  }

  func testEnumValue() {
    for e in [TestEnum.CaseA, TestEnum.CaseB, TestEnum.CaseC] {
      checkValue(&PalauDefaults.enumValue, value: e)
    }
  }
  
  func testEnumValueWithDidSet() {
    
    func assertIsEqual(new new: TestEnum?, old: TestEnum?) -> (TestEnum?, TestEnum?) -> Void {
      return { e1, e2 in
        let equal = new == e1 && old == e2
        print(e1, e2)
        assert(equal)
      }
    }
    
    PalauDefaults.enumValueWithDidSet.value = nil
  
    var enumWithDidSet = PalauDefaults.enumValueWithDidSet.didSet(assertIsEqual(new: TestEnum.CaseB, old: nil))
    
    enumWithDidSet.value = TestEnum.CaseB
    
  }

}

// -------------------------------------------------------------------------------------------------
// MARK: - Test Related Helpers
// -------------------------------------------------------------------------------------------------

let lessThan10: Int? -> Bool = {
  return $0.map { $0 < 10 } ?? false
}

extension PalauDefaults {

  public static var boolValue: PalauDefaultsEntry<Bool> {
    get { return value("boolValue") }
    set { }
  }

  public static var intValue: PalauDefaultsEntry<Int> {
    get { return value("intValue") }
    set { }
  }

  public static var ensuredIntValue: PalauDefaultsEntry<Int> {
    get { return value("ensuredIntValue")
      .ensure(when: PalauDefaults.isEmpty, use: 10)
      .ensure(when: lessThan10, use: 10) }
    set { }
  }

  public static var ensuredUIColorValue: PalauDefaultsEntry<UIColor> {
    get { return value("ensuredUIColorValue")
      .ensure(when: PalauDefaults.isEmpty, use: UIColor.redColor()) }
    set { }
  }

  public static var whenNilledUIColorValue: PalauDefaultsEntry<UIColor> {
    get { return value("whenNilledUIColorValue")
      .whenNil(use: UIColor.redColor()) }
    set { }
  }

  public static var uIntValue: PalauDefaultsEntry<UInt> {
    get { return value("uIntValue") }
    set { }
  }

  public static var floatValue: PalauDefaultsEntry<Float> {
    get { return value("floatValue") }
    set { }
  }

  public static var doubleValue: PalauDefaultsEntry<Double> {
    get { return value("doubleValue") }
    set { }
  }

  public static var nsNumberValue: PalauDefaultsEntry<NSNumber> {
    get { return value("nsNumberValue") }
    set { }
  }

  public static var stringValue: PalauDefaultsEntry<String> {
    get { return value("stringValue") }
    set { }
  }

  public static var nsStringValue: PalauDefaultsEntry<NSString> {
    get { return value("nsStringValue") }
    set { }
  }

  public static var stringArrayValue: PalauDefaultsEntry<[String]> {
    get { return value("stringArrayValue") }
    set { }
  }

  public static var nsArrayValue: PalauDefaultsEntry<NSArray> {
    get { return value("nsArrayValue") }
    set { }
  }

  public static var stringMapValue: PalauDefaultsEntry<[String: String]> {
    get { return value("stringMapValue") }
    set { }
  }

  public static var nsDictionaryValue: PalauDefaultsEntry<NSDictionary> {
    get { return value("nsDictionaryValue") }
    set { }
  }

  public static var dateValue: PalauDefaultsEntry<NSDate> {
    get { return value("dateValue") }
    set { }
  }

  public static var dataValue: PalauDefaultsEntry<NSData> {
    get { return value("dataValue") }
    set { }
  }

  public static var nsUrlValue: PalauDefaultsEntry<NSURL> {
    get { return value("nsUrlValue") }
    set { }
  }

  public static var nsIndexPathValue: PalauDefaultsEntry<NSIndexPath> {
    get { return value("nsIndexPathValue") }
    set { }
  }

  public static var enumValue: PalauDefaultsEntry<TestEnum> {
    get { return value("testEnumValue") }
    set { }
  }
  
  public static var enumValueWithDidSet: PalauDefaultsEntry<TestEnum> {
    get { return value("testEnumValueWithDidSet") }
    set { }
  }
}

public enum TestEnum: Int {
  case CaseA
  case CaseB
  case CaseC
}

extension TestEnum: PalauDefaultable {
  public typealias ValueType = TestEnum
}
