//
//  BeaconTableCell.swift
//  iBeacon
//
//  Created by Mindbowser on 08/06/16.
//  Copyright © 2016 Mindbowser. All rights reserved.
//

import UIKit

class BeaconTableCell: UITableViewCell {
    @IBOutlet var beaconNameLabel: UILabel?
    @IBOutlet var beaconLocationLabel:UILabel?
    @IBOutlet var beaconMajorLabel:UILabel?
    @IBOutlet var beaconMinorLabel:UILabel?
    @IBOutlet var SamplingAverageLabel:UILabel?
    @IBOutlet var beaconDistanceLabel:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
