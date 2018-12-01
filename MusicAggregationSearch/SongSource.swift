//
//  SongSource.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2018/11/30.
//  Copyright © 2018 com.cjinchi. All rights reserved.
//

import Foundation

enum SongSource:CaseIterable{
    case XM,QQ,WY,KG
    
    var imageName:String{
        switch self {
        case .XM:return "xm"
        case .QQ:return "qq"
        case .WY:return "wy"
        case .KG:return "kg"
        }
    }
    
}
