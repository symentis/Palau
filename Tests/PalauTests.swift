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

class PalauTests: PalauTestCase {

  // -----------------------------------------------------------------------------------------------
  // MARK: - Test Types
  // -----------------------------------------------------------------------------------------------

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
      PalauDefaults.stringValue.checkValue(s, printTest: false)
      PalauDefaults.nsStringValue.checkValue(NSString(string: s), printTest: false)
    }

    // test a html file
    let htmlString = try String(contentsOfFile: getFixtureFile("example", ext:"html")!)
    PalauDefaults.stringValue.checkValue(htmlString, printTest: false)
    PalauDefaults.nsStringValue.checkValue(NSString(string: htmlString), printTest: false)

    // test a crazy UTF-8 example
    let utf8String = try String(contentsOfFile: getFixtureFile("UTF-8-demo", ext:"txt")!)
    PalauDefaults.stringValue.checkValue(utf8String, printTest: false)
    PalauDefaults.nsStringValue.checkValue(NSString(string: utf8String), printTest: false)

    // test quickbrownfox in multiple languages
    let quickBrownString = try String(contentsOfFile: getFixtureFile("quickbrown", ext:"txt")!)
    PalauDefaults.stringValue.checkValue(quickBrownString, printTest: false)
    PalauDefaults.nsStringValue.checkValue(NSString(string: quickBrownString),
               printTest: false)
  }

  func testBoolValue() {
    PalauDefaults.boolValue.checkValue(true)
    PalauDefaults.boolValue.checkValue(false)
    PalauDefaults.boolValue.checkValue(CBool(true))
    PalauDefaults.boolValue.checkValue(CBool(false))
    PalauDefaults.boolValue.checkValue(BooleanLiteralType(true))
    PalauDefaults.boolValue.checkValue(BooleanLiteralType(false))
  }

  #if arch(x86_64) || arch(arm64)
  func test64bitOnly () {
    print("Running 64 bit tests")

    // test max 64 bit unsigned int nine quintillion
    let reallyBigInt = 9_223_372_036_854_775_807
    PalauDefaults.intValue.checkValue(reallyBigInt)

    // test max 64 bit signed int negative nine quintillion
    let reallyNegativeBigInt = -9_223_372_036_854_775_808
    PalauDefaults.intValue.checkValue(reallyNegativeBigInt)

    let reallyBitUnsignedInt: UInt = 9_223_372_036_854_775_807
    PalauDefaults.uIntValue.checkValue(reallyBitUnsignedInt)

    // really big int as NSNumber
    let reallyBigNSNumber: NSNumber = NSNumber(value: 9_223_372_036_854_775_807)
    PalauDefaults.nsNumberValue.checkValue(reallyBigNSNumber)
  }
  #endif

  func testIntValue() {
    // test some vanilla ints
    for i in [1, 2, 3, 4, 5, 6, 100, -44] {
      PalauDefaults.intValue.checkValue(i)
    }

    let binaryInteger = 0b10001       // 17 in binary notation
    PalauDefaults.intValue.checkValue(binaryInteger)

    let octalInteger = 0o21           // 17 in octal notation
    PalauDefaults.intValue.checkValue(octalInteger)

    let hexadecimalInteger = 0x11     // 17 in hexadecimal notation
    PalauDefaults.intValue.checkValue(hexadecimalInteger)
  }

  func testNSNumberValue() {
    for i in [1, 2, 3, 4, 5, 6, 100, -44] {
      let testNumber: NSNumber = NSNumber(value: i)
      PalauDefaults.nsNumberValue.checkValue(testNumber)
    }

    let nsDecimalNumber = NSDecimalNumber(value: 1)
    PalauDefaults.nsNumberValue.checkValue(nsDecimalNumber)
  }

  func testFloatValue() {
    // some weird double literals
    let decimalFloat: Float = 12.1875
    PalauDefaults.floatValue.checkValue(decimalFloat)

    let exponentFloat: Float = 1.21875e1
    PalauDefaults.floatValue.checkValue(exponentFloat)

    let hexadecimalFloat: Float = 0xC.3p0
    PalauDefaults.floatValue.checkValue(hexadecimalFloat)

    let paddedDouble: Float = 000123.456
    PalauDefaults.floatValue.checkValue(paddedDouble)

    let justOverOneMillion: Float = 1_000_000.000_000_1
    PalauDefaults.floatValue.checkValue(justOverOneMillion)

    let fmin = FLT_MIN
    PalauDefaults.floatValue.checkValue(fmin)

    let fmax = FLT_MAX
    PalauDefaults.floatValue.checkValue(fmax)

    let inf = Float.infinity
    PalauDefaults.floatValue.checkValue(inf)
  }

  func testDoubleValue() {
    // some weird double literals
    let decimalDouble = 12.1875
    PalauDefaults.doubleValue.checkValue(decimalDouble)

    let exponentDouble = 1.21875e1
    PalauDefaults.doubleValue.checkValue(exponentDouble)

    let hexadecimalDouble = 0xC.3p0
    PalauDefaults.doubleValue.checkValue(hexadecimalDouble)

    let paddedDouble = 000123.456
    PalauDefaults.doubleValue.checkValue(paddedDouble)

    let justOverOneMillion = 1_000_000.000_000_1
    PalauDefaults.doubleValue.checkValue(justOverOneMillion)


    let dmin = DBL_MIN
    PalauDefaults.doubleValue.checkValue(dmin)

    let dmax = DBL_MAX
    PalauDefaults.doubleValue.checkValue(dmax)

    let inf = Double.infinity
    PalauDefaults.doubleValue.checkValue(inf)
  }

  func testDateValue() {
    PalauDefaults.dateValue.checkValue(Date())
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
    let array = NSArray(array: [1, Date(), NSString(string: "test")])
    PalauDefaults.nsArrayValue.checkValue(array)

    let mutableArray = NSMutableArray(array: [1, Date(), NSString(string: "test")])
    PalauDefaults.nsArrayValue.checkValue(mutableArray)
  }

  func testStringArrayValue() {
    // We can't use the checkValue method here until we get Swift 3
    PalauDefaults.stringArrayValue.value = nil
    assert(PalauDefaults.stringArrayValue.value == nil)
    PalauDefaults.stringArrayValue.value = ["a", "b"]
    assert(PalauDefaults.stringArrayValue.value! == ["a", "b"])
  }

  func testStringMapValue() {
    // We can't use the checkValue method here until we get Swift 3
    PalauDefaults.stringMapValue.value = nil
    assert(PalauDefaults.stringMapValue.value == nil)
    PalauDefaults.stringMapValue.value = ["a": "b", "b": "a"]
    assert(PalauDefaults.stringMapValue.value! ==  ["a": "b", "b": "a"])
  }

  func testNSDictionaryValue() {
    let dictionary = NSDictionary(dictionary: ["key": "value", Date(): NSNumber(value: 1)])
    PalauDefaults.nsDictionaryValue.checkValue(dictionary)

    let mutableDictionary = NSMutableDictionary(
      dictionary: ["key": "value", Date(): NSNumber(value: 1)]
    )
    PalauDefaults.nsDictionaryValue.checkValue(mutableDictionary)
  }

  func testDataValue() {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: getFixtureFile("UTF-8-demo", ext:"txt")!)) else {
      fatalError()
    }
    PalauDefaults.dataValue.checkValue(data, printTest: false)
  }

  #if os(OSX)
    // test if we can get a default NSColor from a property
    func testNSColorDefaultValue() {
      let redColor = PalauDefaults.ensuredNSColorValue.value
      let redColor2 = PalauDefaults.whenNilledNSColorValue.value

      assert(redColor!.cgColor == NSColor.red.cgColor)
      assert(redColor2 == NSColor.red)
    }
  #else
    // test if we can get a default UIColor from a property
    func testUIColorDefaultValue() {
      let redColor = PalauDefaults.ensuredUIColorValue.value
      let redColor2 = PalauDefaults.whenNilledUIColorValue.value

      // UIColor sometimes returns different versions UIDeviceRGBColorSpace / UIDeviceWhiteColorSpace
      assert(redColor!.cgColor == UIColor.red.cgColor)
      assert(redColor2 == UIColor.red)
    }
  #endif

  func testEnumValue() {
    for e in [TestEnum.caseA, TestEnum.caseB, TestEnum.caseC] {
      PalauDefaults.enumValue.checkValue(e)
    }
  }

  // this test demonstrates how to use a custom didSet function
  func testEnumValueWithDidSet() {

    // this function builds a callback that binds the two input parameters to the internal function
    func assertIsEqual(_ new: TestEnum?, old: TestEnum?) -> (TestEnum?, TestEnum?) -> Void {
      return { e1, e2 in
        let equal = new == e1 && old == e2
        print(e1, e2)
        assert(equal)
      }
    }

    // start with nil
    PalauDefaults.enumValueWithDidSet.value = nil


    // bind the first didSet closure

    var enumWithDidSet = PalauDefaults.enumValueWithDidSet.didSet(assertIsEqual(TestEnum.caseB, old: nil))
    enumWithDidSet.value = TestEnum.caseB

    // lets add another
    var enumWithDidSetAgain = enumWithDidSet.didSet(assertIsEqual(TestEnum.caseA, old: TestEnum.caseB))
    enumWithDidSetAgain.value = TestEnum.caseA

    // and finally lets chain another to test the new value is nil
    let enumWithDidClear = enumWithDidSet.didSet(assertIsEqual(nil, old: TestEnum.caseA))
    enumWithDidClear.clear()
  }

  func testStructyValue() {
    let arrayOfStructs = [
      Structy(tuple: ("Test1", "Test2")),
      Structy(tuple: ("Test3", "Test4")),
      Structy(tuple: ("Test5", "Test6"))
    ]
    for s in arrayOfStructs {
      PalauDefaults.structWithTuple.checkValue(s)
    }
  }
}

// -------------------------------------------------------------------------------------------------
// MARK: - PalauDefaults
// -------------------------------------------------------------------------------------------------

extension PalauDefaults {

  static var boolValue: PalauDefaultsEntry<Bool> {
    get { return value("boolValue") }
    set { }
  }

  static var intValue: PalauDefaultsEntry<Int> {
    get { return value("intValue") }
    set { }
  }

  static var ensuredIntValue: PalauDefaultsEntry<Int> {
    get { return value("ensuredIntValue")
      .ensure(when: { $0 == nil }, use: 10)
      .ensure(when: lessThan10, use: 10) }
    set { }
  }

  #if os(OSX)
    static var ensuredNSColorValue: PalauDefaultsEntry<NSColor> {
      get { return value("ensuredNSColorValue")
        .ensure(when: { $0 == nil }, use: NSColor.red) }
      set { }
    }

    static var whenNilledNSColorValue: PalauDefaultsEntryEnsured<NSColor> {
      get { return value("whenNilledNSColorValue", whenNil: NSColor.red) }
      set { }
    }
  #else
    static var ensuredUIColorValue: PalauDefaultsEntry<UIColor> {
      get { return value("ensuredUIColorValue")
        .ensure(when: { $0 == nil }, use: UIColor.red) }
      set { }
    }

    static var whenNilledUIColorValue: PalauDefaultsEntryEnsured<UIColor> {
      get { return value("whenNilledUIColorValue", whenNil: UIColor.red) }
      set { }
    }
  #endif

  static var uIntValue: PalauDefaultsEntry<UInt> {
    get { return value("uIntValue") }
    set { }
  }

  static var floatValue: PalauDefaultsEntry<Float> {
    get { return value("floatValue") }
    set { }
  }

  static var doubleValue: PalauDefaultsEntry<Double> {
    get { return value("doubleValue") }
    set { }
  }

  static var nsNumberValue: PalauDefaultsEntry<NSNumber> {
    get { return value("nsNumberValue") }
    set { }
  }

  static var stringValue: PalauDefaultsEntry<String> {
    get { return value("stringValue") }
    set { }
  }

  static var nsStringValue: PalauDefaultsEntry<NSString> {
    get { return value("nsStringValue") }
    set { }
  }

  static var stringArrayValue: PalauDefaultsEntry<[String]> {
    get { return value("stringArrayValue") }
    set { }
  }

  static var nsArrayValue: PalauDefaultsEntry<NSArray> {
    get { return value("nsArrayValue") }
    set { }
  }

  static var stringMapValue: PalauDefaultsEntry<[String: String]> {
    get { return value("stringMapValue") }
    set { }
  }

  static var nsDictionaryValue: PalauDefaultsEntry<NSDictionary> {
    get { return value("nsDictionaryValue") }
    set { }
  }

  static var dateValue: PalauDefaultsEntry<Date> {
    get { return value("dateValue") }
    set { }
  }

  static var dataValue: PalauDefaultsEntry<Data> {
    get { return value("dataValue") }
    set { }
  }

  static var enumValue: PalauDefaultsEntry<TestEnum> {
    get { return value("testEnumValue") }
    set { }
  }

  static var enumValueWithDidSet: PalauDefaultsEntry<TestEnum> {
    get { return value("testEnumValueWithDidSet") }
    set { }
  }

  static var structWithTuple: PalauDefaultsEntry<Structy> {
    get { return value("structy") }
    set { }
  }

}
