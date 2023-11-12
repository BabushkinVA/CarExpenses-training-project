//
//  ServiceDetailVC.swift
//  CarExpenseTracker
//
//  Created by Vadim on 8.10.23.
//

import UIKit

final class ServiceDetailVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet private weak var shordDescriptionTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var odometerTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var serviceNameLabel: UILabel!
    
    private var datePicker: UIDatePicker!
    var date: Date = Date()
    
    var text = ""
    var textColor: UIColor?
    var odometer: Int32?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBlack
        
        odometerTextField.text = "\(odometer ?? 0)"
        
        descriptionTextView.delegate = self
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.textColor = UIColor.lightGray
        
        serviceNameLabel.text = text
        serviceNameLabel.layer.cornerRadius = 10
        serviceNameLabel.layer.masksToBounds = true
        serviceNameLabel.backgroundColor = textColor
        serviceNameLabel.textColor = UIColor.white
        
        saveButton.backgroundColor = serviceNameLabel.backgroundColor
        saveButton.buttonMainStyle()
        
        cancelButton.backgroundColor = UIColor.white
        cancelButton.setTitleColor(serviceNameLabel.backgroundColor, for: .normal)
        cancelButton.layer.cornerRadius = 10.0
        
        setupDate()
    }
    
    //MARK: - TextView placeHolder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            descriptionTextView.text = "No description"
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: - Work with Date and DateTextField
    private func generateDatePicker(with mode: UIDatePicker.Mode) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateDidChanged(_:)), for: .valueChanged)
        return datePicker
    }
    
    private func setupDate() {
        datePicker = generateDatePicker(with: .date)
        dateTextField.inputView = datePicker
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        dateTextField.text = dateFormatter.string(from: date)
    }
    
    @objc private func dateDidChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        let selectedDate = sender.date
        if sender == datePicker {
            dateFormatter.dateFormat = "dd.MM.yy"
            dateTextField.text = dateFormatter.string(from: selectedDate)
        }
    }
    
    @IBAction private func saveButtonDidTap(sender: UIButton) {
        guard let date = dateTextField.text,
              let price = Double(priceTextField.text ?? ""),
              let odometer = Int32(odometerTextField.text ?? ""),
              let description = descriptionTextView.text,
              let category = serviceNameLabel.text?.lowercased(),
              let shortDescription = shordDescriptionTextField.text
        else { return }
        
        let context = CoreDataService.context
        context.perform {
            let newService = ServiceMO(context: context)
            newService.date = date
            newService.amount = price
            newService.odometer = odometer
            newService.category = category
            newService.name = category
            newService.myDescription = description
            newService.shortDescript = shortDescription
            
            CoreDataService.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction private func cancelButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
}
