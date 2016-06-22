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
  
  let dataController = DataController()
  
  @IBOutlet weak var assetPicker: UIPickerView!
  @IBOutlet weak var signalLabel: UILabel!
  @IBOutlet weak var timeSegment: UISegmentedControl!
  @IBOutlet weak var chartView: UIView!
  
  // MARK: lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    signalLabel.rotate(by: -π/2)
    
    dataController.fetchSignals(dataReady)
    
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: Bar Chart
  
  func dataReady() -> Void {
    print ("Imported \(dataController.signals.count) assets")
    
    print (chartView.frame.size.width)
    
    print ("Done")
  }


}

