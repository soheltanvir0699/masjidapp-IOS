//
//  FavCell.swift
//  MasjidApp
//
//  Created by Sohel Rana on 3/11/22.
//

import UIKit

class FavCell: UITableViewCell {
        @IBOutlet weak var imgView: UIImageView!
        
    @IBOutlet weak var add_fav_default: UIButton!
    @IBOutlet weak var add_rm_fav_btn: UIButton!
        @IBOutlet weak var bottomView: UIView!
        @IBOutlet weak var nameLbl: UILabel!
        override func awakeFromNib() {
            super.awakeFromNib()
            imgView.layer.cornerRadius = 10
            bottomView.layer.cornerRadius = 10
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    }
