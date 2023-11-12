//
//  FillingDetailVC.swift
//  CarExpenseTracker
//
//  Created by Vadim on 8.10.23.
//

import UIKit

final class FillingDetailVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var odometerTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var litersTextField: UITextField!
    @IBOutlet private weak var oneLiterPriceTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    private var data: FuelMO?
    private var datePicker: UIDatePicker!
    private var date: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBlack
        
        saveButton.saveButtonStyle()
        cancelButton.cancelButtonStyle()
        
        litersTextField.delegate = self
        priceTextField.delegate = self
        
        setupDatePicker()
        loadLastOdo()
        setupData()
    }
    
    private func setupData() {
        guard let fuel = data else { return }
        dateTextField.text = fuel.date
    }
    
    private func loadLastOdo() {
        let request = FuelMO.fetchRequest()
        let fills = (try? CoreDataService.context.fetch(request)) ?? []
        guard let fill = fills.last else { return }
        odometerTextField.text = "\(fill.odometer)"
        oneLiterPriceTextField.text = "\(fill.oneLiter)"
    }
    
    // MARK: - Work with Date and DateTextField
    private func generateDatePicker(with mode: UIDatePicker.Mode) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateDidChanged(_:)), for: .valueChanged)
        return datePicker
    }
    
    private func setupDatePicker() {
        datePicker = generateDatePicker(with: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        dateTextField.text = dateFormatter.string(from: date)
        dateTextField.inputView = datePicker
    }
    
    @objc private func dateDidChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        let selectedDate = sender.date
        
        if sender == datePicker {
            dateFormatter.dateFormat = "dd.MM.yy"
            dateTextField.text = dateFormatter.string(from: selectedDate)
        }
    }
    
    // MARK: - TextField Calculation Func
    @IBAction private func litersAndPriceCount(_ textField: UITextField) {
        if textField == priceTextField {
            literCountChanged(sender: textField)
        } else if textField == litersTextField {
            priceChanged(sender: textField)
        }
    }
    
    private func literCountChanged(sender: UITextField) {
        guard let price = Double(priceTextField.text ?? "\(0)"),
              let oneLiterPrice = Double(oneLiterPriceTextField.text ?? "\(0)")
        else { litersTextField.text = ""
            return }
        
        litersTextField.text = "\(round(price / oneLiterPrice * 100) / 100)"
    }
    
    private func priceChanged(sender: UITextField) {
        guard let oneLiterPrice = Double(oneLiterPriceTextField.text ?? "\(0)"),
              let litersCount = Double(litersTextField.text ?? "\(0)")
                
        else { priceTextField.text = ""
            return }
        
        priceTextField.text = "\(round(litersCount * oneLiterPrice * 100) / 100)"
    }
    
    @IBAction private func saveButtonDidTap() {
        guard let date = dateTextField.text,
              let price = priceTextField.text, !price.isEmpty,
              let odometer = odometerTextField.text, !odometer.isEmpty,
              let liters = litersTextField.text, !liters.isEmpty,
              let oneLiter = oneLiterPriceTextField.text else { return }
        
        let context = CoreDataService.context
        context.perform {
            let newFueling = FuelMO(context: context)
            newFueling.date = date
            newFueling.price = Double(price) ?? 0
            newFueling.odometer = Int32(odometer) ?? 0
            newFueling.liters = Double(liters) ?? 0
            newFueling.oneLiter = Double(oneLiter) ?? 0
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
