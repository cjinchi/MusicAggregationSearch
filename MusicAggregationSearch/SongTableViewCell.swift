//
//  SongTableViewCell.swift
//  MusicAggregationSearch
//
//  Created by 陈金池 on 2018/11/30.
//  Copyright © 2018 com.cjinchi. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songMoreInfoLabel: UILabel!
    @IBOutlet weak var songSourceImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setCellInfo(songTitle:String,songMoreInfo:String,songSourceImage:UIImage){
        self.songTitleLabel.text = songTitle
        self.songMoreInfoLabel.text = songMoreInfo
        self.songSourceImageView.image = songSourceImage
    }

}
