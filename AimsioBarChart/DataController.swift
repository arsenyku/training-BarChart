//
//  DataController.swift
//  AimsioBarChart
//
//  Created by asu on 2016-06-21.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import UIKit
import CoreData


class DataController {

  let dateFormatter: NSDateFormatter!
  
  var signals = [Signal]()
  
  enum DataIndex:Int {
    case unitNumber = 0
    case status = 1
    case entryDate = 2
  }
  
  enum DataFields:String {
    case unitNumber = "unitNumber"
    case status = "status"
    case entryDate = "entryDate"
  }
  
  init() {
    dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "\"yyyy-MM-dd HH:mm:ss\""
  }
  
  // MARK: - Data methods
  
  
  func importFromCsv(sourceFile:String, completion: ((importedData:[Signal]) -> Void)? ) {
    
    NSURLSession.downloadFromAddress(sourceFile) { [unowned self] (resultFileUrl, response, error) in
      let newline = "\n"
      guard let raw = try? String(contentsOfURL: resultFileUrl!) else { return }
      
      let lines = raw.splitBy(newline)
      
      for line in lines {
        
        if (line.hasPrefix("\"AssetUN\"") || line == "") { continue }
        
        let fields = line.splitBy(",")
        
        guard let signal = NSEntityDescription.insertNewObjectForEntityForName(Signal.ENTITY_NAME, inManagedObjectContext: self.managedObjectContext) as? Signal else { continue }
        
        signal.unitNumber = fields[ DataIndex.unitNumber.rawValue ]
        signal.status = fields[ DataIndex.status.rawValue ]
        signal.entryDate = self.dateFormatter.dateFromString( fields[ DataIndex.entryDate.rawValue ] )
        
        //print ("\(asset.unitNumber), \(asset.status), \(asset.entryDate)")
        
        self.signals.append(signal)
        
      }
      
      print ("Saving Context")
      
      self.saveContext()
      
      completion?(importedData: self.signals)
      
    }
    
  }
  
  
  func deleteAllAssets(completion: (() -> Void)?){
    let fetchRequest = NSFetchRequest(entityName: Signal.ENTITY_NAME)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try persistentStoreCoordinator.executeRequest(deleteRequest, withContext: managedObjectContext)
    } catch let error as NSError {
      print ("Error in deleteAllAssets: \(error.userInfo)")
    }
    
    saveContext()
    
    completion?()
  }
  
  
  func fetchDistinct(attributeName:String)->[AnyObject] {
    let fetchRequest = NSFetchRequest(entityName: Signal.ENTITY_NAME)

    fetchRequest.resultType = .ManagedObjectResultType
    fetchRequest.propertiesToFetch = [attributeName]
    fetchRequest.returnsDistinctResults = true
    
    guard let fetched = try? managedObjectContext.executeFetchRequest(fetchRequest) as! [Signal] else { return [] }
    
    let attributes = fetched.map { (fetchedSignal) -> AnyObject in
      fetchedSignal.valueForKey(attributeName)!
    }
    
    return attributes
    
  }


  func groupSignalsByDay() -> [ NSDate:[Signal] ] {
    var result = [ NSDate:[Signal] ]()
    
    for signal in signals {
      let day = signal.entryDate!.startOfDay()
      if let _ = result[day] {
        result[day]!.append(signal)
      } else {
        result[day] = [signal]
      }
    }
    
    return result
  }

  
  
  // MARK: - Core Data stack
  
  lazy var applicationDocumentsDirectory: NSURL = {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ArsenykUstaris.AimsioBarChart" in the application's documents Application Support directory.
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1]
  }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    let modelURL = NSBundle.mainBundle().URLForResource("AimsioBarChart", withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
  }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    // Create the coordinator and store
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
    var failureReason = "There was an error creating or loading the application's saved data."
    do {
      try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
    } catch {
      // Report any error we got.
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = failureReason
      
      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      // Replace this with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      abort()
    }
    
    return coordinator
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.persistentStoreCoordinator
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
      } catch {
        print ("Failed to save")
      }
    }
  }
 
  
}

