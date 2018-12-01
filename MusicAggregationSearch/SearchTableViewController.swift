//
//  SearchTableViewController.swift
//  MusicAggregationSearch
//
//  Created by cjinchi
//  Copyright © 2018 com.cjinchi. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController,UISearchBarDelegate {

    
    var results = [Song]()
    var songSourceImages = [SongSource:UIImage]()
    
    private func loadSampleSongs(){
        let song1 = Song(title: "我爱南京", artist: "李志", album: "我爱南京", source: .WY)
        let song2 = Song(title: "New Boy", artist: "朴树", album: "我去2000年", source: .QQ)
        let song3 = Song(title: "一切", artist: "程璧", album: "诗遇上歌", source: .XM)
        
        results += [song1,song2,song3]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for source in SongSource.allCases{
            songSourceImages[source] = UIImage(named: source.imageName)
        }
        
        loadSampleSongs()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        cell.setCellInfo(songTitle: result.title, songMoreInfo: result.artist+" - "+result.album, songSourceImage: songSourceImages[result.source]!)
        

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

}
