//
//  ViewController.swift
//  AimsioBarChart
//
//  Created by asu on 2016-06-20.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit

class BarChartViewController: UIViewController {

  let π = CGFloat(M_PI)
  let sourceFileLocation = "https://raw.githubusercontent.com/arsenyku/training-BarChart/master/AimsioBarChart/query_result-iOS.csv"
  
  let dataController = DataController()
  
  @IBOutlet weak var assetPicker: UIPickerView!
  @IBOutlet weak var signalLabel: UILabel!
  @IBOutlet weak var timeSegment: UISegmentedControl!
  @IBOutlet weak var chartView: UIView!
  
  // MARK: lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    signalLabel.rotate(by: -π/2)
    
    dataController.deleteAllAssets { [unowned self] in
      self.dataController.importFromCsv(self.sourceFileLocation, completion: self.dataReady)
    }
    
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: Bar Chart
  
  func dataReady(importedData:[Signal]) -> Void {
    print ("Imported \(importedData.count) assets")
    
    print (chartView.frame.size.width)
    
    let units = dataController.fetchDistinct("unitNumber") as! [String]

//    for unit in units {
//      print(unit)
//    }
    
    print ("Distinct units: \(units.count)")

    let signalsByDay = dataController.groupSignalsByDay()
    print ("Found \(signalsByDay.keys.count) groups")
    for daily in signalsByDay {
      print ("Found \(daily.1.count) signals for \(daily.0)")
    }
    
    let signalsByMonth = dataController.groupSignalsByMonth()
    print ("Found \(signalsByMonth.keys.count) groups")
    for monthly in signalsByMonth {
      print ("Found \(monthly.1.count) signals for \(monthly.0)")
    }
    
    let signalsByYear = dataController.groupSignalsByYear()
    print ("Found \(signalsByYear.keys.count) groups")
    for yearly in signalsByYear {
      print ("Found \(yearly.1.count) signals for \(yearly.0)")
    }
    
    print ("Done")
  }


}

