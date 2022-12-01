//
//  NeoFeedViewController.swift
//  AsteroidNeoApp
//
//  Created by HimAnshu Patel on 28/11/22.
//

import UIKit
import Charts
import SVProgressHUD

class NeoFeedViewController: UIViewController {
    
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var lblFastestAsteroid: UILabel!
    @IBOutlet weak var lblClosestAsteroid: UILabel!
    @IBOutlet weak var lblAvgSizeOfAsteroid: UILabel!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var viewSearch: UIView!
    
    var ITEM_COUNT = 0
    var activeLabel: UILabel?
    var arrResponse: NeoFeeds?
    var arrAsteroids = [NearEarthObject]()
    var arrDates = [String]()
    
    // MARK: - viewDidLoad
    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSearch.isHidden = true
                
        txtStartDate.addInputViewDatePicker(target: self, selector: #selector(donePressedStartDate))
        txtEndDate.addInputViewDatePicker(target: self, selector: #selector(donePressedEndDate))

        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchFeeds)), animated: true)
    }
    
    // MARK: - viewDidAppear
    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        callAPINeoFeeds()
    }
    
    // MARK: - Navigation Item Action
    //---------------------------------------------------------------------------------------------------------------------------------------------
    @objc func searchFeeds() {
        UIView.animate(withDuration: 0.3) {
            self.viewSearch.isHidden = !self.viewSearch.isHidden
        }
    }
    
    // MARK: - DatePicker Input Views
    //---------------------------------------------------------------------------------------------------------------------------------------------
    @objc func donePressedStartDate() {
        if let  datePicker = self.txtStartDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            self.txtStartDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtStartDate.resignFirstResponder()
     }
    
    @objc func donePressedEndDate() {
        if let  datePicker = self.txtEndDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            self.txtEndDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtEndDate.resignFirstResponder()
     }
    
    // MARK: - Action Methods
    //---------------------------------------------------------------------------------------------------------------------------------------------
    @IBAction func actionSearch(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.viewSearch.isHidden = true
        }
        
        arrResponse = nil
        arrAsteroids.removeAll()
        arrDates.removeAll()
        
        callAPINeoFeeds()
    }
    
    // MARK: - API Call - Neo Feeds
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func callAPINeoFeeds() {
        SVProgressHUD.show()
        
        fetchNeoFeeds(startDate: txtStartDate.text ?? "", endDate: txtEndDate.text ?? "") { feeds in
            DispatchQueue.main.async {
                self.arrResponse = feeds
                
                let feedsKeys = feeds?.near_earth_objects?.near_earth_objects?.keys
                
                if let keys = feedsKeys {
                    for i in keys {
                        let objects = feeds?.near_earth_objects?.near_earth_objects?[i]
                        self.arrAsteroids.append(contentsOf: objects ?? [NearEarthObject]())
                        self.arrDates.append(i)
                    }
                }
                
                if self.arrAsteroids.count > 0 {
                    
                    self.title = (self.txtStartDate.text ?? "") + " to " + (self.txtEndDate.text ?? "")
                    
                    var fastestAst: NearEarthObject = self.arrAsteroids.first!
                    var closestAst: NearEarthObject = self.arrAsteroids.first!
                    var diameter_min = 0.0
                    var diameter_max = 0.0
                    
                    for i in self.arrAsteroids {
                        let iVelocity = Double(i.close_approach_data?.first?.relative_velocity?.kilometers_per_hour ?? "0") ?? 0.0
                        let fastestVelocity = Double(fastestAst.close_approach_data?.first?.relative_velocity?.kilometers_per_hour ?? "0") ?? 0.0
                        if iVelocity > fastestVelocity {
                            fastestAst = i
                        }
                        
                        let iDistance = Double(i.close_approach_data?.first?.miss_distance?.kilometers ?? "0") ?? 0.0
                        let closestDistance = Double(closestAst.close_approach_data?.first?.miss_distance?.kilometers ?? "0") ?? 0.0
                        if iDistance < closestDistance {
                            closestAst = i
                        }
                        
                        diameter_min = diameter_min + (i.estimated_diameter?.meters?.estimated_diameter_min ?? 0.0)
                        diameter_max = diameter_max + (i.estimated_diameter?.meters?.estimated_diameter_max ?? 0.0)
                    }
                    
                    self.lblFastestAsteroid.text = "\(fastestAst.name ?? "")\n\(fastestAst.close_approach_data?.first?.relative_velocity?.kilometers_per_hour ?? "0") km/h"
                    
                    self.lblClosestAsteroid.text = "\(closestAst.name ?? "")\n\(closestAst.close_approach_data?.first?.miss_distance?.kilometers ?? "0") km"
                    
                    self.lblAvgSizeOfAsteroid.text = "Min - average = \(diameter_min/Double(self.arrAsteroids.count)) meters" + "\n" + "Max - average = \(diameter_max/Double(self.arrAsteroids.count)) meters"
                    
                    self.setupChartView()
                }
                SVProgressHUD.dismiss()
            }
        }
    }
}

// MARK: - Extension - ChartViewDelegate
//---------------------------------------------------------------------------------------------------------------------------------------------
extension NeoFeedViewController: ChartViewDelegate {
    
    func setupChartView() {
                
        chartView.delegate = self
        chartView.chartDescription.enabled = false
        chartView.tintColor = .white
        chartView.backgroundColor = .white
                
        let l = chartView.legend
        l.wordWrapEnabled = true
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 3
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0
                        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = 0
        xAxis.granularity = 1
        xAxis.valueFormatter = self
        xAxis.centerAxisLabelsEnabled = true
        
        self.setChartData()
    }
        
    func setChartData() {
        
        ITEM_COUNT = arrDates.count
        
        var data = BarChartData()
        data = generateBarData()
        
        chartView.xAxis.axisMaximum = data.xMax + 0.5
        chartView.data = data
        chartView.animate(yAxisDuration: 2.5)
    }
        
    func generateBarData() -> BarChartData {
        let entries1 = (0..<ITEM_COUNT).map { (i) -> BarChartDataEntry in
            let keyName = arrDates[i]
            let yData = String(format: "%d", arrResponse?.near_earth_objects?.near_earth_objects?[keyName]?.count ?? 0)
            return BarChartDataEntry(x: Double(i) + 0.5, yValues: [Double(yData) ?? 0.00])
        }

        let set1 = BarChartDataSet(entries: entries1, label: "Total number of asteroids for each day")
        set1.stackLabels = ["Total number of asteroids for each day"]
        set1.colors = [UIColor.lightGray]
        set1.valueTextColor = UIColor.black
        set1.valueFont = .systemFont(ofSize: 10)
        set1.axisDependency = .left

        let data: BarChartData = BarChartData(dataSets: [set1])
        return data
    }
}

// MARK: - Extension - AxisValueFormatter
//---------------------------------------------------------------------------------------------------------------------------------------------
extension NeoFeedViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if value == -1 {
            return ""
        }
        return arrDates[Int(value) % arrDates.count]
    }
}
