//
//  PalauStrategy.swift
//  Palau
//
//  Created by symentis GmbH on 08.08.16.
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

// ----------------------------------------------------------------------------------------------
// MARK: - PalauStrategy
// ----------------------------------------------------------------------------------------------

public protocol PalauStrategy {
  associatedtype QuantifierType: PalauQuantifier
  associatedtype ReturnType

  var fallback: () -> ReturnType { get }
  var ensure: (ReturnType) -> ReturnType { get }
  var didSet: ((ReturnType, ReturnType) -> ())? { get }

  func resolve(_ value: QuantifierType.ReturnType?) -> ReturnType

  init(for: QuantifierType.Type, fallback: () -> ReturnType, ensure: (ReturnType) -> ReturnType, didSet: ((ReturnType, ReturnType) -> ()))
  init(for: QuantifierType.Type, fallback: () -> ReturnType, ensure: (ReturnType) -> ReturnType)
}

// ----------------------------------------------------------------------------------------------------
// MARK: - PalauStrategyOptional
// ----------------------------------------------------------------------------------------------------

public protocol PalauStrategyOptional: PalauStrategy { }

public struct PalauOptional<T>: PalauStrategyOptional where T: PalauQuantifier {
  public typealias QuantifierType = T
  public typealias ReturnType = T.ReturnType?

  public let fallback: () -> ReturnType
  public let ensure: (ReturnType) -> ReturnType
  public let didSet: ((ReturnType, ReturnType) -> ())?

  public init(for: T.Type, fallback: () -> ReturnType, ensure: (ReturnType) -> ReturnType) {
    self.fallback = fallback
    self.ensure = ensure
    self.didSet = nil
  }

  public init(for: T.Type, fallback: () -> ReturnType, ensure: (ReturnType) -> ReturnType, didSet: ((ReturnType, ReturnType) -> ())) {
    self.fallback = fallback
    self.ensure = ensure
    self.didSet = didSet
  }

  public func resolve(_ value: QuantifierType.ReturnType?) -> ReturnType {
    return ensure(value)
  }
}

// ----------------------------------------------------------------------------------------------------
// MARK: - PalauStrategyEnsured
// ----------------------------------------------------------------------------------------------------

public protocol PalauStrategyEnsured: PalauStrategy { }

public struct PalauEnsured<T>: PalauStrategyEnsured where T: PalauQuantifier {
  public typealias QuantifierType = T
  public typealias ReturnType = T.ReturnType

  public let fallback: () -> ReturnType
  public let ensure: (ReturnType) -> ReturnType
  public let didSet: ((ReturnType, ReturnType) -> ())?

  public init(for: T.Type, fallback: () -> ReturnType, ensure: (ReturnType) -> ReturnType) {
    self.fallback = fallback
    self.ensure = ensure
    self.didSet = nil
  }

  public init(for: T.Type, fallback: () -> ReturnType, ensure: (ReturnType) -> ReturnType, didSet: ((ReturnType, ReturnType) -> ())) {
    self.fallback = fallback
    self.ensure = ensure
    self.didSet = didSet
  }

  public func resolve(_ value: QuantifierType.ReturnType?) -> ReturnType {
    guard let value = value else {
      return fallback()
    }
    return ensure(value)
  }
}
