//
//  Downloader.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2019/1/10.
//  Copyright © 2019 com.cjinchi. All rights reserved.
//

import Foundation
import UIKit

class Downloader{
    static func downloadImage(withUrl urlString:String,completion:@escaping (UIImage)->()){
        let urlCompoments = URLComponents(string: urlString)
        guard let url = urlCompoments?.url else {
            print("error when get url")
            return
        }
        
        URLSession.shared.dataTask(with: url){data,response,err in
            if err == nil,
               let imageData = data,
                let image = UIImage(data: imageData){
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
}
