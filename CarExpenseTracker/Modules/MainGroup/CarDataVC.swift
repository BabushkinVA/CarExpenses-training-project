//
//  CarDataVC.swift
//  CarExpenseTracker
//
//  Created by Vadim on 8.10.23.
//

import UIKit

protocol CarInfoDelegate {
    func carInfoDidChange(_ carMake: String, _ carModel: String)
}

final class CarDataVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet private weak var carMakeTextField: UITextField!
    @IBOutlet private weak var carModelTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    
    
    var delegate: CarInfoDelegate?
    var carMake: String?
    var carModel: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBlack
        
        saveButton.saveButtonStyle()
        backButton.cancelButtonStyle()
        
        carMakeTextField.delegate = self
        carModelTextField.delegate = self
        
        setupTextFields()
    }
    
    private func setupTextFields() {
        guard let carMake = carMake,
              let carModel = carModel
        else { return }
        
        carMakeTextField.text = carMake
        carModelTextField.text = carModel
    }
    
    // focus or deny
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == carMakeTextField {
            return true
        } else if textField == carModelTextField && !carMakeTextField.hasText {
            return false
        } else {
            return true
        }
    }
    
    //  RETURN button code
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == carMakeTextField && carMakeTextField.hasText {
            carModelTextField.becomeFirstResponder()
        } else if textField == carModelTextField
                    && carModelTextField.hasText {
            saveButtonDidTap(textField)
        }
        return false
    }
    
    @IBAction private func saveButtonDidTap(_ sender: UITextField) {
        
        guard let make = carMakeTextField.text,
              let model = carModelTextField.text
        else { return }
        
        let profile = CarProfile(make: make, model: model)
        let ud = UserDefaults.standard
        if let profileData = try? JSONEncoder().encode(profile) {
            ud.set(profileData, forKey: "kProfileData")
            
            delegate?.carInfoDidChange(make, model)
            dismiss(animated: true)
        }
    }
    
    //close keyboard by touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction private func backButtonDidTap() {
        dismiss(animated: true)
    }
    
}
