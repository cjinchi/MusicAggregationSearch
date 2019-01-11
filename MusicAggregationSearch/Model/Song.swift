//
//  Song.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2018/11/30.
//  Copyright © 2018 com.cjinchi. All rights reserved.
//

import Foundation
import os.log

class Song:NSObject, NSCoding{
    func encode(with aCoder: NSCoder) {
        print("in encode",title)
//        aCoder.encode(title, forKey: PropertyKey.title)
//        aCoder.encode(artist, forKey: PropertyKey.artist)
//        aCoder.encode(source, forKey: PropertyKey.source)
//        aCoder.encode(downloadUrl, forKey: PropertyKey.downloadUrl)
//        aCoder.encode(imageUrl, forKey: PropertyKey.imageUrl)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title1 = aDecoder.decodeObject(forKey: PropertyKey.title) as? String,
        let artist1 = aDecoder.decodeObject(forKey: PropertyKey.artist) as? String,
        let downloadUrl1 = aDecoder.decodeObject(forKey: PropertyKey.downloadUrl) as? String,
        let imageUrl1 = aDecoder.decodeObject(forKey: PropertyKey.imageUrl) as? String,
        let source1 = aDecoder.decodeObject(forKey: PropertyKey.source) as? SongSource
            else{
                return nil
        }
        self.init(title: title1, artist: artist1, source: source1, downloadUrl: downloadUrl1, imageUrl: imageUrl1)
    }
    
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
    
    struct PropertyKey{
        static let title = "title"
        static let artist = "artist"
        static let source = "source"
        static let downloadUrl = "downloadUrl"
        static let imageUrl = "imageUrl"
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("songlist")
}



