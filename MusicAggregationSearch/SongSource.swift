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
//        case .XM:return "xm"
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
            var ret = URLComponents(string: "http://mobilecdn.kugou.com/api/v3/search/song")
            ret?.query = "format=json&keyword=\(keyword)&page=1&pagesize=15&showtype=1"
            return ret
        }
    }
    
}
