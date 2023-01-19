//
//  MasjidDetailsViewController.swift
//  MasjidApp
//
//  Created by Sohel Rana on 5/11/22.
//

import UIKit
import SDWebImage
import MarqueeLabel

class MasjidDetailsViewController: UIViewController {

    @IBOutlet weak var namLbl: MarqueeLabel!
    
    @IBOutlet weak var ishaBtn: UIButton!
    @IBOutlet weak var magribBtn: UIButton!
    @IBOutlet weak var asrBtn: UIButton!
    @IBOutlet weak var dhuhrBtn: UIButton!
    @IBOutlet weak var fajrBtn: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    var data: MosquesData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .systemBlue
        DispatchQueue.main.async {
            self.profileImg.layer.cornerRadius = self.profileImg.frame.height / 2
            self.profileImg.layer.borderWidth = 1
            self.profileImg.layer.borderColor = UIColor.gray.cgColor
            if self.data?.mosque_icon != nil {
                self.profileImg.sd_setImage(with: URL(string: (self.data?.mosque_icon)!))
            }
            
            self.namLbl.text = self.data?.mosque_name
            if constant.TimeFormat == 12 {
            self.ishaBtn.setTitle(self.dateTimeChangeFormat(str: self.data!.Isha!,
                                                  inDateFormat:  "HH:mm:ss",
                                                  outDateFormat: "hh:mm a"), for: .normal)
            self.magribBtn.setTitle(self.dateTimeChangeFormat(str: self.data!.Maghrib!,
                                                    inDateFormat:  "HH:mm:ss",
                                                    outDateFormat: "hh:mm a"), for: .normal)
            self.asrBtn.setTitle(self.dateTimeChangeFormat(str: self.data!.Asr!,
                                                 inDateFormat:  "HH:mm:ss",
                                                 outDateFormat: "hh:mm a"), for: .normal)
            self.dhuhrBtn.setTitle(self.dateTimeChangeFormat(str: self.data!.Dhuhr!,
                                                   inDateFormat:  "HH:mm:ss",
                                                   outDateFormat: "hh:mm a"), for: .normal)
            self.fajrBtn.setTitle(self.dateTimeChangeFormat(str: self.data!.Fajr!,
                                                  inDateFormat:  "HH:mm:ss",
                                                  outDateFormat: "hh:mm a"), for: .normal)
            }else {
                self.ishaBtn.setTitle(self.data!.Isha!, for: .normal)
                self.magribBtn.setTitle(self.data!.Maghrib!, for: .normal)
                self.asrBtn.setTitle(self.data!.Asr!, for: .normal)
                self.dhuhrBtn.setTitle( self.data!.Dhuhr!, for: .normal)
                self.fajrBtn.setTitle(self.data!.Fajr!, for: .normal)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    func dateTimeChangeFormat(str stringWithDate: String, inDateFormat: String, outDateFormat: String) -> String {
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = inDateFormat

        let outFormatter = DateFormatter()
        outFormatter.locale = Locale(identifier: "en_US_POSIX")
        outFormatter.dateFormat = outDateFormat

        let inStr = stringWithDate
        let date = inFormatter.date(from: inStr)!
        return outFormatter.string(from: date)
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
    }
    

}
