//
//  StarTableViewController.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2019/1/11.
//  Copyright © 2019 com.cjinchi. All rights reserved.
//

import UIKit

class StarTableViewController: UITableViewController {

    var songSourceImages = [SongSource:UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        for source in SongSource.allCases{
            songSourceImages[source] = UIImage(named: source.imageName)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let saved = loadSongs(){
            StarTableViewController.starSongs = saved
            print("get")
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return StarTableViewController.starSongs.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SongTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?SongTableViewCell
            else{
                fatalError("Invalid dequeued cell.")
        }
        
        let result = StarTableViewController.starSongs[indexPath.row]
        cell.setCellInfo(songTitle: result.title, songMoreInfo: result.artist, songSourceImage: songSourceImages[result.source]!)
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
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

    static var starSongs = [Song]()
    
    
    static func saveSongs() {
        print("star",starSongs.count)
        print(starSongs[0].title)
        let successful = NSKeyedArchiver.archiveRootObject(starSongs, toFile: Song.ArchiveURL.path)
        if successful{
            print("save successful")
        }else{
            print("save failed")
        }
    }
    
    func loadSongs()->[Song]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Song.ArchiveURL.path) as? [Song]
    }

}
