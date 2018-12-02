//
//  SearchTableViewController.swift
//  MusicAggregationSearch
//
//  Created by cjinchi
//  Copyright © 2018 com.cjinchi. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class SearchTableViewController: UITableViewController,UISearchBarDelegate,URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    

    
    @IBOutlet weak var keywordSearchBar: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)
    
    var results = [Song]()
    var songSourceImages = [SongSource:UIImage]()
    let query = Query()
    var updatding = false
    
    private func loadSampleSongs(){
//        let song1 = Song(title: "我爱南京", artist: "李志",source: .WY)
//        let song2 = Song(title: "New Boy", artist: "朴树", source: .QQ)
//        let song3 = Song(title: "一切", artist: "程璧", source: .XM)
//
//        results += [song1,song2,song3]
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keywordSearchBar.delegate = self
        
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
    
    func playSong(song:Song){
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
        
        if results[indexPath.row].source == .KG{
            print("can't play now")
        }else{
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print(error)
            }
            
            print("to play")
            print(results[indexPath.row].downloadInfo)
            let songUrl = NSURL(string: results[indexPath.row].downloadInfo)!
            let player = AVPlayer(url: songUrl as URL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
//            playerViewController.view.frame = CGRect(x: 0, y: 0, width: 5, height: 5)

//            playerViewController.entersFullScreenWhenPlaybackBegins = true
//            playerViewController.exitsFullScreenWhenPlaybackEnds = true
            present(playerViewController, animated: true, completion: nil)
            

//            self.view.addSubview(playerViewController.view)
//            self.addChild(playerViewController)
            
            player.play()
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.frame = CGRect(x: 10, y: 30, width: self.view.bounds.size.width-10, height: 200)
//            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
//            self.view.layer.addSublayer(playerLayer)
//            player.play()
//            print("play finish")
        }
    }

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
        cell.setCellInfo(songTitle: result.title, songMoreInfo: result.artist, songSourceImage: songSourceImages[result.source]!)
        

        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        updatding = true
        
        query.getResultsFromAllSource(keyword: searchBar.text!){songs in
            self.results = songs
            self.tableView.reloadData()
            
        }
        
        
        self.tableView.reloadData()
        updatding = false
        
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
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
