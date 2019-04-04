//
//  StringExtension.swift
//  DrugCostAnalytics
//
//  Created by marco antonio reyes  on 27/06/18.
//  Copyright © 2018 makingdevs. All rights reserved.
//

import Foundation

extension String {

  func isValueAValidEmail() -> Bool {
    // here, `try!` will always succeed because the pattern is valid
    if let regex = try? NSRegularExpression(pattern:
      "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive) {
      return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    return false
  }

  func isValueANumber() -> Bool {
    let numberCharacters = NSCharacterSet.decimalDigits.inverted
    return !self.isEmpty && self.rangeOfCharacter(from: numberCharacters) == nil
  }
}
