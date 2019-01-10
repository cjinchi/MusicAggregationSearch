//
//  SongSource.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2018/11/30.
//  Copyright © 2018 com.cjinchi. All rights reserved.
//

import Foundation

enum SongSource:Int,CaseIterable{
    case QQ = 0,WY,KG
    
    var imageName:String{
        switch self {
        case .QQ:return "qq"
        case .WY:return "wy"
        case .KG:return "kg"
        }
    }
    
    func getURL(keyword:String) -> URLComponents?{
        switch self {
        case .QQ:
            var ret = URLComponents(string: "https://api.bzqll.com/music/tencent/search")
            ret?.query = "key=579621905&s=\(keyword)&limit=15&offset=0&type=song"
            return ret
        case .WY:
            var ret = URLComponents(string: "https://api.bzqll.com/music/netease/search")
            ret?.query = "key=579621905&s=\(keyword)&type=song&limit=15&offset=0"
            return ret
        case .KG:
            var ret = URLComponents(string: "https://api.bzqll.com/music/kugou/search")
            ret?.query = "key=579621905&s=\(keyword)&type=song&limit=15&offset=0"
            return ret
        }
    }
    
    func getAPIKeyword() -> String{
        switch self {
        case .QQ:return "tencent";
        case .WY:return "netease";
        case .KG:return "kugou";
        }
    }
    
    func getRankUrl()->URLComponents?{
        switch self {
        case .WY:
            let ret = URLComponents(string: "https://api.bzqll.com/music/netease/songList?key=579621905&id=3778678");
            return ret
        case .QQ:
            let ret = URLComponents(string: "https://api.bzqll.com/music/tencent/songList?key=579621905&id=6357173018")
            return ret
        case .KG:
            let ret = URLComponents(string: "https://api.bzqll.com/music/kugou/songList?key=579621905&id=279295")
            return ret
            
        }
    }
    
}
