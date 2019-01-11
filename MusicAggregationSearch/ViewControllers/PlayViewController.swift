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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBAction func addToStarSongs(_ sender: UIButton) {
        for (index, element) in StarTableViewController.starSongs.enumerated(){
            if currentSong?.downloadUrl == element.downloadUrl{
                StarTableViewController.starSongs.remove(at: index)
                //change icon
                return
            }
        }
        StarTableViewController.starSongs.insert(currentSong!, at: 0)
        StarTableViewController.saveSongs()
    }
    
    
    let player = SongPlayer()
    var currentSong:Song? = nil
   
    let playImage = #imageLiteral(resourceName: "play")
    let pauseImage = #imageLiteral(resourceName: "pause")
    

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
    }
    
    
    func updateWith(newSongToPlay song:Song){
        //force to load
        if titleLabel == nil{
            _ = self.view
        }
        if let currSong = currentSong,
            currSong.downloadUrl == song.downloadUrl,
            player.hasSongToPlay(){
            player.play()
            playControlButton.setImage(pauseImage, for: .normal)
            return
        }
        
        currentSong = song
        player.playNewSong(songUrl: song.downloadUrl+"&br=128000")
        self.navigationItem.title = song.title
        
        
        titleLabel.text = song.title
        artistLabel.text = song.artist

        Downloader.downloadImage(withUrl: song.imageUrl){img in
            self.imageView.image = img
        }
        
        playControlButton.imageView?.image = pauseImage
    }
    
    @IBAction func playControlButtonClicked(_ sender: UIButton) {
        if player.isPlaying(){
            player.pause()
            playControlButton.setImage(playImage, for: .normal)
        }else if(player.hasSongToPlay()){
            player.play()
            playControlButton.setImage(pauseImage, for: .normal)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if player.isPlaying() {
            playControlButton.setImage(pauseImage, for: .normal)
        }else{
            playControlButton.setImage(playImage, for: .normal)
        }
    }
    
    @IBAction func volumeChange(_ sender: UISlider) {
        player.setVolume(sender.value)
    }
    
}
