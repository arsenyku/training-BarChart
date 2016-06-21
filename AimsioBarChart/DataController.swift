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
  
  enum DataIndex:Int {
    case unitNumber = 0
    case status = 1
    case entryDate = 2
  }
  
  init() {
    dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
  }
  
  // MARK: - Data seeding
  
  
  func importFromCsv(sourceFile:String, completion: ((importedData:[Asset]) -> Void)? ) {
    
    let localDateFormatter = dateFormatter
    let context = managedObjectContext
    
    NSURLSession.downloadFromAddress(sourceFile) { (resultFileUrl, response, error) in
      let newline = "\n"
      guard let raw = try? String(contentsOfURL: resultFileUrl!) else { return }
      
      let lines = raw.splitBy(newline)
      
      for line in lines {
        
        if (line.hasPrefix("\"AssetUN\"")) { continue }
        
        let fields = line.splitBy(",")
        
        guard let asset = NSEntityDescription.insertNewObjectForEntityForName(Asset.ENTITY_NAME, inManagedObjectContext: context) as? Asset else { continue }
        
//        asset.unitNumber = NSNumber(int: Int32(fields[ DataIndex.unitNumber.rawValue ])!)
//        asset.status = fields[ DataIndex.status.rawValue ]
//        asset.entryDate = localDateFormatter.dateFromString( fields[ DataIndex.entryDate.rawValue ] )

        asset.unitNumber = NSNumber(int: Int32(fields[ DataIndex.unitNumber.rawValue ])!)
        asset.status = fields[ DataIndex.status.rawValue ]
        asset.entryDate = localDateFormatter.dateFromString( fields[ DataIndex.entryDate.rawValue ] )

        
        print ("\(asset.unitNumber), \(asset.status), \(asset.entryDate)")
        
      }
      
      
    }
    
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
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
      }
    }
  }
 
  
}

//- (instancetype)init
//{
//  self = [super init];
//  if (self) {
//    
//    // get momd url
//    
//    NSURL *momdURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
//    
//    
//    // init MOM
//    self.mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:momdURL];
//    
//    
//    // init PSC
//    self.psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.mom];
//    
//    
//    // get data store url
//    
//    NSString *storePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"datastore.sqlite"];
//    
//    NSLog(@"StorePath: %@", storePath);
//    
//    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
//    
//    // add a NSSQLiteStoreType PS to the PSC
//    
//    NSError *storeError = nil;
//    
//    if (![self.psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&storeError]) {
//      
//      NSLog(@"Couldn't create persistant store %@", storeError);
//    }
//    
//    // make a MOC
//    
//    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    
//    
//    // set the MOCs PSC
//    
//    self.context.persistentStoreCoordinator = self.psc;
//    
//  }
//  return self;
//}

