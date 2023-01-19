//
//  EditAndUpdateViewController.swift
//  MasjidApp
//
//  Created by Sohel Rana on 1/11/22.
//

import UIKit
import DatePickerDialog
import SDWebImage

class EditAndUpdateViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    @IBOutlet weak var nameFld: UITextField!
    
    @IBOutlet weak var countryFld: UITextField!
    @IBOutlet weak var cityFld: UITextField!
    @IBOutlet weak var stateFld: UITextField!
    @IBOutlet weak var ishaBtn: UIButton!
    @IBOutlet weak var magribBtn: UIButton!
    @IBOutlet weak var asrBtn: UIButton!
    @IBOutlet weak var dhuhrBtn: UIButton!
    @IBOutlet weak var fajrBtn: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    var masjid_id = ""
    var Mosques_Data: MosquesData?
    let dateFormatter24 = DateFormatter()
    var fajrTime = ""
    var dhuhrTime = ""
    var asrTime = ""
    var magribTime = ""
    var ishaTime = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter24.dateFormat = "HH:mm"
        DispatchQueue.main.async {
            self.updateBtn.layer.cornerRadius = 10
            self.saveBtn.layer.cornerRadius = 10
            if self.masjid_id == "" {
                self.updateBtn.isHidden = true
                self.saveBtn.isHidden = false
            
        }else {
            if self.Mosques_Data != nil {
                self.fajrTime = (self.Mosques_Data?.Fajr)!
                self.dhuhrTime = (self.Mosques_Data?.Dhuhr)!
                self.asrTime = (self.Mosques_Data?.Asr)!
//                self.magribTime = (self.Mosques_Data?.Maghrib)!
                self.ishaTime = (self.Mosques_Data?.Isha)!
                
                self.nameFld.text = self.Mosques_Data?.mosque_name
                if constant.TimeFormat == 12 {
                    self.ishaBtn.setTitle(self.dateTimeChangeFormat(str:(self.Mosques_Data?.Isha)!), for: .normal)
                    self.magribBtn.setTitle(self.dateTimeChangeFormat(str:(self.Mosques_Data?.Maghrib)!), for: .normal)
                    self.asrBtn.setTitle(self.dateTimeChangeFormat(str:(self.Mosques_Data?.Asr)!), for: .normal)
                    self.dhuhrBtn.setTitle(self.dateTimeChangeFormat(str:(self.Mosques_Data?.Dhuhr)!), for: .normal)
                    self.fajrBtn.setTitle(self.dateTimeChangeFormat(str:(self.Mosques_Data?.Fajr)!), for: .normal)
                }else {
                    self.ishaBtn.setTitle(self.Mosques_Data?.Isha, for: .normal)
                self.magribBtn.setTitle(self.Mosques_Data?.Maghrib, for: .normal)
                self.asrBtn.setTitle(self.Mosques_Data?.Asr, for: .normal)
                self.dhuhrBtn.setTitle(self.Mosques_Data?.Dhuhr, for: .normal)
                self.fajrBtn.setTitle(self.Mosques_Data?.Fajr, for: .normal)
                }
                self.countryFld.text = self.Mosques_Data?.country
                self.cityFld.text = self.Mosques_Data?.city
                self.stateFld.text = self.Mosques_Data?.state
                if self.Mosques_Data?.mosque_icon != nil {
                    self.profileImg.sd_setImage(with: URL(string: (self.Mosques_Data?.mosque_icon)!))
                }
            }
            self.saveBtn.isHidden = true
            self.updateBtn.isHidden = false
        }
            self.profileImg.layer.cornerRadius = self.profileImg.frame.height / 2
            self.profileImg.layer.borderWidth = 1
            self.profileImg.layer.borderColor = UIColor.gray.cgColor
            self.navigationController?.navigationBar.tintColor = .systemBlue
            self.pickerAction.isUserInteractionEnabled = true
        }
        pickerAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickimage)))
        // Do any additional setup after loading the view.
    }
    
    func dateTimeChangeFormat(str stringWithDate: String) -> String {
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = "HH:mm:ss"

        let outFormatter = DateFormatter()
        outFormatter.locale = Locale(identifier: "en_US_POSIX")
        outFormatter.dateFormat = "hh:mm a"

        let inStr = stringWithDate
        let date = inFormatter.date(from: inStr)!
        return outFormatter.string(from: date)
    }
    
    @objc func pickimage()  {
       let imagecontroller = UIImagePickerController()
        imagecontroller.delegate = self
        imagecontroller.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagecontroller, animated: true, completion: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            self.profileImg.image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fajrAction(_ sender: Any) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) { date in
            if let dt = date {
                print(dt)
                let dateFormatter = DateFormatter()
                if constant.TimeFormat == 12 {
                    dateFormatter.dateFormat = "hh:mm a"
                    DispatchQueue.main.async {
                       
                    self.fajrBtn.setTitle(dateFormatter.string(from: dt), for: .normal)
                        self.fajrTime = self.dateFormatter24.string(from: dt)+":00"
                    }
                }else {
                dateFormatter.dateFormat = "HH:mm"
                
                DispatchQueue.main.async {
                   
                self.fajrBtn.setTitle(dateFormatter.string(from: dt)+":00", for: .normal)
                    self.fajrTime = (self.fajrBtn.titleLabel?.text)!
                }
                }
            }
        }
    }
    
    @IBAction func dhuhrAction(_ sender: Any) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) { date in
            if let dt = date {
                print(dt)
                self.dhuhrTime = self.dateFormatter24.string(from: dt)+":00"
                let dateFormatter = DateFormatter()
                if constant.TimeFormat == 12 {
                    dateFormatter.dateFormat = "hh:mm a"
                    self.dhuhrBtn.setTitle(dateFormatter.string(from: dt), for: .normal)
                }else {
                dateFormatter.dateFormat = "HH:mm"
                
                DispatchQueue.main.async {
                self.dhuhrBtn.setTitle(dateFormatter.string(from: dt)+":00", for: .normal)
                }
                }
            }
        }
    }
    @IBAction func asrAction(_ sender: Any) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) { date in
            if let dt = date {
                print(dt)
                self.asrTime = self.dateFormatter24.string(from: dt)+":00"
                let dateFormatter = DateFormatter()
                if constant.TimeFormat == 12 {
                    dateFormatter.dateFormat = "hh:mm a"
                    self.asrBtn.setTitle(dateFormatter.string(from: dt), for: .normal)
                }else {
                dateFormatter.dateFormat = "HH:mm"
                
                DispatchQueue.main.async {
                self.asrBtn.setTitle(dateFormatter.string(from: dt)+":00", for: .normal)
                }
                }
            }
        }
    }
    @IBAction func magribAction(_ sender: Any) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) { date in
            if let dt = date {
                print(dt)
                self.magribTime = self.dateFormatter24.string(from: dt)+":00"
                let dateFormatter = DateFormatter()
                if constant.TimeFormat == 12 {
                    dateFormatter.dateFormat = "hh:mm a"
                    self.magribBtn.setTitle(dateFormatter.string(from: dt), for: .normal)
                }else {
                dateFormatter.dateFormat = "HH:mm"
                
                DispatchQueue.main.async {
                self.magribBtn.setTitle(dateFormatter.string(from: dt)+":00", for: .normal)
                }
                }
            }
        }
    }
    @IBAction func ishaAction(_ sender: Any) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) { date in
            if let dt = date {
                print(dt)
                self.ishaTime = self.dateFormatter24.string(from: dt)+":00"
                let dateFormatter = DateFormatter()
                if constant.TimeFormat == 12 {
                    dateFormatter.dateFormat = "hh:mm a"
                    DispatchQueue.main.async {
                    self.ishaBtn.setTitle(dateFormatter.string(from: dt), for: .normal)
                    }
                }else {
                dateFormatter.dateFormat = "HH:mm"
                
                DispatchQueue.main.async {
                self.ishaBtn.setTitle(dateFormatter.string(from: dt)+":00", for: .normal)
                }
                }
            }
        }
    }
    @IBAction func saveAction(_ sender: UIButton) {
        guard let masjid_name = nameFld.text, masjid_name != "" else {
            showToast(message: "Name Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let state = stateFld.text, state != "" else {
            showToast(message: "State Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let city = cityFld.text, city != "" else {
            showToast(message: "City Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let country = countryFld.text, country != "" else {
            showToast(message: "Country Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let dhuhrTxt = dhuhrBtn.titleLabel?.text, dhuhrTxt != "00:00:00" else {
            showToast(message: "Dhuhr Time Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let fajrTxt = fajrBtn.titleLabel?.text, fajrTxt != "00:00:00" else {
            showToast(message: "Fjar Time Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        
        guard let asrTxt = asrBtn.titleLabel?.text, asrTxt != "00:00:00" else {
            showToast(message: "Asr Time Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let magribTxt = magribBtn.titleLabel?.text, magribTxt != "00:00:00" else {
            showToast(message: "Maghrib Time Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let ishaTxt = ishaBtn.titleLabel?.text, ishaTxt != "00:00:00" else {
            showToast(message: "Isha Time Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        DispatchQueue.main.async {
            self.showLoader(controller: self)
        }
        if magribTxt == "Sunset" {
        Service.getDayINfo(city: city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!, country: country.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) { results in
            self.magribTime = (results.data?.timings?.Sunset)! + ":00"
            Service.CreateAndUpdateMasjid(id: "0",state:state,city:city,country:country, url: "api/salat_times/",mosque_name: masjid_name, mosque_icon: self.profileImg.image!, Fajr: self.fajrTime, Dhuhr: self.dhuhrTime, Asr: self.asrTime, Maghrib: self.magribTime, Isha: self.ishaTime) { result in
                DispatchQueue.main.async {
                    self.hideLoader()
                }
                if result.success {
                    self.showToast(message: result.message, styleColor: .white, backgroundColor: .systemGreen)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else {
                    self.showToast(message: result.message, styleColor: .white, backgroundColor: .red)
                }
            } failure: { err in
                DispatchQueue.main.async {
                    self.hideLoader()
                }
                self.showToast(message: err, styleColor: .white, backgroundColor: .red)
            }
        } failure: { _ in
            self.showToast(message: "Please Try Again.", styleColor: .white, backgroundColor: .red)
            DispatchQueue.main.async {
                self.hideLoader()
            }
        }
        }else {
            Service.CreateAndUpdateMasjid(id: "0",state:state,city:city,country:country, url: "api/salat_times/",mosque_name: masjid_name, mosque_icon: self.profileImg.image!, Fajr: self.fajrTime, Dhuhr: self.dhuhrTime, Asr: self.asrTime, Maghrib: self.magribTime, Isha: self.ishaTime) { result in
                DispatchQueue.main.async {
                    self.hideLoader()
                }
                if result.success {
                    self.showToast(message: result.message, styleColor: .white, backgroundColor: .systemGreen)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else {
                    self.showToast(message: result.message, styleColor: .white, backgroundColor: .red)
                }
            } failure: { err in
                DispatchQueue.main.async {
                    self.hideLoader()
                }
                self.showToast(message: err, styleColor: .white, backgroundColor: .red)
            }
        }
        

        
        

    }
    
    @IBAction func updateAction(_ sender: UIButton) {
        guard let masjid_name = nameFld.text, masjid_name != "" else {
            showToast(message: "Name Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let state = stateFld.text, state != "" else {
            showToast(message: "State Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let city = cityFld.text, city != "" else {
            showToast(message: "City Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let country = countryFld.text, country != "" else {
            showToast(message: "Country Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let dhuhrTxt = dhuhrBtn.titleLabel?.text, dhuhrTxt != "00:00:00" else {
            showToast(message: "Dhuhr Time Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let fajrTxt = fajrBtn.titleLabel?.text, fajrTxt != "00:00:00" else {
            showToast(message: "Fjar Time Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let asrTxt = asrBtn.titleLabel?.text, asrTxt != "00:00:00" else {
            showToast(message: "Asr Time Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let magribTxt = magribBtn.titleLabel?.text, magribTxt != "00:00:00" else {
            showToast(message: "Maghrib Time Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        guard let ishaTxt = ishaBtn.titleLabel?.text, ishaTxt != "00:00:00" else {
            showToast(message: "Isha Time Not Found.", styleColor: .white, backgroundColor: .red)
            return
        }
        
        DispatchQueue.main.async {
            self.showLoader(controller: self)
        }
        if magribTxt == "Sunset" {
        Service.getDayINfo(city: city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!, country: country.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) { results in
            self.magribTime = (results.data?.timings?.Sunset)!
            print(results)
            Service.CreateAndUpdateMasjid(id: self.masjid_id,state:state, city:city,country:country, url: "api/update-masjid/",mosque_name: masjid_name, mosque_icon: self.profileImg.image!, Fajr: self.fajrTime, Dhuhr: self.dhuhrTime, Asr: self.asrTime, Maghrib: self.magribTime, Isha: self.ishaTime) { result in
                DispatchQueue.main.async {
                    self.hideLoader()
                }
                if result.success {
                    self.showToast(message: result.message, styleColor: .white, backgroundColor: .systemGreen)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else {
                    self.showToast(message: result.message, styleColor: .white, backgroundColor: .red)
                }
            } failure: { err in
                DispatchQueue.main.async {
                    self.hideLoader()
                }
                self.showToast(message: err, styleColor: .white, backgroundColor: .red)
            }
        } failure: { _ in
            self.showToast(message: "Please Try Again.", styleColor: .white, backgroundColor: .red)
            DispatchQueue.main.async {
                self.hideLoader()
            }
        }
        }else {
        Service.CreateAndUpdateMasjid(id: masjid_id,state:state, city:city,country:country, url: "api/update-masjid/",mosque_name: masjid_name, mosque_icon: profileImg.image!, Fajr: fajrTime, Dhuhr: dhuhrTime, Asr: asrTime, Maghrib: magribTime, Isha: ishaTime) { result in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            if result.success {
                self.showToast(message: result.message, styleColor: .white, backgroundColor: .systemGreen)
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else {
                self.showToast(message: result.message, styleColor: .white, backgroundColor: .red)
            }
        } failure: { err in
            DispatchQueue.main.async {
                self.hideLoader()
            }
            self.showToast(message: err, styleColor: .white, backgroundColor: .red)
        }
        }
    }
    @IBOutlet weak var pickerAction: UIImageView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
