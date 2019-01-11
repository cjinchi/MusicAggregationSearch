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
        
        resultsPerSource[source] = Analyzer.getSongsFromSearchResult(data: data, source: source)
        
//        var dic : [String:Any]
//        do{
//            dic = try (JSONSerialization.jsonObject(with: data, options: []) as? [String:Any])!
//        }catch{
//            print("json error")
//            return
//        }
//
//        if let code = dic["code"] as? Int,
//            code == 200,
//            let dataArray = dic["data"] as? [Any]{
//            for songItem in dataArray{
//                if let songItem = songItem as? [String:Any],
//                    let songName = songItem["name"] as? String,
//                    let artist = songItem["singer"] as? String,
//                    let downloadUrl = songItem["url"] as? String,
//                    let imageUrl = songItem["pic"] as? String{
//                    resultsPerSource[source]?.append(Song(title: songName, artist: artist, source: source, downloadUrl: downloadUrl,imageUrl:imageUrl))
//                    print("append")
//                }
//            }
//        }else{
//            print("json error")
//            return
//        }
    }
    
    func getKGSongUrl(hash:String,completion:@escaping (String)->()){
        print("here 1")
        var urlCompoments = URLComponents(string: "http://m.kugou.com/app/i/getSongInfo.php");
        urlCompoments?.query = "cmd=playInfo&hash=\(hash)"
        guard let url = urlCompoments?.url else {
            print("error when get url")
            return
        }
        
        let dataTask = urlSession.dataTask(with: url){data,response,error in
            print("here 2")
            if let e = error{
                print(e.localizedDescription)
            }else if let d = data,let res = response as? HTTPURLResponse,res.statusCode == 200{
                print("here 3")
                
                var dic : [String:Any]
                do{
                    dic = try (JSONSerialization.jsonObject(with: d, options: []) as? [String:Any])!
                } catch{
                    print("json error")
                    return
                }
                if let mp3Url = dic["url"] as? String{
                    print("here 4")
                    DispatchQueue.main.async {
                        completion(mp3Url)
                    }
                }
                
            }
        }
        dataTask.resume()
    }
    
    func getHotSongList(completion:@escaping ([Song])->()) -> () {
        var urlCompoments = URLComponents(string: "http://m.kugou.com/rank/info/")
        urlCompoments?.query = "rankid=8888&page=1&json=true"
        guard let url = urlCompoments?.url else {
            print("error when get url")
            return
        }
        let dataTask = urlSession.dataTask(with: url){data,response,error in
            print("here 2")
            if let e = error{
                print(e.localizedDescription)
            }else if let d = data,let res = response as? HTTPURLResponse,res.statusCode == 200{
                var hotResults = [Song]()
                var dic : [String:Any]
                do{
                    dic = try (JSONSerialization.jsonObject(with: d, options: []) as? [String:Any])!
                } catch{
                    print("json error")
                    return
                }
                if let songs = dic["songs"] as? [String:Any],
                    let list = songs["list"] as? [Any]{
                    for item in list{
                        if let item = item as? [String:Any],
                            let filename = item["filename"] as? String,
                        let remark = item["remark"] as? String,
                            let hash = item["hash"] as? String{
                            hotResults.append(Song(title: filename, artist: remark, source: .KG, downloadUrl: hash,imageUrl:""))
                        }
                    }
                    DispatchQueue.main.async {
                        completion(hotResults)
                    }
                    
                }
                
            }
            
        }
        dataTask.resume()
    }
    
    func getNearbySongList(completion:@escaping ([Song],[String])->()) -> (){
        if App.coordinate == nil{
            return
        }
        var urlCompoments = URLComponents(string: "http://111.231.74.95/data")
        var que = "device=\(App.deviceId ?? "123")"
        if let coor = App.coordinate{
            que += "&latitude=\(coor.latitude)&longitude=\(coor.longitude)"
        }
        urlCompoments?.query = que
        guard let url = urlCompoments?.url else {
            print("error when get url")
            return
        }
        let dataTask = urlSession.dataTask(with: url){data,response,error in
            print("here 2")
            if let e = error{
                print(e.localizedDescription)
            }else if let d = data,let res = response as? HTTPURLResponse,res.statusCode == 200{
                print("here in near")
                var nearbyResults = [Song]()
                var nearbyInfos = [String]()
                var dic : [String:Any]
                do{
                    dic = try (JSONSerialization.jsonObject(with: d, options: []) as? [String:Any])!
                } catch{
                    print("json error")
                    return
                }
                if let res = dic["results"] as? [Any]{
                        print("here in results")
                        for item in res{
                            print("here item")
                            if let item = item as? [String:Any],
                                let title = item["title"] as? String,
                                let artist = item["artist"] as? String,
                            let info = item["info"] as? String,
                            let source = item["source"] as? Int,
                            let downloadInfo = item["download"] as? String,
                            let imageUrl = item["image"] as? String{
                                print("here append")
                                nearbyResults.append(Song(title: title, artist: artist, source: SongSource(rawValue: source)!, downloadUrl:downloadInfo,imageUrl:imageUrl))
                                nearbyInfos.append(info)
                                print("nearby")
                            }
                    }
                    DispatchQueue.main.async {
                        completion(nearbyResults,nearbyInfos)
                    }
                }
                
            }
            
        }
        dataTask.resume()
    }
    
    static func updateData(song:Song) -> (){
        var urlCompoments = URLComponents(string: "http://111.231.74.95/update")
        var que = "title=\(song.title)&artist=\(song.artist)&download=\(song.downloadUrl)&source=\(song.source.rawValue)&device=\(App.deviceId ?? "123")&image=\(song.imageUrl)"
        
        if let coor = App.coordinate{
            que += "&latitude=\(coor.latitude)&longitude=\(coor.longitude)"
        }
        
        urlCompoments?.query = que

        guard let url = urlCompoments?.url else {
            print("error when get url")
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url){data,response,error in
            
        }
        dataTask.resume()
    }
}
