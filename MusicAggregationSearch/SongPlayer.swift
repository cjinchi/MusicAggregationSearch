//
//  SongPlayer.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2019/1/9.
//  Copyright © 2019 com.cjinchi. All rights reserved.
//

import Foundation
import AVKit

class SongPlayer{
    let player = AVQueuePlayer()
    var playing:Bool = false

    
    func playNewSong(songUrl urlStr:String){
        pause()
        player.removeAllItems()
        let url = NSURL(string: urlStr)!
        let item = AVPlayerItem(url: url as URL)
        player.insert(item, after: nil)
        play()
    }
    
    func play(){
        player.play()
        playing = true
    }
    
    func pause(){
        player.pause()
        playing = false
    }
    
    func isPlaying()->Bool{
        return playing
    }
    
    func hasSongToPlay()->Bool{
        return player.items().count == 0
    }
}
