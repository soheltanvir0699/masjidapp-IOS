//
//  SendPushViewController.swift
//  MasjidApp
//
//  Created by Sohel Rana on 27/12/22.
//

import UIKit

class SendPushViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UITextField!
    @IBOutlet weak var sendCountLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    @IBAction func sendAction(_ sender: Any) {
        guard let title = titleLbl.text, title != "" else {
            showToast(message: "Title Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let desStr = descriptionLbl.text, desStr != "" else {
            showToast(message: "Description Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        DispatchQueue.main.async {
            self.showLoader(controller: self)
        }
        Service.sendPush(title: title, des: desStr) { result in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            if result.success {
                self.showToast(message: result.message!, styleColor: .white, backgroundColor: .systemGreen)
                self.titleLbl.text = ""
                self.descriptionLbl.text = ""
                self.sendCountLbl.text = "\(result.data?.recipients ?? 0)"
            }else {
                self.showToast(message: result.message!, styleColor: .white, backgroundColor: .red)
            }
        } failure: { err in
            DispatchQueue.main.async {
                self.hideLoader()
            }
        }

    }

}
