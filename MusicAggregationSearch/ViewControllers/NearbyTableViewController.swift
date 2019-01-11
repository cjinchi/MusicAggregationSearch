//
//  NearbyTableViewController.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2018/12/4.
//  Copyright © 2018 com.cjinchi. All rights reserved.
//

import UIKit
import CoreLocation

class NearbyTableViewController: UITableViewController ,CLLocationManagerDelegate{

    var results = [Song]()
    var infos = [String]()
    var songSourceImages = [SongSource:UIImage]()
    
    let locationManager = CLLocationManager()
    
    @objc private func reload(_ sender: Any){
        print("reload")
        let query = Query()
        query.getNearbySongList(){nearbyResults,nearbyInfos in
            self.results.removeAll()
            self.infos.removeAll()
            for i in nearbyResults{
                self.results.append(i)
            }
            self.infos = nearbyInfos
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    let refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refreshController
        
        refreshControl?.addTarget(self, action: #selector(reload(_:)), for: .valueChanged)

        for source in SongSource.allCases{
            songSourceImages[source] = UIImage(named: source.imageName)
        }
        
        let query = Query()
        query.getNearbySongList(){nearbyResults,nearbyInfos in
            self.results.removeAll()
            self.infos.removeAll()
            for i in nearbyResults{
                self.results.append(i)
            }
            self.infos = nearbyInfos
            self.tableView.reloadData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        if ( CLLocationManager.authorizationStatus() == .notDetermined){
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SongTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?SongTableViewCell
            else{
                fatalError("Invalid dequeued cell.")
        }
        
        let result = results[indexPath.row]
        let info = infos[indexPath.row]
        cell.setCellInfo(songTitle: result.title+" - "+result.artist, songMoreInfo: info, songSourceImage: songSourceImages[result.source]!)
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func showDetail(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(App.playViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        App.playViewController.updateWith(newSongToPlay: results[indexPath.row])
        self.navigationController?.pushViewController(App.playViewController, animated: true)
        Query.updateData(song: results[indexPath.row])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload(self)
    }
    
    
}

extension NearbyTableViewController{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            let alert = UIAlertController(title: "无法定位", message: "由于您禁用了定位功能，该功能无法使用。", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        case .authorizedWhenInUse:
            reload(self)
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        App.coordinate = locations[0].coordinate
    }
}
