//
//  PalauTests.swift
//  PalauTests
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

import XCTest
import Foundation
import CoreGraphics

@testable import Palau


class PalauArrayTests: PalauTestCase {

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
    PalauDefaults.stringValues.checkValue(["a"])
    PalauDefaults.stringValues.checkValue(strings, printTest: false)
    PalauDefaults.nsStringValues.checkValue(strings.map(NSString.init(string:)),
               printTest: false)


    // test a html file
    let htmlString = try String(contentsOfFile: getFixtureFile("example", ext:"html")!)
    // test a crazy UTF-8 example
    let utf8String = try String(contentsOfFile: getFixtureFile("UTF-8-demo", ext:"txt")!)
    // test quickbrownfox in multiple languages
    let quickBrownString = try String(contentsOfFile: getFixtureFile("quickbrown", ext:"txt")!)

    let strings2 = [htmlString, utf8String, quickBrownString]
    PalauDefaults.stringValues.checkValue(strings2, printTest: false)
    PalauDefaults.nsStringValues.checkValue(strings2.map(NSString.init(string:)),
               printTest: false)
  }

  func testBoolValue() {
    PalauDefaults.boolValues.checkValue([true, false])
    PalauDefaults.boolValues.checkValue([false, true])
    PalauDefaults.boolValues.checkValue([CBool(true)])
    PalauDefaults.boolValues.checkValue([CBool(false)])
    PalauDefaults.boolValues.checkValue([BooleanLiteralType(true)])
    PalauDefaults.boolValues.checkValue([BooleanLiteralType(false)])
  }

  #if arch(x86_64) || arch(arm64)
  func test64bitOnly () {
    print("Running 64 bit tests")

    // test max 64 bit unsigned int nine quintillion
    let reallyBigInt = [9_223_372_036_854_775_807]
    PalauDefaults.intValues.checkValue(reallyBigInt)

    // test max 64 bit signed int negative nine quintillion
    let reallyNegativeBigInt = [-9_223_372_036_854_775_808]
    PalauDefaults.intValues.checkValue(reallyNegativeBigInt)

    let reallyBitUnsignedInt: [UInt] = [9_223_372_036_854_775_807]
    PalauDefaults.uIntValues.checkValue(reallyBitUnsignedInt)

    // really big int as NSNumber
    let reallyBigNSNumber: [NSNumber] = [NSNumber(value: 9_223_372_036_854_775_807)]
    PalauDefaults.nsNumberValues.checkValue(reallyBigNSNumber)
  }
  #endif

  func testIntValue() {
    // test some vanilla ints
    PalauDefaults.intValues.checkValue([1, 2, 3, 4, 5, 6, 100, -44])
  }

  func testNSNumberValue() {
    let testNumbers = [1, 2, 3, 4, 5, 6, 100, -44].map { NSNumber(value: $0) }
    PalauDefaults.nsNumberValues.checkValue(testNumbers)
  }

  func testFloatValue() {
    // some weird double literals
    let decimalFloat: [Float] = [12.1875, 99, 99.898]
    PalauDefaults.floatValues.checkValue(decimalFloat)

    let exponentFloat: [Float] = [1.21875e1, 99, 99.898]
    PalauDefaults.floatValues.checkValue(exponentFloat)

    let hexadecimalFloat: [Float] = [0xC.3p0]
    PalauDefaults.floatValues.checkValue(hexadecimalFloat)

    let paddedDouble: [Float] = [000123.456]
    PalauDefaults.floatValues.checkValue(paddedDouble)

    let justOverOneMillion: [Float] = [1_000_000.000_000_1]
    PalauDefaults.floatValues.checkValue(justOverOneMillion)

    let fmin = [FLT_MIN]
    PalauDefaults.floatValues.checkValue(fmin)

    let fmax = [FLT_MAX]
    PalauDefaults.floatValues.checkValue(fmax)

    let inf = [Float.infinity]
    PalauDefaults.floatValues.checkValue(inf)
  }

  func testDoubleValue() {
    // some weird double literals
    let decimalDouble = [12.1875]
    PalauDefaults.doubleValues.checkValue(decimalDouble)

    let exponentDouble = [1.21875e1]
    PalauDefaults.doubleValues.checkValue(exponentDouble)

    let hexadecimalDouble = [0xC.3p0]
    PalauDefaults.doubleValues.checkValue(hexadecimalDouble)

    let paddedDouble = [000123.456]
    PalauDefaults.doubleValues.checkValue(paddedDouble)

    let justOverOneMillion = [1_000_000.000_000_1]
    PalauDefaults.doubleValues.checkValue(justOverOneMillion)


    let dmin = [DBL_MIN]
    PalauDefaults.doubleValues.checkValue(dmin)

    let dmax = [DBL_MAX]
    PalauDefaults.doubleValues.checkValue(dmax)

    let inf = [Double.infinity]
    PalauDefaults.doubleValues.checkValue(inf)
  }

  func testDateValue() {
    PalauDefaults.dateValues.checkValue([Date()])
  }

  func testEnsuredIntValues() {
    PalauDefaults.ensuredIntValues.value = nil
    assert(PalauDefaults.ensuredIntValues.value! == [10, 10])
    PalauDefaults.ensuredIntValues.value = [12]
    assert(PalauDefaults.ensuredIntValues.value! == [10, 10])
    PalauDefaults.ensuredIntValues.value = [8, 8, 8]
    assert(PalauDefaults.ensuredIntValues.value! == [8, 8, 8])
  }

  func testNSArrayValues() {
    let array = [NSArray(array: [1, Date(), NSString(string: "test")])]
    PalauDefaults.nsArrayValues.checkValue(array)

    let mutableArray = [NSMutableArray(array: [1, Date(), NSString(string: "test")])]
    PalauDefaults.nsArrayValues.checkValue(mutableArray)
  }

  func testStringArrayValue() {
    // We can't use the checkValue method here until we get Swift 3
    // TODO Swift 3: Array/Dictionary: PalauDefaultable where Element: PalauDefaultable
    PalauDefaults.stringArrayValues.value = nil
    assert(PalauDefaults.stringArrayValues.value == nil)
    PalauDefaults.stringArrayValues.value = [["a", "b"]]
    assert(PalauDefaults.stringArrayValues.value! == [["a", "b"]])
  }

  func testStringMapValue() {
    // We can't use the checkValue method here until we get Swift 3
    // TODO Swift 3: Array/Dictionary: PalauDefaultable where Element: PalauDefaultable
    PalauDefaults.stringMapValues.value = nil
    assert(PalauDefaults.stringMapValues.value == nil)
    PalauDefaults.stringMapValues.value = [["a": "b", "b": "a"]]
    assert(PalauDefaults.stringMapValues.value! ==  [["a": "b", "b": "a"]])
  }

  func testNSDictionaryValue() {
    let dictionary = [
      NSDictionary(dictionary: ["key": "value", Date(): NSNumber(value: 1)]),
      NSDictionary(dictionary: ["key": "value2", Date(): NSNumber(value: 2)])
    ]
    PalauDefaults.nsDictionaryValues.checkValue(dictionary)

    let mutableDictionary = [NSMutableDictionary(
      dictionary: ["key": "value", Date(): NSNumber(value: 1)]
      ), NSMutableDictionary(
        dictionary: ["key": "value2", Date(): NSNumber(value: 2)]
      )]
    PalauDefaults.nsDictionaryValues.checkValue(mutableDictionary)
  }

  func testDataValue() {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: getFixtureFile("UTF-8-demo", ext:"txt")!)) else {
      fatalError()
    }
    PalauDefaults.dataValues.checkValue([data], printTest: false)
  }

  #if os(OSX)
    // test if we can get a default NSColor from a property
    func testNSColorDefaultValue() {
      let redColors = PalauDefaults.ensuredNSColorValues.value
      let redColors2 = PalauDefaults.whenNilledNSColorValues.value

      let redColor = redColors!.first!
      let redColor2 = redColors2!.first!

      assert(redColor.cgColor == NSColor.red.cgColor)
      assert(redColor2 == NSColor.red)
    }
  #else

    // test if we can get a default UIColor from a property
    func testUIColorDefaultValue() {
      let redColors = PalauDefaults.ensuredUIColorValues.value
      let redColors2 = PalauDefaults.whenNilledUIColorValues.value

      // UIColor sometimes returns different versions UIDeviceRGBColorSpace / UIDeviceWhiteColorSpace
      let redColor = redColors!.first!
      let redColor2 = redColors2.first!

      assert(redColor.cgColor == UIColor.red.cgColor)
      assert(redColor2 == UIColor.red)
    }
  #endif

  func testEnumValue() {
    PalauDefaults.enumValues.checkValue([TestEnum.caseA, TestEnum.caseB, TestEnum.caseC])
  }

  // this test demonstrates how to use a custom didSet function
  func testEnumValueWithDidSet() {

    // this function builds a callback that binds the two input parameters to the internal function
    func assertIsEqual(_ new: [TestEnum]?, old: [TestEnum]?) -> ([TestEnum]?, [TestEnum]?) -> Void {
      return { e1, e2 in
        let conditionOld = old == nil ? (e2 == nil) : (old! == e2!)
        let conditionNew = new == nil ? (e1 == nil) : (new! == e1!)
        let equal = conditionNew && conditionOld
        print(e1, e2)
        assert(equal)
      }
    }

    // start with nil
    PalauDefaults.enumValuesWithDidSet.value = nil

    // bind the first didSet closure
    var enumWithDidSet = PalauDefaults.enumValuesWithDidSet.didSet(assertIsEqual([TestEnum.caseB], old: nil))
    enumWithDidSet.value = [TestEnum.caseB]

    // lets add another
    var enumWithDidSetAgain = enumWithDidSet.didSet(assertIsEqual([TestEnum.caseA], old: [TestEnum.caseB]))
    enumWithDidSetAgain.value = [TestEnum.caseA]

    // and finally lets chain another to test the new value is nil
    let enumWithDidClear = enumWithDidSet.didSet(assertIsEqual(nil, old: [TestEnum.caseA]))
    enumWithDidClear.clear()
  }

  func testStructyValue() {
    let arrayOfStructs = [
      Structy(tuple: ("Test1", "Test2")),
      Structy(tuple: ("Test3", "Test4")),
      Structy(tuple: ("Test5", "Test6"))
    ]
    PalauDefaults.structsWithTuple.checkValue(arrayOfStructs)
  }
}

// -------------------------------------------------------------------------------------------------
// MARK: - PalauDefaults
// -------------------------------------------------------------------------------------------------

typealias PalauDefaultsArrayEntry<T: PalauDefaultable> = PalauEntry<PalauOptional<PalauList<T>>>
typealias PalauDefaultsArrayEntryEnsured<T: PalauDefaultable> = PalauEntry<PalauEnsured<PalauList<T>>>


extension PalauDefaults {

  // This is working
  static var boolValues: PalauDefaultsArrayEntry<Bool> {
    get { return value("boolValues") }
    set { }
  }

  static var intValues: PalauDefaultsArrayEntry<Int> {
    get { return value("intValues") }
    set { }
  }

  static var ensuredIntValues: PalauDefaultsArrayEntry<Int> {
    get { return value("ensuredIntValues")
      .ensure(when: { $0 == nil }, use: [10, 10])
      .ensure(when: lessThanTwo, use: [10, 10]) }
    set { }
  }

  #if os(OSX)
    static var ensuredNSColorValues: PalauDefaultsArrayEntry<NSColor> {
      get { return value("ensuredNSColorValue").ensure(when: { $0 == nil }, use: [NSColor.red]) }
      set { }
    }

    static var whenNilledNSColorValues: PalauDefaultsArrayEntryEnsured<NSColor> {
      get { return value("whenNilledNSColorValue", whenNil: [NSColor.red]) }
      set { }
    }
  #else
   static var ensuredUIColorValues: PalauDefaultsArrayEntry<UIColor> {
      get { return value("ensuredUIColorValues")
        .ensure(when: { $0 == nil }, use: [UIColor.red]) }
      set { }
    }

     static var whenNilledUIColorValues: PalauDefaultsArrayEntryEnsured<UIColor> {
      get { return value("whenNilledUIColorValues", whenNil: [UIColor.red]) }
      set { }
    }
  #endif

   static var uIntValues: PalauDefaultsArrayEntry<UInt> {
    get { return value("uIntValues") }
    set { }
  }

  static var floatValues: PalauDefaultsArrayEntry<Float> {
    get { return value("floatValues") }
    set { }
  }

  static var doubleValues: PalauDefaultsArrayEntry<Double> {
    get { return value("doubleValues") }
    set { }
  }

  static var nsNumberValues: PalauDefaultsArrayEntry<NSNumber> {
    get { return value("nsNumberValues") }
    set { }
  }

  static var stringValues: PalauDefaultsArrayEntry<String> {
    get { return value("stringValues") }
    set { }
  }

  static var nsStringValues: PalauDefaultsArrayEntry<NSString> {
    get { return value("nsStringValues") }
    set { }
  }

  static var stringArrayValues: PalauDefaultsArrayEntry<[String]> {
    get { return value("stringArrayValues") }
    set { }
  }

  static var nsArrayValues: PalauDefaultsArrayEntry<NSArray> {
    get { return value("nsArrayValues") }
    set { }
  }

  static var stringMapValues: PalauDefaultsArrayEntry<[String: String]> {
    get { return value("stringMapValues") }
    set { }
  }

  static var nsDictionaryValues: PalauDefaultsArrayEntry<NSDictionary> {
    get { return value("nsDictionaryValues") }
    set { }
  }

  static var dateValues: PalauDefaultsArrayEntry<Date> {
    get { return value("dateValues") }
    set { }
  }

  static var dataValues: PalauDefaultsArrayEntry<Data> {
    get { return value("dataValues") }
    set { }
  }

  static var enumValues: PalauDefaultsArrayEntry<TestEnum> {
    get { return value("testEnumValues") }
    set { }
  }

  static var enumValuesWithDidSet: PalauDefaultsArrayEntry<TestEnum> {
    get { return value("testEnumValuesWithDidSet") }
    set { }
  }

  static var structsWithTuple: PalauDefaultsArrayEntry<Structy> {
    get { return value("structy") }
    set { }
  }

}
