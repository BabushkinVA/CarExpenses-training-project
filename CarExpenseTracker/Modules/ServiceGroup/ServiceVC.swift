//
//  ServiceVC.swift
//  CarExpenseTracker
//
//  Created by Vadim on 8.10.23.
//

import UIKit

final class ServiceVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var averagCashSpendLabel: UILabel!
    @IBOutlet private weak var amountCashLabel: UILabel!
    @IBOutlet private weak var amountMileageLabel: UILabel!
    @IBOutlet private var allServiceButtons: [UIButton]!
    
    
    private var services: [ServiceMO] = []
    private var serviceViewColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBlack
        
        allServiceButtons.forEach { $0.buttonMainStyle() }
        
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        amountMileageLabel.text = "\(totalMileage()) km"
        
        loadInfo()
        averageCashSpend()
        tableView.reloadData()
    }
    
    private func loadInfo() {
        let request = ServiceMO.fetchRequest()
        services = (try? CoreDataService.context.fetch(request)) ?? []
        services.sort{ $0.odometer > $1.odometer }
    }
    
    private func amountSum() -> Double {
        var sum: Double = 0
        services.forEach{ sum += $0.amount }
        amountCashLabel.text = "\(sum) BYN"
        return sum
    }
    
    private func averageCashSpend() {
        var avgCash: Double = 0
        
        if amountSum() == 0 || totalMileage() == 0 {
            averagCashSpendLabel.text = "0 BYN/km"
        } else { avgCash = amountSum() / Double(totalMileage())
            averagCashSpendLabel.text = "\(round(avgCash * 10) / 10 ) BYN/km"
        }
    }
    
    @IBAction private func serviceButtonDidTap(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "\(ServiceDetailVC.self)") as! ServiceDetailVC
        vc.text = sender.titleLabel?.text ?? ""
        vc.textColor = sender.backgroundColor
        vc.odometer = services.sorted { $0.odometer > $1.odometer}.last?.odometer
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - helpers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
}

extension ServiceVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ServiceTableViewCell.self)",
                                                 for: indexPath) as! ServiceTableViewCell
        let services = services[indexPath.row]
        cell.serviceLabel.text = services.category
        cell.priceLabel.text = "\(services.amount) BYN"
        cell.odometerLabel.text = "\(services.odometer) km"
        cell.dateLabel.text = services.date
        cell.shortDescriptionLabel.text = services.shortDescript
        cell.backgroundColor = UIColor.clear

        return cell
    }
    
    private func openDetailScreen(with service: ServiceMO?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "\(ServicePresentVC.self)") as! ServicePresentVC
        vc.service = service
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openDetailScreen(with: services[indexPath.row])
    }
}

extension ServiceVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removedItem = services.remove(at: indexPath.row)
            CoreDataService.context.delete(removedItem)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            CoreDataService.saveContext()
            
            averageCashSpend()
            tableView.reloadData()
        }
    }
}
