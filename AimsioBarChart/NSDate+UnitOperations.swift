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
  
  func isAfter(otherDate: NSDate) -> Bool {
    return self.compare(otherDate) == NSComparisonResult.OrderedDescending
  }
  
  func isBefore(otherDate: NSDate) -> Bool {
    return self.compare(otherDate) == NSComparisonResult.OrderedAscending
  }

  func dateFromComponents(unitFlags: NSCalendarUnit) -> NSDate {
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components(unitFlags, fromDate: self)
    return calendar.dateFromComponents(components)!
  }
  
  class func startOfYear(date:NSDate) -> NSDate {
    return date.dateFromComponents([.Year])
  }

  class func startOfMonth(date:NSDate) -> NSDate {
    return date.dateFromComponents([.Year, .Month])
  }

  class func startOfDay(date:NSDate) -> NSDate {
    return date.dateFromComponents([.Year, .Month, .Day])
  }

}
