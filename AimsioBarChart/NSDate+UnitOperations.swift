//
//  NSDate+SameDay.swift
//  AimsioBarChart
//
//  Created by asu on 2016-06-21.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit

extension NSDate {
  
  func isSameDayAs(otherDate: NSDate) -> Bool {
    return NSCalendar.currentCalendar().isDate(self, inSameDayAsDate: otherDate)
  }
  
  func dateFromComponents(unitFlags: NSCalendarUnit) -> NSDate {
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components(unitFlags, fromDate: self)
    return calendar.dateFromComponents(components)!
  }
  
  func startOfYear() -> NSDate {
    return dateFromComponents([.Year])
  }

  func startOfMonth() -> NSDate {
    return dateFromComponents([.Year, .Month])
  }

  func startOfDay() -> NSDate {
    return dateFromComponents([.Year, .Month, .Day])
  }

}
