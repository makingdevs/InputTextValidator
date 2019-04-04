//
//  InputValidator.swift
//  ACEL
//
//  Created by marco antonio reyes  on 14/01/19.
//  Copyright © 2019 Makingdevs. All rights reserved.
//

import UIKit
import SystemConfiguration

public class InputValidator {

  public var validationTypes: [ValidationType]
  var nonEmptyFields: [UIAccessibilityIdentification]
  var isAMailFields: [UIAccessibilityIdentification]
  var isNumericFields: [UIAccessibilityIdentification]
  var maxLenghtFields: [(UIAccessibilityIdentification, Int)]
  var verificationFields: [(UIAccessibilityIdentification, UIAccessibilityIdentification)]
  var minLenghtFields: [(UIAccessibilityIdentification, Int)]
  var lenghtFields: [(UIAccessibilityIdentification, Int)]

  public init() {
    validationTypes = [ValidationType.notEmpty, ValidationType.isAMail,
                       ValidationType.isNumeric, ValidationType.maxLenght, ValidationType.verification,
                       ValidationType.minLenght, ValidationType.lenght]

    self.nonEmptyFields = []
    self.isAMailFields = []
    self.isNumericFields = []
    self.maxLenghtFields = []
    self.verificationFields = []
    self.minLenghtFields = []
    self.lenghtFields = []
  }

  public func addNonEmptyFields(nonEmptyFields: [UIAccessibilityIdentification]) {
    self.nonEmptyFields.append(contentsOf: nonEmptyFields)
  }

  public func addIsAMailFields(isAMailFields: [UIAccessibilityIdentification]) {
    self.isAMailFields.append(contentsOf: isAMailFields)
  }

  func addIsNumericFields(isNumericFields: [UIAccessibilityIdentification]) {
    self.isNumericFields.append(contentsOf: isNumericFields)
  }

  public func addVerificationFields(verificationFields: [(UIAccessibilityIdentification, UIAccessibilityIdentification)]) {
    self.verificationFields.append(contentsOf: verificationFields)
  }

  func addMaxLenghtFields(maxLenghtFields: [(UIAccessibilityIdentification, Int)]) {
    self.maxLenghtFields.append(contentsOf: maxLenghtFields)
  }

  public func addMinLenghtFields(minLenghtFields: [(UIAccessibilityIdentification, Int)]) {
    self.minLenghtFields.append(contentsOf: minLenghtFields)
  }

  func addlenghtFields(lenghtFields: [(UIAccessibilityIdentification, Int)]) {
    self.lenghtFields.append(contentsOf: lenghtFields)
  }

  func addFieldToValidate(field: UIAccessibilityIdentification, withValidationsList: [(ValidationType, Any)]) {
    for (type, evaluation) in withValidationsList {
      switch type {
      case ValidationType.notEmpty:
        nonEmptyFields.append(field)
      case ValidationType.isAMail:
        isAMailFields.append(field)
      case ValidationType.isNumeric:
        isNumericFields.append(field)
      case ValidationType.maxLenght:
        if let evaluation = evaluation as? Int {
          maxLenghtFields.append((field, evaluation))
        }
      case ValidationType.verification:
        if let evaluation = evaluation as? UIView {
          verificationFields.append((field, evaluation))
        }
      case ValidationType.minLenght:
        if let evaluation = evaluation as? Int {
          minLenghtFields.append((field, evaluation))
        }
      case ValidationType.lenght:
        if let evaluation = evaluation as? Int {
          lenghtFields.append((field, evaluation))
        }
      default:
        break
      }
    }
  }

  public func validate() -> Result {
    //            return (nil, nil)
    for type in validationTypes {
      switch type {
      case ValidationType.notEmpty:
        if let fieldWithError = getFisrtEmptyIdentificableText() {
          return Result.error(type: type, wantedValue: "", sender: fieldWithError)
        }
      case ValidationType.isAMail:
        if let fieldWithError = getFisrtIsNotAMail() {
          return Result.error(type: type, wantedValue: "", sender: fieldWithError)
        }
      case ValidationType.isNumeric:
        if let fieldWithError = getFisrtIsNotNumeric() {
          return Result.error(type: type, wantedValue: "", sender: fieldWithError)
        }
      case ValidationType.maxLenght:
        let error = getFirstMoreThanLenght()
        if let fieldWithError = error.0 {
          return Result.error(type: type, wantedValue: "\(error.1)", sender: fieldWithError)
        }
      case ValidationType.verification:
        let error = getFirstNotVerificated()
        if let fieldWithError = error.0 {
          var wantedValue = "\(error.1?.description ?? "")"
          if let control = error.1 as? UITextField, let text = control.placeholder {
            wantedValue = text
          } else if let control = error.1 as? UILabel, let text = control.restorationIdentifier {
            wantedValue = text
          } else if let control = error.1 as? UITextView, let text = control.restorationIdentifier {
            wantedValue = text
          }
          return Result.error(type: type, wantedValue: wantedValue, sender: fieldWithError)
        }
      case ValidationType.minLenght:
        let error = getFirstLessThanMinLenght()
        if let fieldWithError = error.0 {
          return Result.error(type: type, wantedValue: "\(error.1)", sender: fieldWithError)
        }
      case ValidationType.lenght:
        let error = getFirstNotEqLenght()
        if let fieldWithError = error.0 {
          return Result.error(type: type, wantedValue: "\(error.1)", sender: fieldWithError)
        }
      default:
        break
      }
    }
    return Result.success()
  }

  func getFirstNotVerificated() -> (UIAccessibilityIdentification?, UIAccessibilityIdentification?) {
    for (field, val) in self.verificationFields {
      var text1 = ""
      var text2 = ""
      if let texted = field as? UITextField {
        text1 = texted.text!
      } else if let texted = field as? UITextView {
        text1 = texted.text!
      } else if let texted = field as? UILabel {
        text1 = texted.text!
      }

      if let texted = val as? UITextField {
        text2 = texted.text!
      } else if let texted = field as? UITextView {
        text2 = texted.text!
      } else if let texted = field as? UILabel {
        text2 = texted.text!
      }

      if text1 != text2 {
        return (field, val)
      }
    }
    return (nil, nil)
  }

  func getFirstMoreThanLenght() -> (UIAccessibilityIdentification?, Int) {
    for (field, val) in self.maxLenghtFields {
      var text = ""
      if let texted = field as? UITextField {
        text = texted.text!
      } else if let texted = field as? UITextView {
        text = texted.text!
      } else if let texted = field as? UILabel {
        text = texted.text!
      }

      if text.count > val {
        return (field, val)
      }
    }
    return (nil, 0)
  }

  func getFisrtIsNotNumeric() -> UIAccessibilityIdentification? {
    for field in self.isNumericFields {
      var text = ""
      if let texted = field as? UITextField {
        text = texted.text!
      } else if let texted = field as? UITextView {
        text = texted.text!
      } else if let texted = field as? UILabel {
        text = texted.text!
      }
      if !text.isValueANumber(), text != "" {
        return field
      }
    }
    return nil
  }
  private func getFisrtIsNotAMail() -> UIAccessibilityIdentification? {
    for field in self.isAMailFields {
      var text = ""
      if let texted = field as? UITextField {
        text = texted.text!
      } else if let texted = field as? UITextView {
        text = texted.text!
      } else if let texted = field as? UILabel {
        text = texted.text!
      }

      if  text.isValueAValidEmail() == false  && text != "" {
        return field
      }
    }
    return nil
  }

  private func getFisrtEmptyIdentificableText() -> UIAccessibilityIdentification? {

    for field in self.nonEmptyFields {
      var text = ""
      if let texted = field as? UITextField {
        text = texted.text!
      } else if let texted = field as? UITextView {
        text = texted.text!
      } else if let texted = field as? UILabel {
        text = texted.text!
      }

      if  text == "" {
        return field
      }
    }

    return nil
  }

  func getFirstLessThanMinLenght() -> (UIAccessibilityIdentification?, Int) {
    for (field, val) in self.minLenghtFields {
      var text = ""
      if let texted = field as? UITextField {
        text = texted.text!
      } else if let texted = field as? UITextView {
        text = texted.text!
      } else if let texted = field as? UILabel {
        text = texted.text!
      }

      if text.count < val {
        return (field, val)
      }
    }
    return (nil, 0)
  }

  func getFirstNotEqLenght() -> (UIAccessibilityIdentification?, Int) {
    for (field, val) in self.lenghtFields {
      var text = ""
      if let texted = field as? UITextField {
        text = texted.text!
      } else if let texted = field as? UITextView {
        text = texted.text!
      } else if let texted = field as? UILabel {
        text = texted.text!
      }

      if text.count != val && text != "" {
        return (field, val)
      }
    }
    return (nil, 0)
  }

  static func isFilled(_ textField: UITextField) -> Bool {
    if textField.text == "" {
      return false
    }
    return true
  }

  static func textHasMin(value: Int, for textField: UITextField) -> Bool {
    if isFilled(textField) {
      if let count = textField.text?.count,
        count >= 10 {
        return true
      }
    }
    return false
  }
}

public enum ValidationType: String {
  case notEmpty = "Campo requerido"
  case maxLenght = "Campo con longitud máxima"
  case isNumeric = "Campo numerico"
  case isAMail = "Mail invalido"
  case verification = "Campo de verificación "
  case success = "El campo no tiene errores de validación"
  case minLenght = "Campo con longitud minima"
  case lenght = "Campo con longitud fija"
  case graterThan = "El campo debe ser mayor a"
}
struct InputError {
  var title: String
}

public enum Result {
  case success()
  case error(type:ValidationType, wantedValue:String, sender:UIAccessibilityIdentification?)
}
