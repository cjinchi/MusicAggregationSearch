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
    let downloadUrl : String
    let imageUrl : String
    
    init(title:String,artist:String,source:SongSource,downloadUrl:String,imageUrl:String) {
        
        self.title = title
        self.artist = artist
        self.source = source
        self.downloadUrl = downloadUrl
        self.imageUrl = imageUrl
    }
}
