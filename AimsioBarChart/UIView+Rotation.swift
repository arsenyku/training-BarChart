//
//  UIView+Rotation.swift
//  AimsioBarChart
//
//  Created by asu on 2016-06-20.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit

extension UIView {
  
  func rotate(by radians:CGFloat){

    self.transform = CGAffineTransformMakeRotation(radians)
  
  }
  
}
