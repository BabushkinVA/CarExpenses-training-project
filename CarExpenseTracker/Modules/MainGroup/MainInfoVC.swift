//
//  MainInfoVC.swift
//  CarExpenseTracker
//
//  Created by Vadim on 8.10.23.
//

import UIKit
import DGCharts

final class MainInfoVC: UIViewController, CarInfoDelegate {
    
    @IBOutlet private weak var carMakeLabel: UILabel!
    @IBOutlet private weak var carModelLabel: UILabel!
    @IBOutlet private weak var odometerLabel: UILabel!
    @IBOutlet private weak var mileageLabel: UILabel!
    @IBOutlet private weak var rubForKMLabel: UILabel!
    @IBOutlet private weak var totalSpentLabel: UILabel!
    @IBOutlet private weak var totalSpentOnFuelLabel: UILabel!
    @IBOutlet private weak var totalSpentOnServiceLabel: UILabel!
    @IBOutlet private weak var pieChart: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBlack
        
        loadCarData()
        setupChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadAllFuncs()
        mileageLabel.text = "\(totalMileage()) km"
    }
    
    func loadAllFuncs() {
        loadMaxOdo()
        loadTotalFuelCost()
        loadServiceInfo()
        setupChart()
        averageKmPrice()
        totalSpent()
    }
    
    //MARK: - MainInfoVCDelegateSettings
    func carInfoDidChange(_ carMake: String, _ carModel: String) {
        carMakeLabel.text = carMake
        carModelLabel.text = carModel
    }
    
    //MARK: - UserDefaults
    private func loadCarData() {
        let ud = UserDefaults.standard
        
        if let profileData = ud.data(forKey: "kProfileData"),
           let profile = try? JSONDecoder().decode(CarProfile.self, from: profileData) {
            setupUI(with: profile)
        }
    }
    
    private func setupUI(with profile: CarProfile) {
        carMakeLabel.text = profile.make
        carModelLabel.text = profile.model
    }
    
    //garage_Button
    @IBAction private func garageButtonDidTap() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "\(CarDataVC.self)") as! CarDataVC
        vc.delegate = self
        if carMakeLabel.text != "make" && carModelLabel.text != "model" {
            vc.carMake = carMakeLabel.text
            vc.carModel = carModelLabel.text
        } else {
            vc.carMake = ""
            vc.carModel = ""
        }
        present(vc, animated: true)
    }
    
    // Odometer_Label
    private func loadMaxOdo() {
        let fuelOdoRequest = FuelMO.fetchRequest()
        let serviceOdoRequest = ServiceMO.fetchRequest()
        
        let fueoOdo = (try? CoreDataService.context.fetch(fuelOdoRequest)) ?? []
        let lastFuelOdo = fueoOdo.sorted{ $0.odometer < $1.odometer }.last?.odometer
        
        let servOdo = (try? CoreDataService.context.fetch(serviceOdoRequest)) ?? []
        let lastServOdo = servOdo.sorted{ $0.odometer < $1.odometer }.last?.odometer
        
        if let a = lastFuelOdo,
           let b = lastServOdo {
            a >= b ? (odometerLabel.text = "\(a) km") : (odometerLabel.text = "\(b) km")
        } else if let a = lastFuelOdo {
            odometerLabel.text = "\(a) km"
        } else if let b = lastServOdo {
            odometerLabel.text = "\(b) km"
        } else {
            return }
    }
    
    // MARK: - Work with CoreData
    private var serviceDict = [String: Double]()
    
    private func loadServiceInfo() {
        let request = ServiceMO.fetchRequest()
        let servicePrice = (try? CoreDataService.context.fetch(request)) ?? []
        
        var totalService: Double = 0
        var sumRepair: Double = 0
        var sumTuning: Double = 0
        var sumInsurance: Double = 0
        var sumParts: Double = 0
        var sumCarwash: Double = 0
        var sumOther: Double = 0
        
        servicePrice.forEach {
            if $0.category == Category.repair.rawValue {
                sumRepair += $0.amount
            } else if $0.category == Category.tuning.rawValue {
                sumTuning += $0.amount
            } else if $0.category == Category.insurance.rawValue {
                sumInsurance += $0.amount
            } else if $0.category == Category.parts.rawValue {
                sumParts += $0.amount
            } else if $0.category == Category.carwash.rawValue {
                sumCarwash += $0.amount
            } else if $0.category == Category.other.rawValue {
                sumOther += $0.amount
            }
        }
        serviceDict["Repair"] = sumRepair
        serviceDict["Tuning"] = sumTuning
        serviceDict["Insurance"] = sumInsurance
        serviceDict["Parts"] = sumParts
        serviceDict["Car wash"] = sumCarwash
        serviceDict["Other"] = sumOther
        
        servicePrice.forEach { totalService += $0.amount }
        totalSpentOnServiceLabel.text = "\(totalService) BYN"
    }
    
    private func totalSpent() {
        var totalSpent: Double = 0
        serviceDict.values.forEach { totalSpent += $0 }
        totalSpentLabel.text = "\(round(totalSpent * 100) / 100) BYN"
    }
    
    
    private func averageKmPrice() {
        var totalSpent: Double = 0
        serviceDict.values.forEach { totalSpent += $0 }
        
        if totalSpent == 0 || totalMileage() == 0 {
            rubForKMLabel.text = "0 BYN/km"
        } else {
            let result = totalSpent / Double(totalMileage())
            rubForKMLabel.text = "\(round(result * 100) / 100) BYN/km"
        }
    }
    
    private func loadTotalFuelCost() {
        var fuelSum: Double = 0
        let amountFuelRequest = FuelMO.fetchRequest()
        let fuelCost = (try? CoreDataService.context.fetch(amountFuelRequest)) ?? []
        
        fuelCost.forEach {
            fuelSum += $0.price
        }
        serviceDict["Fuel"] = fuelSum
        totalSpentOnFuelLabel.text = "\(round(fuelSum * 100) / 100) BYN"
    }
    
    private func setupChart()  {
        
        var entries = [PieChartDataEntry]()
        
        let colors: [UIColor] = [.blue, .systemPurple, .green, .orange, .systemCyan, .systemPink, .magenta]
        
        for (key, value) in serviceDict {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = key
            entries.append(entry)
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.colors = colors
        set.sliceSpace = 2.0
        set.selectionShift = 30
        set.xValuePosition = .outsideSlice
        set.yValuePosition = .outsideSlice
        set.valueTextColor = UIColor.white
        set.valueLineWidth = 0.6
        set.valueLineColor = .white
        set.valueLinePart1Length = 0.4
        set.valueLinePart2Length = 0.25
        set.valueLinePart1OffsetPercentage = 0.96
        
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        pieChart.noDataText = "No data available"
        pieChart.isUserInteractionEnabled = true
        data.setValueTextColor(NSUIColor.white)

        pieChart.holeRadiusPercent = 0.5
        pieChart.holeColor = .clear
        pieChart.transparentCircleColor = UIColor.clear
        pieChart.drawEntryLabelsEnabled = false
    }
}
