//
//  Analyzer.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2019/1/10.
//  Copyright © 2019 com.cjinchi. All rights reserved.
//

import Foundation

class Analyzer {
    static func getSongsFromSearchResult(data:Data,source:SongSource) -> [Song]{
        var results:[Song] = [Song]()
        
        var dic : [String:Any]
        do{
            dic = try (JSONSerialization.jsonObject(with: data, options: []) as? [String:Any])!
        }catch{
            print("json error")
            return results
        }
        
        print("789")
        if let code = dic["code"] as? Int,
            code == 200,
            let dataArray = dic["data"] as? [Any]{
            for songItem in dataArray{
                if let songItem = songItem as? [String:Any],
                    let songName = songItem["name"] as? String,
                    let artist = songItem["singer"] as? String,
                    let downloadUrl = songItem["url"] as? String,
                    let imageUrl = songItem["pic"] as? String{
                    results.append(Song(title: songName, artist: artist, source: source, downloadUrl: downloadUrl,imageUrl:imageUrl))
                    print("append")
                }
            }
        }else{
            print("json error")
            return results
        }
        return results
    }
    
    static func getSongsFromRankingResult(data:Data,source:SongSource)-> [Song]{
        var results:[Song] = [Song]()
        
        var dic : [String:Any]
        do{
            dic = try (JSONSerialization.jsonObject(with: data, options: []) as? [String:Any])!
        }catch{
            return results
        }
        
        if let code = dic["code"] as? Int,
            code == 200,
        let dataObj = dic["data"] as? [String:Any],
        let songArray = dataObj["songs"] as? [Any]{
            for songItem in songArray{
                if let songItem = songItem as? [String:Any],
                    let songName = songItem["name"] as? String,
                    let artist = songItem["singer"] as? String,
                    let downloadUrl = songItem["url"] as? String,
                    let imageUrl = songItem["pic"] as? String{
                    results.append(Song(title: songName, artist: artist, source: source, downloadUrl: downloadUrl,imageUrl:imageUrl))
                }
            }
        }else{
            return results
        }
        return results
    }
    
    static func getRecognitionResult(data:String?)->String?{
        if data == nil{
            return nil
        }
        
        var dic : [String:Any]
        do{
            let d = data?.data(using: String.Encoding.utf8)
            dic = try (JSONSerialization.jsonObject(with: d!, options: []) as? [String:Any])!
        }catch{
            return nil
        }
        
        if let metadata = dic["metadata"] as? [String:Any],
            let music = metadata["music"] as? [Any],
            let music0 = music[0] as? [String:Any],
            let resultTitle = music0["title"]{
            return resultTitle as? String
        }
        
        return ""
    }
}
