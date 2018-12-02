//
//  Query.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2018/12/1.
//  Copyright © 2018 com.cjinchi. All rights reserved.
//

import Foundation

class Query{
    let urlSession = URLSession(configuration: .default)
    var dataTasks = [SongSource:URLSessionDataTask?]()
    var resultsPerSource = [SongSource:[Song]]()
    var results = [Song]()
    var completeNum = 0
    
    init() {
        for ss in SongSource.allCases{
            resultsPerSource[ss] = [Song]()
        }
    }
    
    func getResultsFromAllSource(keyword:String,completion: @escaping ([Song]) -> ()){
        for ss in SongSource.allCases{
            resultsPerSource[ss]?.removeAll()
        }
        results.removeAll()
        completeNum = 0
        
        for ss in SongSource.allCases{
            getResultsFromOneSource(keyword: keyword, source: ss){successful in
                print(ss)
                print(successful)
                
                self.completeNum += 1
                if self.completeNum == SongSource.allCases.count{
                    var max = 0
                    for s in SongSource.allCases{
                        if let len = self.resultsPerSource[s]?.count,
                            len > max{
                            max = len
                        }
                    }
                    
                    print("max ",max)
                    
                    for i in 0..<max{
                        for s1 in SongSource.allCases{
                            if let count = self.resultsPerSource[s1]?.count,
                                count >= i+1{
                                self.results.append(self.resultsPerSource[s1]![i])
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(self.results)
                    }
                }
                
            }
        }
        
    }
    
    func getResultsFromOneSource(keyword:String,source:SongSource,completion: @escaping (Bool) -> ()){
        dataTasks[source]??.cancel()
        var successful = false;
        
        guard let url = source.getURL(keyword: keyword)?.url else {
            print("error when get url")
            return
            
        }
        
        dataTasks[source] = urlSession.dataTask(with: url){data,response,error in
            defer {
                self.dataTasks[source] = nil
            }
            if let e = error{
                print(e.localizedDescription)
                successful = false;
            }else if let d = data,let res = response as? HTTPURLResponse,res.statusCode == 200{
//                print(String(decoding: d, as: UTF8.self))
                self.updateData(source: source, data: d)
                successful = true
            }
            DispatchQueue.main.async {
                completion(successful)
            }
        }

        self.dataTasks[source]??.resume()
    }
    
    func updateData(source:SongSource,data:Data) -> () {
        print("to update",source)
        switch source {
        case .KG:
            var dic : [String:Any]
            do{
                dic = try (JSONSerialization.jsonObject(with: data, options: []) as? [String:Any])!
            } catch{
                print("json error")
                return
            }
            
            if let errcode = dic["errcode"] as? Int,
                errcode == 0,
                let dataArray = dic["data"] as? [String:Any],
                let infoArray = dataArray["info"] as? [Any]{
                for songItem in infoArray{
                    if let songItem = songItem as? [String:Any],
                    let songName = songItem["songname"] as? String,
                    let artist = songItem["singername"] as? String,
                        let downloadInfo = songItem["hash"] as? String{
                        resultsPerSource[source]?.append(Song(title: songName, artist: artist, source: source, downloadInfo: downloadInfo))
                        print("append")
                    }
                }
            }else{
                print("json error")
                return
            }
            break
        case .WY,.QQ:
            var dic : [String:Any]
            do{
                dic = try (JSONSerialization.jsonObject(with: data, options: []) as? [String:Any])!
            }catch{
                print("json error")
                return
            }
            
            if let code = dic["code"] as? Int,
                code == 200,
                let dataArray = dic["data"] as? [Any]{
                for songItem in dataArray{
                    if let songItem = songItem as? [String:Any],
                    let songName = songItem["name"] as? String,
                    let artist = songItem["singer"] as? String,
                        let downloadInfo = songItem["url"] as? String{
                        resultsPerSource[source]?.append(Song(title: songName, artist: artist, source: source, downloadInfo: downloadInfo))
                        print("append")
                    }
                }
            }else{
                print("json error")
                return
            }
            break
        }
    }
}
