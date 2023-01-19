//
//  NextSchCell.swift
//  MasjidApp
//
//  Created by Sohel Rana on 15/12/22.
//

import UIKit

class NextSchCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var expiredLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var add_rm_fav_btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bottomView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
