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
import CoreData

class SearchTableViewController: UITableViewController,UISearchBarDelegate{
    
    @IBOutlet weak var keywordSearchBar: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)
    
    static var stvc:SearchTableViewController?
    
    var results = [Song]()
    var songSourceImages = [SongSource:UIImage]()
    let query = Query()
    let playViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as! PlayViewController
//    var updatding = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchTableViewController.stvc = self
        
        keywordSearchBar.delegate = self
        
        for source in SongSource.allCases{
            songSourceImages[source] = UIImage(named: source.imageName)
        }
        
        
        let managedObectContext = NSPersistentContainer(name: "SongList").viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SongList", in: managedObectContext)
        let song = NSManagedObject(entity: entity!, insertInto: managedObectContext)
        song.setValue("text", forKey: "title")
        do {
            try managedObectContext.save()
        } catch  {
            fatalError("无法保存")
        }
        
        let managedObectContext2 = NSPersistentContainer(name: "SongList").viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SongList")

        do {
            let fetchedResults = try managedObectContext2.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                print(results.count)
                
                tableView.reloadData()
            }else{
                print("fail core data")
            }
            
        } catch  {
            fatalError("获取失败")
        }
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        App.playViewController.updateWith(newSongToPlay: results[indexPath.row])

        self.navigationController?.pushViewController(App.playViewController, animated: true)
        
        
        Query.updateData(song: results[indexPath.row])

//        songUrl: results[indexPath.row].downloadUrl+"&br=128000"
//        playSong(stringUrl: results[indexPath.row].downloadInfo+"&br=128000")
//        if results[indexPath.row].source == .KG{
//            query.getKGSongUrl(hash: results[indexPath.row].downloadInfo){mp3Url in
//                print(mp3Url)
//                self.playSong(stringUrl: mp3Url)
//
//            }
//        }else{
//
//
//
////            print("to play")
////            print(results[indexPath.row].downloadInfo)
////            let songUrl = NSURL(string: results[indexPath.row].downloadInfo)!
////            let player = AVPlayer(url: songUrl as URL)
////            let playerViewController = AVPlayerViewController()
////            playerViewController.player = player
////            present(playerViewController, animated: true, completion: nil)
////            player.play()
////            player.pau
//            playSong(stringUrl: results[indexPath.row].downloadInfo+"&br=128000")
//
//
//
//        }
    }
    
//    func playSong(stringUrl:String) -> (){
////        player?.pause()
//        if queuePlayer == nil{
//            queuePlayer = AVQueuePlayer()
//        }
//        queuePlayer?.pause()
//        queuePlayer?.removeAllItems()
//        let songUrl = NSURL(string: stringUrl)!
//        //            let player = AVPlayer(url: songUrl as URL)
//        let playerItem = AVPlayerItem(url: songUrl as URL)
//        queuePlayer?.insert(playerItem, after: nil)
////        player = AVPlayer(playerItem: playerItem)
//
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = CGRect(x: 10, y: 30, width: 100, height: 200)
//        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
//        self.view.layer.addSublayer(playerLayer)
//
//        queuePlayer?.play()
//
////        self.navigationItem.leftBarButtonItem?.isEnabled = false
////        self.navigationItem.rightBarButtonItem?.isEnabled = true
//    }

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
//        updatding = true
        
        query.getResultsFromAllSource(keyword: searchBar.text!){songs in
            self.results = Filter.dumplicateFilter(rawData: songs)
            self.tableView.reloadData()
            
        }
        
        
        self.tableView.reloadData()
//        updatding = false
        
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        <#code#>
//    }
    
    
    @IBAction func showDetail(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(App.playViewController, animated: true)
    }
    
    func searchRecognitionSong(title :String){
        self.keywordSearchBar.text = title
        self.searchBarSearchButtonClicked(keywordSearchBar)
    }
    
}
