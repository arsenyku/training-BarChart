//
//  BarChart.swift
//  AimsioBarChart
//
//  Created by asu on 2016-06-22.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit

class ABCBarChart:UIView {
  
  var barWidth:CGFloat = 0
  
  var bars = [UIView]()
  
  var barValues = [Float]()

  @IBOutlet weak var scrollView: UIScrollView!

  
  func createBars(forValues values:[Float], width:CGFloat){
    print ("Create Bars start")
    
    barValues = values
    barWidth = width
    
    removeBars()
    bars.removeAll()
    
    let maxValue = CGFloat(barValues.maxElement()!)
    let heightOfChart = CGFloat(self.frame.size.height)
    
    let barHeights = barValues.map { return heightOfChart * ( CGFloat($0) / maxValue ) }
    
    bars = barHeights.map {_ in 
      
      let bar = UIView(frame:CGRectMake(0,0,0,0))
      bar.backgroundColor = UIColor.blueColor()
      return bar
      
    }
    
    print ("Create Bars end \(bars.count)")

  }
  
  func drawBars(){
    
    let heightOfChart = CGFloat(self.frame.size.height)

    print ("Draw Bars start.  chart height = \(heightOfChart)")

    guard let maxValue = barValues.maxElement() else { return }
    
    let barHeights = barValues.map { return heightOfChart * ( CGFloat($0 / maxValue) ) }
    
    for i in 0..<bars.count {
      let bar = bars[i]
      let height = barHeights[i]
      
      bar.frame = CGRectMake(CGFloat(i) * barWidth, heightOfChart-height, barWidth, height)
      scrollView.addSubview(bar)
      scrollView.contentSize = CGSize(width: CGFloat(i+1) * barWidth, height: heightOfChart)
    }
    
    print ("Draw Bars end")

  }
  
  func removeBars(){
    for bar in bars {
      bar.removeFromSuperview()
    }
  }
  
  
}
