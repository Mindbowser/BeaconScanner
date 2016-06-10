import UIKit
import CoreLocation
import KontaktSDK
class ItemCell: UITableViewCell {  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    //item = nil
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
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
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    if let anItem = object as? Item {
      if anItem == item && keyPath == "lastSeenBeacon" {
        let proximity = nameForProximity(anItem.lastSeenBeacon!.proximity)
        let accuracy = NSString(format: "%.2f", anItem.lastSeenBeacon!.accuracy)
        detailTextLabel!.text = "Location: \(proximity) (approx. \(accuracy)m)"
      }
    }
  }
//    func calculateAccuracy(txPower:Int, rssi:Int)-> Int {
//    if (rssi == 0) {
//    return -1; // if we cannot determine accuracy, return -1.
//    }
//    
//        var ratio = rssi * 1 / txPower;
//    if (ratio < 1) {
//        
//    return Math.pow(ratio, 10);
//    } else {
//    return (0.89976) * Math.pow(ratio, 7.7095) + 0.111;
//    }
//    }
}
