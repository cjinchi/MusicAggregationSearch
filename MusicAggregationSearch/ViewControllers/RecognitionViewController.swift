//
//  RecognitionViewController.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2019/1/10.
//  Copyright © 2019 com.cjinchi. All rights reserved.
//

import UIKit

class RecognitionViewController: UIViewController {
    
    var client : ACRCloudRecognition?
    var started = false
    
    @IBOutlet weak var playControlButton: UIButton!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var toPlayButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toPlayButton.layer.cornerRadius = 10
        toPlayButton.isHidden = true
        
        let config = ACRCloudConfig()
        config.accessKey = "0e956b350321c91ab68f949acf8ea651"
        config.accessSecret = "infsj7LHfdLGfgqvccwe8OAaAL71GQdRI6VvYqlz"
        config.host = "identify-cn-north-1.acrcloud.com"
        config.recMode = rec_mode_remote
        config.requestTimeout = 10
        config.protocol = "https"
        
        config.stateBlock={state in
            print("state block ",state!)
        }
        
        config.volumeBlock = {volume in
            print("volume block ",volume)
        }
        
        config.resultBlock = {result, resType in
            DispatchQueue.main.async {
                if let resultStr = Analyzer.getRecognitionResult(data: result){
                    self.client?.stopRecordRec()
                    self.started = false
                    self.resultLabel.text = resultStr
                    self.toPlayButton.isHidden = false
                }
                
            }
        }
        
        self.client = ACRCloudRecognition(config: config)
        
        resultLabel.text = ""

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func controlButtonClicked(_ sender: UIButton) {
        if started{
            client?.stopRecordRec()
            started = false
            resultLabel.text = "很遗憾，没有找到相关歌曲。"
            playControlButton.setTitle("点击开始", for: .normal)
        }else{
            client?.startRecordRec()
            started = true
            resultLabel.text = "正在聆听..."
            playControlButton.setTitle("点击停止", for: .normal)
        }
        
        toPlayButton.isHidden = true
        
    }
    
    @IBAction func showDetail(_ sender: UIBarButtonItem) {
    self.navigationController?.pushViewController(App.playViewController, animated: true)
 
    }
    
    
    @IBAction func toPlay(_ sender: UIButton) {
        print("in to play")
        if let stvc = SearchTableViewController.stvc{
            stvc.searchRecognitionSong(title: resultLabel.text!)
            self.navigationController?.pushViewController(stvc, animated: true)
        }
        
    }
    
    
    
    

}
