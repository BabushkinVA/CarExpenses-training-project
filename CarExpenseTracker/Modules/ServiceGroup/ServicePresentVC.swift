//
//  ServicePresentVC.swift
//  CarExpenseTracker
//
//  Created by Vadim on 8.10.23.
//

import UIKit

final class ServicePresentVC: UIViewController {
    
    @IBOutlet private weak var serviceNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var odometerLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var backButton: UIButton!
    
    var service: ServiceMO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBlack
        descriptionTextView.backgroundColor = .clear
        
        backButton.cancelButtonStyle()
        presentServiceInfo()
    }
    
    private func presentServiceInfo() {
        guard let service else { return }
        serviceNameLabel.text = service.category
        priceLabel.text = "\(service.amount) BYN"
        odometerLabel.text = "\(service.odometer) km"
        dateLabel.text = service.date
        descriptionTextView.text = service.myDescription
    }
    
    @IBAction private func backButtonDidTap() {
        dismiss(animated: true)
    }
}
