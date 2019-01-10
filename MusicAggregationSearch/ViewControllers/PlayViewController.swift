//
//  PlayViewController.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2019/1/10.
//  Copyright © 2019 com.cjinchi. All rights reserved.
//

import UIKit
import AVKit

class PlayViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var playControlButton: UIButton!
    
    let player = SongPlayer()
    var currentSong:Song? = nil
   
    let playImage = UIImage(named: "play")
    let pauseImage = UIImage(named: "pause")
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Hello?"
        
        
        
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        Downloader.downloadImage(withUrl: "https://api.bzqll.com/music/netease/pic?id=492639342&imgSize=400&key=579621905"){img in
            self.imageView.image = img
            
        }
    }
    
    func updateWith(newSongToPlay song:Song){
        currentSong = song
    }
    
    @IBAction func playControlButtonClicked(_ sender: UIButton) {
        if player.isPlaying(){
            player.pause()
            playControlButton.imageView?.image = playImage
        }else if(player.hasSongToPlay()){
            player.play()
            playControlButton.imageView?.image = pauseImage
        }
    }
    
    

}
