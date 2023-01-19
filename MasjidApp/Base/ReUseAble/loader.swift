//
//  loader.swift
//  MasjidApp
//
//  Created by Sohel Rana on 28/10/22.
//

import Foundation
import UIKit
import SDWebImage

class loader: UIView {
    @IBOutlet weak var loaderImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loaderImg.image = SDAnimatedImage(named: "gif-image.gif")
    }
}
