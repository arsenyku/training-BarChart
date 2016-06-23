//
//  ViewController.swift
//  AimsioBarChart
//
//  Created by asu on 2016-06-20.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit

class ABCBarChartViewController: UIViewController {

  let π = CGFloat(M_PI)
  
  let dataController = ABCDataController()
  
//  var groupedData = [NSDate:[ABCSignal]]()
  
  @IBOutlet weak var assetPicker: UIPickerView!
  @IBOutlet weak var signalLabel: UILabel!
  @IBOutlet weak var timeSegment: UISegmentedControl!
  @IBOutlet weak var chartView: ABCBarChart!
  
  enum TimeSegmentIndex:Int {
    case Daily = 0
    case Monthly = 1
    case Yearly = 2
  }
  
  enum BarWidth:CGFloat {
    case Daily = 10
    case Monthly = 30
    case Yearly = 50
    
    static func forTimeSegment(index: TimeSegmentIndex) -> CGFloat {
      switch index {
        
      case TimeSegmentIndex.Monthly:
        return BarWidth.Monthly.rawValue
        
      case TimeSegmentIndex.Yearly:
        return BarWidth.Yearly.rawValue
        
      default: // TimeSegmentIndex.Daily:
        return BarWidth.Daily.rawValue
        
      }
    }
  }

  var selectedTimeSegment:TimeSegmentIndex {
    get {
      return TimeSegmentIndex(rawValue: timeSegment.selectedSegmentIndex)!
    }
  }
  
  var barWidth: CGFloat {
    get {
      return BarWidth.forTimeSegment(selectedTimeSegment)

    }
  }
  
  // MARK: lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    signalLabel.rotate(by: -π/2)

  }
  
  override func viewDidLayoutSubviews() {
    
    if (dataController.signals.count < 1) {
      dataController.initializeSignalDataIfNeeded(dataReady)
    } else {
      chartView.drawBars()
    }
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }

  // MARK: Segmented Control
  
  @IBAction func timeSegmentChanged(sender: UISegmentedControl) {
    dataReady()
  }

  // MARK: Bar Chart
  
  func dataReady() -> Void {
    print ("Found \(dataController.signals.count) assets")
    
    let groupedData = groupBySelectedTimeSegment().sort({ (signalData1, signalData2) -> Bool in
      let date1 = signalData1.0
      let date2 = signalData2.0
      return date1.isBefore(date2)
    })
    chartView.barValues = groupedData.map { return Float($0.1.count) }
    chartView.barWidth = barWidth
    
    chartView.createBars()

    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
      self.chartView.drawBars()
    }
  }
  
  func groupBySelectedTimeSegment() -> [NSDate:[ABCSignal]]{
    
    if let selectedTimeSegment = TimeSegmentIndex(rawValue: timeSegment.selectedSegmentIndex) {
      switch selectedTimeSegment {
      
      case TimeSegmentIndex.Monthly:
        return dataController.groupSignalsByMonth()
      
      case TimeSegmentIndex.Yearly:
        return dataController.groupSignalsByYear()
      
      default: // TimeSegmentIndex.Daily:
        break;
      
      }
    }
    
    return dataController.groupSignalsByDay()
    
  }

//  func createBars() {
//    print ("Creating bars")
//    
//    let groupedData = groupBySelectedTimeSegment()
//    
//    let ascendingKeys = groupedData.keys.sort({ $0.isBefore($1) })
//    let dayOfMaxSignals = groupedData.keys.maxElement({ groupedData[$0]!.count < groupedData[$1]!.count })!
//    let maxSignals = CGFloat(groupedData[dayOfMaxSignals]!.count)
//    let heightOfChart = CGFloat(chartView.frame.size.height)
//    
//    let tempBars = NSMutableArray()
//    
//    for _ in 1...groupedData.count {
//      let bar = UIView()
//      bar.backgroundColor = UIColor.blueColor()
//      tempBars.addObject(bar)
//    }
//    
//    var created:CGFloat = 0.0
//    for date in ascendingKeys {
//      
//      let signalsForGroup = CGFloat( groupedData[date]!.count )
//      
//      let width = BarWidth.forTimeSegment(selectedTimeSegment)
//      let height = heightOfChart * (signalsForGroup / maxSignals)
//      
//      let bar = UIView(frame: CGRectMake(created * width,heightOfChart-height,width,height))
//      bar.backgroundColor = UIColor.blueColor()
//      
//      tempBars.addObject(bar)
//
//      created += 1
//    }
//    
//    bars = tempBars as AnyObject as! [UIView]
//    
//    print ("Finished creating bars")
//  }
//  
//  func clearBars() {
//    for bar in bars{
//      bar.removeFromSuperview()
//    }
//  }
//  
//
//  func drawBars() {
//    print ("Drawing bars")
//
//    clearBars()
//    
//    let heightOfChart = CGFloat(chartView.frame.size.height)
//    
//    let drawn:CGFloat = 0
//    for bar in bars {
//      chartScrollView.addSubview(bar)
//      chartScrollView.contentSize = CGSize(width: (drawn+1) * barWidth, height: heightOfChart)
//    }
//
//    print ("Drawing done")
//
//  }
  
}

