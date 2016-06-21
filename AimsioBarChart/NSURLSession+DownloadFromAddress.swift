//
//  NSURLSession+DownloadFromAddress.swift
//  AimsioBarChart
//
//  Created by asu on 2016-06-21.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit

extension NSURLSession {
  class func downloadFromAddress(address: String, completion: (resultFileUrl:NSURL?, response:NSURLResponse?, error:NSError?) -> Void) -> NSURLSessionDownloadTask? {
    guard let url = NSURL(string:address) else { return nil }
    
    let session = NSURLSession.sharedSession()
    let dataTask = session.downloadTaskWithURL(url, completionHandler: completion)
    
    dataTask.resume()
    
    return dataTask
    
  }
}



