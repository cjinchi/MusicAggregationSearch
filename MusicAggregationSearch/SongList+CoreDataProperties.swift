//
//  SongList+CoreDataProperties.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2019/1/11.
//  Copyright © 2019 com.cjinchi. All rights reserved.
//
//

import Foundation
import CoreData


extension SongList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SongList> {
        return NSFetchRequest<SongList>(entityName: "SongList")
    }

    @NSManaged public var title: String?
    @NSManaged public var artist: String?
    @NSManaged public var downloadUrl: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var songSource: Int32

}
