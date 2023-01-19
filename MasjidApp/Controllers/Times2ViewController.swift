//
//  Times2ViewController.swift
//  MasjidApp
//
//  Created by Sohel Rana on 7/11/22.
//

import UIKit
import SideMenu
import CoreLocation

class Times2ViewController: UIViewController, MenuControllerDelegate ,CLLocationManagerDelegate{
    @IBOutlet weak var fajrLbl: UILabel!
    
    @IBOutlet weak var ishaLbl: UILabel!
    @IBOutlet weak var maghribLbl: UILabel!
    @IBOutlet weak var duhrLbl: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var asrLbl: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    private var sideMenu: SideMenuNavigationController?
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFor = DateFormatter()

        let hijriCalendar = Calendar.init(identifier: Calendar.Identifier.islamicCivil)
        //use "lang" key from Localized to display date in accordance with system language
        dateFor.locale = Locale.init(identifier: "lang".localized)

        dateFor.calendar = hijriCalendar

        dateFor.dateFormat = "EEEE, MMM d, yyyy"
        currentDateLabel.text = "\(dateFor.string(from: Date())) \("AH".localized)"
        // Do any additional setup after loading the view.
        setUpMenu()
        determineMyCurrentLocation()
        if constant.fav_data != nil {
            if constant.TimeFormat == 12 {
                fajrLbl.text = dateTimeChangeFormat(str: (constant.fav_data?.salat_Id[0].Fajr)!)
                ishaLbl.text = dateTimeChangeFormat(str: (constant.fav_data?.salat_Id[0].Isha)!)
                maghribLbl.text = dateTimeChangeFormat(str: (constant.fav_data?.salat_Id[0].Maghrib)!)
                duhrLbl.text = dateTimeChangeFormat(str: (constant.fav_data?.salat_Id[0].Dhuhr)!)
                asrLbl.text = dateTimeChangeFormat(str: (constant.fav_data?.salat_Id[0].Asr)!)
            }else {
                fajrLbl.text = constant.fav_data?.salat_Id[0].Fajr
                ishaLbl.text = constant.fav_data?.salat_Id[0].Isha
                maghribLbl.text = constant.fav_data?.salat_Id[0].Maghrib
                duhrLbl.text = constant.fav_data?.salat_Id[0].Dhuhr
                asrLbl.text = constant.fav_data?.salat_Id[0].Asr
            }
            
        }
    }
    
    @IBAction func menuAction(_ sender: Any) {
        print("working")
        present(sideMenu!, animated: true)
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
    
    @IBAction func masjidListAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func setUpMenu() {
        
        
        DispatchQueue.main.async {
            let menu = MenuController(style: UITableView.Style.grouped)
            _ = menu.index
            menu.delegate = self
            self.sideMenu = SideMenuNavigationController(rootViewController: menu)
            self.sideMenu?.leftSide = true
            
            SideMenuManager.default.leftMenuNavigationController = self.sideMenu
            SideMenuManager.default.addPanGestureToPresent(toView: self.view)
            
        }
        
    }
    
    func didSelectMenuItem(named: String) {
        sideMenu?.dismiss(animated: true, completion: nil)
        if named == MenuConstant.Sign_In {
            self.performSegue(withIdentifier: K.Segues.toAuth, sender: self)
        }else if named == MenuConstant.Sign_Out {
            Service.LogOutApi { result in
                if result.success {
                    constant.authToken = ""
                    constant.loginEmail = ""
                    constant.userImage = ""
                    constant.isCreator = false
                    self.showToast(message: "Sign Out Successful.", styleColor: .white,backgroundColor: .systemGreen)
//                    self.profileImg!.image = UIImage(systemName: "person.circle.fill")
                }else {
                    self.showToast(message: "Sign Out Fail.", styleColor: .white,backgroundColor: .red)
                }
            } failure: { err in
                self.showToast(message: err, styleColor: .white,backgroundColor: .red)
            }

            
        }else if named == MenuConstant.Favorites_List {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "favlist")
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if named == MenuConstant.My_Masjid {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyMasjidViewController") as? MyMasjidViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if named == MenuConstant.Update_Time_schedule {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NextSchListViewController") as? NextSchListViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }else if named == MenuConstant.Settings {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if named == MenuConstant.Qibla_Direction {
            performSegue(withIdentifier: K.Segues.toQibla, sender: self)
        }else if named == MenuConstant.Send_Notifications {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SendPushViewController") as? SendPushViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if named == MenuConstant.Submit_Review {
            performSegue(withIdentifier: K.Segues.toSettings, sender: self)

        }
    }
    
    func determineMyCurrentLocation() {
        if CLLocationManager.locationServicesEnabled()
        {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.distanceFilter = kCLDistanceFilterNone
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest

            let authorizationStatus = CLLocationManager.authorizationStatus()
            if (authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways)
            {
                self.locationManager.startUpdatingLocation()
            }
            else if (locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)))
            {
                 self.locationManager.requestAlwaysAuthorization()
            }
            else
            {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
          CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
      }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
        {
            print("Error while requesting new coordinates")
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        do {
            try setName(manager: manager,locations: locations)
        } catch _ {
            print("error")
        }
    }
    
    func setName(manager:CLLocationManager, locations:[CLLocation]) throws {
        if let location = locations.last {

                    let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)

                    geocode(latitude: myLocation.latitude, longitude: myLocation.longitude) { placemark, error in
                        guard let placemark = placemark, error == nil else { return }
                        // you should always update your UI in the main thread
                        self.locationLabel.text = (placemark.thoroughfare ?? "") + "," + (placemark.administrativeArea ?? "") + "," + (placemark.country ?? "")
                    }
                }
                manager.stopUpdatingLocation()
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
