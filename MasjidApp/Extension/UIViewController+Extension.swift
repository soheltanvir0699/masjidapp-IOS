//
//  UIViewController+Extension.swift
//  MasjidApp
//
//  Created by Sohel Rana on 20/10/22.
//

import Foundation
import UIKit
import Toast_Swift

extension UIViewController {
    func showToast(message : String, styleColor: UIColor, backgroundColor: UIColor? = nil) {
        DispatchQueue.main.async {
            var style = ToastStyle()
            // this is just one of many style options
            style.messageColor = styleColor
            if backgroundColor != nil {
                style.backgroundColor = backgroundColor!
            }
            self.view.makeToast(message, duration: 3.0, position: .bottom, style: style)
        }
    }
    func showLoader(controller: UIViewController) {
        let rootViewAds = Bundle.main.loadNibNamed("loader", owner: controller, options: nil)?[0] as? loader
        if let aView = rootViewAds {
            aView.tag = 102
            self.navigationController?.view.addSubview(aView)
            guard let navView = self.navigationController?.view else {return}
            navView.addSubview(aView)
            aView.translatesAutoresizingMaskIntoConstraints = false
            aView.topAnchor.constraint(equalTo: navView.topAnchor, constant: 0).isActive = true
            aView.bottomAnchor.constraint(equalTo: navView.bottomAnchor, constant: 0).isActive = true
            aView.leadingAnchor.constraint(equalTo: navView.leadingAnchor, constant: 0).isActive = true
            aView.trailingAnchor.constraint(equalTo: navView.trailingAnchor, constant: 0).isActive = true
        }
    }
    func hideLoader() {
        if self.navigationController?.view.subviews != nil {
        for subview in (self.navigationController?.view.subviews)! {
            if (subview.tag == 102) {
                subview.removeFromSuperview()

            }
        }
        }
    }
    func imageurl(imageString:String,success: @escaping (UIImage) -> () ) {
        let session = URLSession(configuration: .default)

        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let catPictureURL = URL(string: imageString)!
        if let imageData = try? Data(contentsOf: catPictureURL) {
                        if let loadedImage = UIImage(data: imageData) {
//                            let image2 = self.resizeImage(image: loadedImage, targetSize: CGSize(width: 20.0, height: 20.0))
                            success(loadedImage)
                        }
                    }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

       let scale = newWidth / image.size.width
       let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()

        return newImage!
   }
    
}

