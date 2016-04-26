//
//  Utils.swift
//  Palau
//
//  Created by symentis GmbH on 26.04.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
//

// ------------------------------------------------------------------------------------------------
// MARK: - Dict handling
// ------------------------------------------------------------------------------------------------

public func + <A, B>(lhs: UserDefaultsEntry<A>, rhs: UserDefaultsEntry<B>) -> [String:AnyObject] {
  switch (lhs.value, rhs.value) {
  case let (a as AnyObject, b as AnyObject):
    return  [lhs.key:a, rhs.key:b]
  case let (a as AnyObject, .None):
    return  [lhs.key:a]
  case let (.None, b as AnyObject):
    return  [rhs.key:b]
  default:
    return [:]
  }
}

public func + <B>(lhs: [String:AnyObject], rhs: UserDefaultsEntry<B>) -> [String:AnyObject] {
  guard let val = rhs.value as? AnyObject else { return lhs }
  var dict = lhs
  dict.updateValue(val, forKey: rhs.key)
  return dict
}
