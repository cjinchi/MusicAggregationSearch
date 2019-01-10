//
//  Ranking.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2019/1/10.
//  Copyright © 2019 com.cjinchi. All rights reserved.
//

import Foundation

class Ranking{
    private static func getRankingFrom(songSource source:SongSource,completion:@escaping (Bool)->()){
        guard let url = source.getRankUrl()?.url else {
            DispatchQueue.main.async {
                completion(false)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url){data,response,error in
            if error != nil{
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }else if let rankData = data,
                let res = response as? HTTPURLResponse,res.statusCode == 200{
                resultsPerSource[source] = Analyzer.getSongsFromRankingResult(data: rankData, source: source)
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }.resume()
    }
    
    static var resultsPerSource = [SongSource:[Song]]()
    static var completeNum:Int = 0
    static var results = [Song]()
    
    
    static func getAllRanking(completion: @escaping ([Song]) -> ()){
        for ss in SongSource.allCases{
            resultsPerSource[ss]?.removeAll()
        }
        results.removeAll()
        completeNum = 0
        
        for ss in SongSource.allCases{
            getRankingFrom(songSource: ss){done in
            
                completeNum += 1
                if self.completeNum == SongSource.allCases.count{
                    var max = 0
                    for s in SongSource.allCases{
                        if let len = self.resultsPerSource[s]?.count,
                            len > max{
                            max = len
                        }
                    }

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
    
    
}
