//
//  TimesViewController.swift
//  Salli
//
//  Created by Omar Khodr on 5/26/20.
//  Copyright © 2020 Omar Khodr. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import SideMenu
import SDWebImage

class TimesViewController: UIViewController, MenuControllerDelegate {
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
                    self.profileImg!.image = UIImage(systemName: "person.circle.fill")
                }else {
                    self.showToast(message: "Sign Out Fail.", styleColor: .white,backgroundColor: .red)
                }
            } failure: { err in
                self.showToast(message: err, styleColor: .white,backgroundColor: .red)
            }

            
        }else if named == MenuConstant.Favorites_List {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "favlist")
            self.navigationController?.pushViewController(vc!, animated: true)
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
    
   
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    @IBOutlet weak var prayerTimesBackgroundView: UIView!
    @IBOutlet weak var prayerTimesStack: UIStackView!
    
    @IBOutlet var prayerLabels: [UILabel]!
    @IBOutlet var prayerTimeLabels: [UILabel]!
    @IBOutlet var periodLabels: [UILabel]!
    
    @IBOutlet weak var midnightStack: UIStackView!
    @IBOutlet weak var imsakStack: UIStackView!
    
    @IBOutlet weak var qiblaButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    var prayerTimes: [Date] = []
    var locationString: String = ""
    var timeLeftString: String = ""
    var latitude: Double?
    var longitude: Double?
    var profileImg: UIImageView?
    let defaults = UserDefaults.standard
    private var sideMenu: SideMenuNavigationController?
    
    
    let coreDataHelper = CoreDataHelper()
    
    //initialize location manager for requesting/fetching current location
    var locationManager = CLLocationManager()
    //initialize prayer times manager for sending and handling requests to the Prayer Times API
    var prayerTimesManager = PrayerTimesManager()
    //UserDefaults
    var defaultsManager: DefaultsManager!
    //Alert service/factory
    let alertService = AlertService()
    
    var hasOnboarded: Bool!
    
    var timer: Timer!
    
    override func viewWillAppear(_ animated: Bool) {
                //assign button to navigationbar
//        self.navigationItem.rightBarButtonItem = barButton
        
//        if constant.authToken != "" {
//            if constant.userImage != "" {
//                print(constant.userImage,", klklkl 1")
//                self.profileImg!.sd_setImage(with: URL(string: constant.userImage))
//            }
//            else {
//                self.profileImg!.image = UIImage(systemName: "person.circle.fill")
//            }
//        }else {
//            self.profileImg!.image = UIImage(systemName: "person.circle.fill")
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
                //add function for button
                //set frame

        
//        let now = Calendar.current.dateComponents(in: .current, from: Date())
//        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
//        let dateTomorrow = Calendar.current.date(from: tomorrow)!
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = "dd-MM-yyyy"
//        let tomDAte = inputFormatter.string(from: dateTomorrow)
//        tomDate.text = tomDAte
//
//        for tomView in self.tomPrayerView {
//            tomView.layer.cornerRadius = 20
//        }
        configureRefreshControl()
        defaultsManager = DefaultsManager()
        hasOnboarded = defaultsManager.setupDefaults()

        //clearing labels to prepare them for being updated by Core Data and/or CLLocationManager
        locationLabel.text = ""
        timeLeftLabel.text = ""
        currentDateLabel.text = ""

        //adding rounded corners
        prayerTimesBackgroundView.rounded(cornerRadius: 16)
        qiblaButton.rounded(cornerRadius: 8)
        settingsButton.rounded(cornerRadius: 8)
        
        //setting view as delegate for location manager
        locationManager.delegate = self
        
        //setting view as delegate for prayer times manager
        prayerTimesManager.delegate = self
        
        loadData(needUpdating: false)
        setUpMenu()
        fetchPrayerTimes()
        locationManager.startUpdatingLocation()
        
    }
    @IBAction func masjidList(_ sender: Any) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaultsManager.setupViews(self, hasOnboarded)
        hasOnboarded = true
    }
    
    func loadData(needUpdating: Bool) {
        midnightStack.isHidden = !defaults.bool(forKey: K.Keys.showMidnightTime)
        imsakStack.isHidden = !defaults.bool(forKey: K.Keys.showImsakTime)
        
        //Setting date label as current Hijri date
        let dateFor = DateFormatter()

        let hijriCalendar = Calendar.init(identifier: Calendar.Identifier.islamicCivil)
        //use "lang" key from Localized to display date in accordance with system language
        dateFor.locale = Locale.init(identifier: "lang".localized)

        dateFor.calendar = hijriCalendar

        dateFor.dateFormat = "EEEE, MMM d, yyyy"
        currentDateLabel.text = "\(dateFor.string(from: Date())) \("AH".localized)"
        
        //fetching data (if available) from database and checking if still valid, request location to update them if either check fails.
        loadTimes(needUpdating: needUpdating)
        updateUI()
        
        //timer for calling updateUI() on separate thread every tenth of a second.
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(TimesViewController.updateUI), userInfo: nil, repeats: true)
    }
    
    @IBAction func qiblaButtonPressed(_ sender: UIButton) {
        if latitude != nil && longitude != nil {
            animate(button: sender)
            performSegue(withIdentifier: K.Segues.toQibla, sender: self)
        }
    }
    
    @IBAction func profileAction(_ sender: Any) {
        
    }
    
    @IBAction func menuAction(_ sender: Any) {
        print("working")
        present(sideMenu!, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        print("working2")
        animate(button: sender)
        performSegue(withIdentifier: K.Segues.toSettings, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.toQibla {
            let destVC = segue.destination as! QiblaViewController
            if let lat = latitude, let long = longitude {
                destVC.latitude = lat
                destVC.longitude = long
            }
        }
        if segue.identifier == K.Segues.toAuth {
//            let destVC = segue.destination as! LogInViewController
        }
    }
    
    func formatDate(date:String)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: date)!
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    func fetchPrayerTimes() {
        let automaticLocation = defaults.bool(forKey: K.Keys.automaticLocation)
        if automaticLocation {
            requestLocation()
        } else {
            let city = defaults.string(forKey: K.Keys.manualCity)!
            let country = defaults.string(forKey: K.Keys.manualCountry)!
            prayerTimesManager.fetchTimings(city: city, country: country)
            Service.prayerTimesWithCity(city: city, country: country) { result in
                print(result)
//                self.tomArsLbl.text = "\(self.formatDate(date: (result.data?.timings.Asr)!))"
//                self.tomFajLbl.text = "\(self.formatDate(date: (result.data?.timings.Fajr)!))"
//                self.tomMagLbl.text = "\(self.formatDate(date: (result.data?.timings.Maghrib)!))"
//                self.tomDuhrLbl.text = "\(self.formatDate(date: (result.data?.timings.Dhuhr)!))"
//                self.tomIshaLbl.text = "\(self.formatDate(date: (result.data?.timings.Isha)!))"
//                self.tomSunriseLbl.text = "\(self.formatDate(date: (result.data?.timings.Sunrise)!))"
                
            } failure: { err in
                print(err)
                
            }

            
        }
    }
    
}

//MARK: - CLLocationManagerDelegate Methods
extension TimesViewController: CLLocationManagerDelegate {
    //method that gets triggered when location, managed by CLLocationManager, is updated
    //input is self and array of fetched locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //get last location fetched
        if let location = locations.last {
            //stop updating location while fetching from array
            locationManager.stopUpdatingLocation()
            //call method of prayer times manager to perform GET request from the API to fetch the latest prayer times and update the UI
            prayerTimesManager.fetchTimings(coordinates: location)
            Service.prayerTimesWithCoord(lon: "\(location.coordinate.longitude)", lat: "\(location.coordinate.latitude)") { result in
                print(result)
            } failure: { err in
                
            }
            

            
        }
    }
    
    //in case updating location fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        stopRefreshControl()
        let warningAlertVC = alertService.warningAlert(title: "Location Error".localized,
                                                       body: "Failed to get location. Please make sure that location is enabled for Salli in Settings and try again later.".localized,
                                                       cancelVisible: false,
                                                       actionName: "Okay".localized) { }
        present(warningAlertVC, animated: true)
    }
    
    func requestLocation() {
        // Request location permission in case app isn't allowed
        locationManager.requestWhenInUseAuthorization()
        //request location
        locationManager.requestLocation()
    }
}

//MARK: - PrayerTimesManagerDelegate Methods
extension TimesViewController: PrayerTimesManagerDelegate {
    //called when updating prayer times fails
    func didFailWithError(_ manager: PrayerTimesManager, error: Error) {
        var body = ""
        if defaults.bool(forKey: K.Keys.automaticLocation) {
            body = "Failed to connect to the network to fetch latest prayer times. Please make sure that the device has internet access and try again.".localized
        } else {
            body = "Failed to connect to the network to fetch latest prayer times. Please make sure that the device has internet access and that the city and country fields are spelled correctly.".localized
        }
        DispatchQueue.main.async {
            let warningAlertVC = self.alertService.warningAlert(title: "Network Error".localized,
                                                           body: body,
                                                           cancelVisible: false,
                                                           actionName: "Okay".localized) { }
            self.present(warningAlertVC, animated: true)

        }
        stopRefreshControl()
        print("Failed fetching prayer times: \(error)")
    }
    
    func didFailReverseGeolocation(_ manager: PrayerTimesManager, error: Error) {
        DispatchQueue.main.async {
            let warningAlertVC = self.alertService.warningAlert(title: "Location Error".localized,
                                                                body: "Failed to identify city and country.".localized,
                                                           cancelVisible: false,
                                                           actionName: "Okay".localized) { }
            self.present(warningAlertVC, animated: true)
        }
        stopRefreshControl()
        print("error performing reverse geolocation: \(error)")
    }
    
    //called to update UI when prayer times are updated
    func didUpdatePrayerTimes(_ manager: PrayerTimesManager, _ model: PrayerTimesModel) {
        stopRefreshControl()
        DispatchQueue.main.async {
            self.coreDataHelper.saveNewTimes(model: model)
        }
        prayerTimes = model.times
        locationString = model.location
        latitude = model.latitude
        longitude = model.longitude
        constant.lat = model.latitude
        constant.lon = model.longitude
    }
}



extension TimesViewController {
    
//MARK: - Core Data Methods
    
    func loadTimes(needUpdating: Bool) {
        let result: [PrayerInfo] = coreDataHelper.fetch()
        guard result.count <= 1 else {
            fatalError("result has more than one element!!!")
        }
        let info = result.first
        if let info = info {
            let model = PrayerTimesModel(from: info)
            prayerTimes = model.times
            locationString = model.location
            latitude = model.latitude
            longitude = model.longitude
        }
        if !coreDataHelper.upToDate(info: info) || needUpdating {
            defaults.set(false, forKey: K.Keys.needUpdatingSettings)
            fetchPrayerTimes()
        }
    }
    
//MARK: - UI Helper Methods
    
    @objc func updateUI() {
        //if prayerTimes not yet loaded into array, nothing to update.
        if prayerTimes.count == 0 {
            return
        }
        
        let needUpdating = defaults.bool(forKey: K.Keys.needUpdatingSettings)
        
        if needUpdating {
            timer.invalidate()
            defaults.set(false, forKey: K.Keys.needUpdatingSettings)
            loadData(needUpdating: true)
            return
        }
        
        //use model to get string of next prayer
        var nextPrayer = PrayerCurrentInformation.nextPrayer(prayerTimes)
        //capitalize first character
        nextPrayer = nextPrayer.prefix(1).capitalized + nextPrayer.dropFirst()
        //set string for time left using model function to which we pass captialized string of next prayer
        timeLeftString = PrayerCurrentInformation.timeLeftString(prayerTimes, nextPrayer)
        
        //use model to get string of current prayer
        let currentPrayer = PrayerCurrentInformation.currentPrayer(prayerTimes)
        
        //get "index" of current prayer using constant array of prayer names
        var currentTag = K.prayersArray.firstIndex(of: currentPrayer)!
        
        //if prayer tag is either 1 (Sunrise), 6 (Midnight) or 7 (Imsak), do not highlight
        let noHighlight = [1,6,7]
        if noHighlight.contains(currentTag) {
            currentTag = -1
        }
        
        let highlightColor = UIColor(named: K.Colors.brandBlue)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        var timeStrings: [[String]] = []
        for time in prayerTimes {
            timeStrings.append(formatter.string(from: time).components(separatedBy: " "))
        }
        
        //updating UI elements on main thread.
        DispatchQueue.main.async {
            self.locationLabel.text = self.locationString
            
            self.timeLeftLabel.text = self.timeLeftString
            
            for timeLabel in self.prayerTimeLabels {
                timeLabel.text = timeStrings[timeLabel.tag][0]
            }
            for periodLabel in self.periodLabels {
                periodLabel.text = timeStrings[periodLabel.tag][1]
            }
            
            //reset colors of all labels to initial color
            self.resetLabelColors(of: self.prayerLabels)
            self.resetLabelColors(of: self.prayerTimeLabels)
            self.resetLabelColors(of: self.periodLabels)
            
            //set highlight color to current prayer
            self.setLabelColor(in: self.prayerLabels, tag: currentTag, color: highlightColor)
            self.setLabelColor(in: self.prayerTimeLabels, tag: currentTag, color: highlightColor)
            self.setLabelColor(in: self.periodLabels, tag: currentTag, color: highlightColor)
        }
        
    }
    
    func resetLabelColors(of labelArray: [UILabel]) {
        for label in labelArray {
            label.textColor = .white
        }
    }
    
    func setLabelColor(in labelArray: [UILabel], tag: Int, color: UIColor?) {
        for label in labelArray {
            if label.tag == tag  {
                label.textColor = color
            }
        }
    }
    
    func animate(button: UIButton) {
        //animate button by shrinking to 95% size for a tenth of a second then back to original size in the same time
        UIView.animate(withDuration: 0.1,
        animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = CGAffineTransform.identity
            }
        })
    }
    
    func configureRefreshControl () {
       // Add the refresh control to your UIScrollView object.
       scrollView.refreshControl = UIRefreshControl()
       scrollView.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }
        
    @objc func handleRefreshControl() {
        fetchPrayerTimes()
    }
    
    func stopRefreshControl() {
        DispatchQueue.main.async {
            if let refreshControl = self.scrollView.refreshControl, refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
    }
    
}
