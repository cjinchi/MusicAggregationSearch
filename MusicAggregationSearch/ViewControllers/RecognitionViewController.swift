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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = ACRCloudConfig()
        config.accessKey = "b836613c8384b46f18f6de6938f68e01"
        config.accessSecret = "yWji5tCxDfB5w5qY2ax8qFcxM8CJBEMyOkM7G1cU"
        config.host = "identify-us-west-2.acrcloud.com"
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
            print("result block ",result!)
        }
        
        self.client = ACRCloudRecognition(config: config)

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
            return
        }
        
        client?.startRecordRec()
        started = true
    }
    
    @IBAction func stopButtonClicked(_ sender: UIButton) {
        client?.stopRecordRec()
        started = false
    }
    
    

}
