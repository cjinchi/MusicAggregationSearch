//
//  App.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2019/1/10.
//  Copyright © 2019 com.cjinchi. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class App{
    static let playViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as! PlayViewController
    
    static let deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    static var coordinate:CLLocationCoordinate2D? = nil
}
