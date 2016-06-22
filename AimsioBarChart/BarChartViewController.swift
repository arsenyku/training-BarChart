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
  
  var bars = [UIView]()
  
  @IBOutlet weak var assetPicker: UIPickerView!
  @IBOutlet weak var signalLabel: UILabel!
  @IBOutlet weak var timeSegment: UISegmentedControl!
  @IBOutlet weak var chartView: UIView!
  
  // MARK: lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    signalLabel.rotate(by: -π/2)

  }
  
  override func viewDidLayoutSubviews() {
    
    if (dataController.signals.count < 1) {
      dataController.fetchSignals(dataReady)
    } else {
      drawBars()
    }
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  

  // MARK: Bar Chart
  
  func dataReady() -> Void {
    print ("Imported \(dataController.signals.count) assets")
    
    drawBars()
    
    print ("Done")
  }
  
  
  func drawBars() {
    for bar in bars{
      bar.removeFromSuperview()
    }
    bars.removeAll()
    
    let groupedData = dataController.groupSignalsByDay()
    
    let ascendingKeys = groupedData.keys.sort({ $0.isBefore($1) })
    let dayOfMaxSignals = groupedData.keys.maxElement({ groupedData[$0]!.count < groupedData[$1]!.count })!
    let maxSignals = CGFloat(groupedData[dayOfMaxSignals]!.count)
    let heightOfChart = CGFloat(chartView.frame.size.height)
    
    var created:CGFloat = 0.0
    for date in ascendingKeys {
      
      let signalsForGroup = CGFloat( groupedData[date]!.count )
      
      let width:CGFloat = 10
      let height = heightOfChart * (signalsForGroup / maxSignals)
      
      let bar = UIView(frame: CGRectMake(created * width,heightOfChart-height,width,height))
      bar.backgroundColor = UIColor.blueColor()
      
      bars.append(bar)
      chartView.addSubview(bar)
      
      created += 1
    }

  }


}

