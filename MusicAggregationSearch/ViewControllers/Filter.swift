//
//  Filter.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2019/1/11.
//  Copyright © 2019 com.cjinchi. All rights reserved.
//

import Foundation
class Filter{
    static func dumplicateFilter(rawData:[Song])->[Song]{
        var keys = Set<String>()
        var result = [Song]()
        for song in rawData{
            if keys.contains(song.title+song.artist){
                continue
            }else{
                result.append(song)
                keys.insert(song.title+song.artist)
            }
        }
        return result
    }
}
