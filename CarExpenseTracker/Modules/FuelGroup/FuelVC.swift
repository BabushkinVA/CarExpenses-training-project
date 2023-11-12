//
//  FuelVC.swift
//  CarExpenseTracker
//
//  Created by Vadim on 8.10.23.
//

import UIKit

final class FuelVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var averageFuelConsLabel: UILabel!
    @IBOutlet private weak var amountCashLabel: UILabel!
    @IBOutlet private weak var amountLitersLabel: UILabel!
    @IBOutlet private weak var fillButton: UIButton!
    
    private var fills: [FuelMO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBlack
        
        tableView.backgroundColor = .clear
        
        fillButton.buttonMainStyle()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadAllFuncs()
        tableView.reloadData()
    }
    
    private func loadAllFuncs() {
        loadInfo()
        totalFuelSpent()
        avgFuelCons()
    }
    
    
    private func loadInfo() {
        let request = FuelMO.fetchRequest()
        fills = (try? CoreDataService.context.fetch(request)) ?? []
        fills.sort{ $0.odometer > $1.odometer }
    }
    
    private func totalFuelSpent() {
        var sum: Double = 0
        fills.forEach {
            sum += $0.price }
        amountCashLabel.text = "\(round(sum * 100) / 100) BYN"
    }
    
    private func amountOdometer() -> Double  {
        var amountOdo: Int32 = 0
        let sortedFills = fills.sorted{ $0.odometer < $1.odometer }
        if  let minOdo = sortedFills.first?.odometer,
            let maxOdo = sortedFills.last?.odometer {
            amountOdo = maxOdo - minOdo
        }
        return Double(amountOdo)
    }
    
    private func totalLiters() -> Double  {
        var liters: Double = 0
        fills.forEach{ liters += $0.liters }
        amountLitersLabel.text = "\(liters) L"
        return liters
    }
    
    private func avgFuelCons() {
        var avgFuel: Double = 0
        
        if totalLiters() == 0 || amountOdometer() == 0 {
            averageFuelConsLabel.text = "0 l/100km"
        } else { avgFuel = totalLiters() / amountOdometer()  * 100
            averageFuelConsLabel.text = "\(round(avgFuel * 10) / 10 ) l/100km"
        }
    }
    
    @IBAction private func fuelButtonDidTap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "\(FillingDetailVC.self)") as! FillingDetailVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - helpers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension FuelVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataService.context.delete(fills.remove(at: indexPath.row))
            tableView.deleteRows(at: [indexPath], with: .fade)
            CoreDataService.saveContext()
            totalFuelSpent()
            avgFuelCons()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension FuelVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(FuelTableViewCell.self)",
                                                 for: indexPath) as! FuelTableViewCell
        let fills = fills[indexPath.row]
        cell.dateLabel.text = fills.date
        cell.priceLabel.text = "\(fills.price) BYN"
        cell.odometerLabel.text = "\(fills.odometer) km"
        cell.litersLabel.text = "\(fills.liters)"
        cell.backgroundColor = .clear
        return cell
    }
    
}
