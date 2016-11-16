//
//  StationViewController.swift
//  jsrl
//
//  Created by Fisk on 15/11/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import UIKit

class StationViewController: UITableViewController {
    let defaults = UserDefaults.standard
    let stations = Stations.shared.list
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let station = stations[indexPath.row]
        let cellIdentifier: String = "StationViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! StationViewCell
        let image = station.getImageAsset()
        
        cell.stationName.text = station.name
        cell.stationGenre.text = station.genre
        cell.stationArt.image = image
        cell.stationArt.backgroundColor = UIColor(hexString: station.color)
        
        cell.sizeToFit()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = Player.shared
        let library = Library.shared
        let station = stations[indexPath.row]
        
        // Preserve station selection if app is restarted
        defaults.set(station.name, forKey: "selectedStation")
        
        player.activeStation = station
        let tracks = library.getTracksIn(station: player.activeStation)
        player.playlist = Playlist(tracks)
        player.playlist.shuffle()
        player.next()
        
        _ = self.navigationController?.popViewController(animated: true)
    }
}

class StationViewCell: UITableViewCell {
    @IBOutlet weak var stationArt: UIImageView!
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var stationGenre: UILabel!
}

extension UIColor {
    /**
     Convenience function by yannickl
     https://gist.github.com/yannickl/16f0ed38f0698d9a8ae7
     */
    convenience init(hexString:String) {
        let hexString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        let mask = 0x000000FF
        var color:UInt32 = 0
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        scanner.scanHexInt32(&color)
        
        let red   = CGFloat(Int(color >> 16) & mask) / 255.0
        let green = CGFloat(Int(color >> 8) & mask) / 255.0
        let blue  = CGFloat(Int(color) & mask) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}
