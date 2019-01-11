//
//  MainViewController.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2019/1/11.
//  Copyright © 2019 com.cjinchi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var listen: UIButton!
    
    @IBOutlet weak var near: UIButton!
    
    @IBOutlet weak var rank: UIButton!
    
    @IBOutlet weak var favorite: UIButton!
    
    @IBAction func showDetail(_ sender: UIBarButtonItem) {
   self.navigationController?.pushViewController(App.playViewController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listen.layer.cornerRadius = 10
        near.layer.cornerRadius = 10
        rank.layer.cornerRadius = 10
        favorite.layer.cornerRadius = 10
        
        listen.layer.masksToBounds = true
        near.layer.masksToBounds = true
        rank.layer.masksToBounds = true
        favorite.layer.masksToBounds = true
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

}
