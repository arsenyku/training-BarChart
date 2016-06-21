//
//  ViewController.swift
//  AimsioBarChart
//
//  Created by asu on 2016-06-20.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit
import CoreData

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
  
  func dataReady(importedData:[Asset]) -> Void {
    print ("Imported \(importedData.count) assets")
  }


}

