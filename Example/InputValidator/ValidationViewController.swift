//
//  ValidationViewController.swift
//  InputValidator_Example
//
//  Created by marco antonio reyes  on 03/04/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import InputValidator

class ValidationViewController: UIViewController {
  @IBOutlet weak var nameTextField: UITextField!
  
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var passConfirmationTextField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func validateInputComponents() -> Bool {
    let validator = InputValidator()
    validator.addNonEmptyFields(
      nonEmptyFields: [nameTextField, emailTextField, passwordTextField, passConfirmationTextField])
    validator.addMinLenghtFields(minLenghtFields: [(phoneTextField      , 10)])
    validator.addIsAMailFields(isAMailFields: [emailTextField])
    validator.addVerificationFields(verificationFields: [(passwordTextField, passConfirmationTextField)])
    
    let result = validator.validate()
    switch result {
    case .success:
      return true
    case .error(let type, let wantedValue, let sender):
      mannageError(type: type, wantedValue: wantedValue, sender: sender)
    }
    return false
  }
  
  func mannageError(type:ValidationType, wantedValue:String, sender:UIAccessibilityIdentification?) {
    var message = type.rawValue
    switch type {
    case .notEmpty:
      if let sender = sender as? UITextField,
        let palceHolder = sender.placeholder {
        message = "\(palceHolder) is required"
      }
    case .minLenght:
      if let sender = sender as? UITextField,
        let palceHolder = sender.placeholder {
        message = "\(palceHolder) min leng of \(wantedValue)"
      }
    case .verification:
        message = "\(wantedValue) is wrong"
    default:
      break
    }
    present(errorAlert(message: message), animated: true)
  }
  
  func errorAlert(message: String) -> UIAlertController {
    let alert = UIAlertController(
      title: "An error occurred",
      message: message,
      preferredStyle: .alert)
    let okAction = UIAlertAction(
      title: "Acept",
      style: .default) { (_) in }
    alert.addAction(okAction)
    return alert
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    return validateInputComponents()
  }
}
