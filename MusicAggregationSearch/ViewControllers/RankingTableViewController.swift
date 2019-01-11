//
//  RankingTableViewController.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2018/12/3.
//  Copyright © 2018 com.cjinchi. All rights reserved.
//

import UIKit

class RankingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for source in SongSource.allCases{
            songSourceImages[source] = UIImage(named: source.imageName)
        }
        
//        let query = Query()
//        query.getHotSongList(){hotResults in
//            self.results.removeAll()
//            for i in hotResults{
//                self.results.append(i)
//            }
//        }
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        print("456")
        Ranking.getAllRanking(){result in
            print("123")
            self.results.removeAll()
//            for i in result{
//                self.results.append(i)
//            }
        
            self.results = Filter.dumplicateFilter(rawData: result)
            self.tableView.reloadData()
            self.indicator.stopAnimating()
        }
        
    }

    // MARK: - Table view data source
    
    var results = [Song]()
    var songSourceImages = [SongSource:UIImage]()
    
    let indicator = UIActivityIndicatorView(frame: CGRect(x: 100, y: 50, width: 20, height: 20))

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        App.playViewController.updateWith(newSongToPlay: results[indexPath.row])
        self.navigationController?.pushViewController(App.playViewController, animated: true)
        Query.updateData(song: results[indexPath.row])
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
 
    @IBAction func showDetail(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(App.playViewController, animated: true)
    }
    
}
