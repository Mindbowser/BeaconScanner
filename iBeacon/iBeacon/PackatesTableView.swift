//
//  PackatesTableView.swift
//  iBeacon
//
//  Created by Mindbowser on 09/06/16.
//  Copyright © 2016 Mindbowser. All rights reserved.
//

import UIKit

class PackatesTableView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet   var packatesTable:UITableView?
    var cellDataArray = [AnyObject]()
    var  selectedRowStr : NSString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cellDataArray = ["10.0","20.0","30.0","40.0"]
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifire", forIndexPath: indexPath)
        cell.textLabel?.text = cellDataArray[indexPath.row] as? String
        if ((selectedRowStr?.isEqualToString(cellDataArray[indexPath.row] as! String)) == true)
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSUserDefaults.standardUserDefaults().setObject(cellDataArray[indexPath.row] as! String, forKey: "selected")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: backButton Action
    @IBAction func backbuttonclick() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
