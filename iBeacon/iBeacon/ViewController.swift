//
//  ViewController.swift
//  iBeacon
//
//  Created by Mindbowser on 06/06/16.
//  Copyright © 2016 Mindbowser. All rights reserved.
//

import UIKit
import CoreLocation
import KontaktSDK

class ViewController: UIViewController,CLLocationManagerDelegate,KTKBeaconManagerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    //Kontakt.io proximity UUID
    var beaconregion:KTKBeaconRegion = KTKBeaconRegion(proximityUUID: NSUUID(UUIDString: "F7826DA6-4FA2-4E98-8024-BC5B71E0893E")!, identifier: "KontaKt")
    
    var beaconManger:KTKBeaconManager!
    @IBOutlet  var tableviw:UITableView!
    var items:NSMutableArray = NSMutableArray()
    var perPackateStr: NSString?
    var beaconsDictionary:NSMutableDictionary = NSMutableDictionary()
    var objectArray:NSMutableArray = NSMutableArray()
    var isfirstTime:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create region instance
        beaconManger = KTKBeaconManager(delegate: self)
        self.beaconManger.requestLocationAlwaysAuthorization()
        // Start Monitoring
        self.beaconManger.startMonitoringForRegion(beaconregion)
        // You can also start ranging ...
        self.beaconManger.startRangingBeaconsInRegion(beaconregion)
    }
    
    @IBAction func changePacketSetting() {
        objectArray.removeAllObjects()
        beaconsDictionary.removeAllObjects()
        isfirstTime  = false
        self.performSegueWithIdentifier("packates", sender: self)
    }
    
    // MARK: KTKBeaconManagerDelegate
    
    func beaconManager(manager: KTKBeaconManager, didChangeLocationAuthorizationStatus status: CLAuthorizationStatus) {
        print("Location authority changed")
    }
    
    func beaconManager(manager: KTKBeaconManager, didEnterRegion region: KTKBeaconRegion) {
        print("Enter region \(region)")
    }
    
    func beaconManager(manager: KTKBeaconManager, didExitRegion region: KTKBeaconRegion) {
        print("Exit region \(region)")
    }
    
    func beaconManager(manager: KTKBeaconManager, didRangeBeacons beacons: [CLBeacon], inRegion region: KTKBeaconRegion) {
        print("Ranged beacons count: \(beacons.count)")
        print("Ranged beacons : \(beacons)")
        items.removeAllObjects()
        
        //Check for beacons with only known location
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
        for beacon in knownBeacons {
            let proximity = nameForProximity(beacon.proximity)
            let accuracy = NSString(format: "%.2f", beacon.accuracy)
            
            var average:Float = 0.0
            perPackateStr = NSUserDefaults.standardUserDefaults().valueForKey("selected") as? NSString != nil ? NSUserDefaults.standardUserDefaults().valueForKey("selected") as?
                NSString :"10.0"
            
            let allkeys: NSArray = beaconsDictionary.allKeys
            if allkeys.containsObject(beacon.minor.stringValue) {
                objectArray = (beaconsDictionary.valueForKey(beacon.minor.stringValue) as? NSMutableArray)!
                if objectArray.count == perPackateStr?.integerValue {
                    for  item in objectArray {
                        average = average + item.floatValue
                    }
                    average = average/(perPackateStr?.floatValue)!
                    print("average: \(average) beacon minor: \(beacon.minor)")
                    objectArray.removeObjectAtIndex(objectArray.count-1)
                    objectArray.insertObject(accuracy, atIndex: 0)
                    beaconsDictionary.setObject(objectArray, forKey: (beacon.minor.stringValue))
                }
                else {
                    objectArray.addObject(accuracy)
                    
                    if isfirstTime == false {
                        for  item in objectArray {
                            average = average + item.floatValue
                        }
                        average = average/Float(objectArray.count)
                        if objectArray.count > (perPackateStr!.integerValue - 1) {
                            isfirstTime = true
                        }
                        
                    }
                }
            }
            else {
                beaconsDictionary[beacon.minor.stringValue] = NSMutableArray()
            }
            
            let beaconInfoDict :NSDictionary = ["name":"Kontakt","proximity":proximity,"accuracy":accuracy,"major":beacon.major,"minor":beacon.minor,"UUID":beacon.proximityUUID,"average":average]
            items.addObject(beaconInfoDict)
        }
        
        let descriptor:NSSortDescriptor = NSSortDescriptor(key: "minor", ascending: true)
        items.sortUsingDescriptors([descriptor])
        tableviw.reloadData()
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Item", forIndexPath: indexPath) as! BeaconTableCell
        let item: NSDictionary = items[indexPath.row] as! NSDictionary
        cell.beaconNameLabel?.text = "\(item.valueForKey("name")!)"
        cell.beaconMajorLabel?.text = "Major: \(item.valueForKey("major")!)"
        cell.beaconMinorLabel?.text = "Minor: \(item.valueForKey("minor")!)"
        cell.beaconLocationLabel?.text = "Location: \(item.valueForKey("proximity")!)"
        cell.beaconDistanceLabel?.text = "\(item.valueForKey("accuracy")!) m"
        cell.SamplingAverageLabel?.text = NSString(format: "%.2f m", item.valueForKey("average") as! Float) as String
        return cell
    }
    
    func nameForProximity(proximity: CLProximity) -> String {
        switch proximity {
        case .Unknown:
            return "Unknown"
        case .Immediate:
            return "Immediate"
        case .Near:
            return "Near"
        case .Far:
            return "Far"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let packatesTable: PackatesTableView = segue.destinationViewController as! PackatesTableView
        packatesTable.selectedRowStr = perPackateStr
        
    }
    
}

