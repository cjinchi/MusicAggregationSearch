//
//  Song.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2018/11/30.
//  Copyright © 2018 com.cjinchi. All rights reserved.
//

import Foundation

class Song{
    let title : String
    let artist : String
    let source : SongSource
    
    init(title:String,artist:String,source:SongSource) {
        
        self.title = title
        self.artist = artist
        self.source = source
    }
}
