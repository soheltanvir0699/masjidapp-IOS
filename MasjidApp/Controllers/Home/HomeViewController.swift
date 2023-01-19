//
//  HomeViewController.swift
//  MasjidApp
//
//  Created by Sohel Rana on 28/10/22.
//

import UIKit
import SideMenu
import SDWebImage
import CoreLocation

class HomeViewController: UIViewController,MenuControllerDelegate,UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var homeTbl: UITableView!
    private var sideMenu: SideMenuNavigationController?
    var profileImg: UIImageView?
    var homeData: MosquesHomeModel?
    var defaultsManager: DefaultsManager!
    var hasOnboarded: Bool!
    var locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    var nextLink:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.locationManager.delegate = self
            self.defaultsManager = DefaultsManager()
            self.hasOnboarded = self.defaultsManager.setupDefaults()
            self.setUpMenu()
            self.searchBar.tintColor = .white
            self.searchBar.delegate = self
            self.searchBar.barTintColor = .white
            self.searchBar.searchTextField.textColor = .white
            self.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search a Masjid", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
            self.profileImg=UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            self.profileImg?.isUserInteractionEnabled = true
            self.profileImg?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.searchBtnAction(gesture:))))
            self.profileImg?.layer.cornerRadius = 12.5
            let barButton = UIBarButtonItem(customView: self.profileImg!)
        
        barButton.customView?.layer.cornerRadius = 12.5
        self.profileImg!.image = UIImage(systemName: "magnifyingglass")
        self.navigationController?.navigationBar.tintColor = .white
                //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        // Do any additional setup after loading the view.\
            self.fetchPrayerTimes()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaultsManager.setupViews(self, hasOnboarded)
        hasOnboarded = true
    }
    
    func fetchPrayerTimes() {
        let automaticLocation = defaults.bool(forKey: K.Keys.automaticLocation)
        if automaticLocation {
            requestLocation()
        }
    }
    
    func requestLocation() {
        // Request location permission in case app isn't allowed
        locationManager.requestWhenInUseAuthorization()
        //request location
        locationManager.requestLocation()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
        let label = UILabel()
        label.text = "MOSQUES"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
            self.navigationItem.titleView = label
            self.profileImg?.isHidden = false
        }
    }
    @objc func searchBtnAction(gesture:UITapGestureRecognizer) {
        print("search")
        DispatchQueue.main.async {
            self.navigationItem.titleView = self.searchBar
            self.profileImg?.isHidden = true
        }
    }
    var isSearching = false
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Service.SearchApi(keyword: searchBar.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) { result in
            if result.success {
                self.homeData = result
                DispatchQueue.main.async {
                    self.homeTbl.reloadData()
                }
                
            }
        } failure: { _ in
            
        }

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !isSearching{
            isSearching = true
            Service.SearchApi(keyword: searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) { result in
                if result.success {
                    self.homeData = result
                    self.nextLink = result.data?.next
                    DispatchQueue.main.async {
                    self.homeTbl.reloadData()
                    }
                }
                self.isSearching = false
            } failure: { _ in
                self.isSearching = false
            }
        }
    }
    fileprivate func HomeApiCalling() {
        Service.HomeApi { result in
            DispatchQueue.main.async {
            self.hideLoader()
            }
            if result.success {
                self.homeData = result
                self.nextLink = result.data?.next
                DispatchQueue.main.async {
                self.homeTbl.reloadData()
                }
            }
        } failure: { err in
            DispatchQueue.main.async {
            self.hideLoader()
            }
            self.showToast(message: err, styleColor: .white ,backgroundColor: .red)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
        profileImg?.tintColor = .white
        DispatchQueue.main.async {
        self.showLoader(controller: self)
        }
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "timesview2")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "timesview")
        vc?.modalPresentationStyle = .fullScreen
        vc2?.modalPresentationStyle = .fullScreen
        if constant.isfirstopen {
            if constant.IsFirstTime {
                var isFav = false
                Service.FavListApi { result in
                    self.hideLoader()
                    print(result)
                    print(result.success)
                    print(result.data.count)
                    
                    if result.success {
                        if result.data.count == 0 {
                            self.present(vc!, animated: true)
                        }else {
                        for i in result.data {
                            if i.is_default! {
                                print(i.is_default)
                                isFav = true
                                constant.fav_data = i
                            }
                        }
                        if isFav {
                            self.present(vc2!, animated: true)
                        }else {
                            self.present(vc!, animated: true)
                        }
                        }
                    }else {
                        self.present(vc!, animated: true)
                    }
                } failure: { err in
                    DispatchQueue.main.async {
                    self.hideLoader()
                    }
                    self.present(vc!, animated: true)
                    
                }
            }else {
                HomeApiCalling()
            }
        }else {
           HomeApiCalling()
        }
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.fetchPrayerTimes()
        }
        
        constant.IsFirstTime = true
        constant.isfirstopen = false
        
    }
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (homeTbl.contentSize.height-100-scrollView.frame.size.height) {
            print(position)
            guard !Service.isPaginating else {
                return
            }
            guard nextLink != nil else {
                return
            }
            self.homeTbl.tableFooterView = createSpinnerFooter()
            Service.HomeApiWithUrl(url: nextLink!, isPaginating: true) { result in
                
                if result.success {
                    self.nextLink = result.data?.next
                    if result.data?.results != nil {
                        if self.homeData?.data?.results != nil {
                       self.homeData?.data?.results! += (result.data?.results)!
                        }else {
                            self.homeData?.data?.results = result.data?.results
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.homeTbl.tableFooterView = nil
                }
                self.homeTbl.reloadData()
            } failure: { err in
                DispatchQueue.main.async {
                    self.homeTbl.tableFooterView = nil
                }
            }

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
        }else if named == MenuConstant.My_Masjid {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyMasjidViewController") as? MyMasjidViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if named == MenuConstant.Update_Time_schedule {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NextSchListViewController") as? NextSchListViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }else if named == MenuConstant.Settings {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else if named == MenuConstant.Qibla_Direction {
            performSegue(withIdentifier: K.Segues.toQibla, sender: self)
        } else if named == MenuConstant.Send_Notifications {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SendPushViewController") as? SendPushViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if named == MenuConstant.Submit_Review {
            performSegue(withIdentifier: K.Segues.toSettings, sender: self)
        }
    }
    
    @IBAction func menuAction(_ sender: Any) {
        present(sideMenu!, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func masjidTimeAction(_ sender: TransitionButton) {
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "timesview2")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "timesview")
        vc?.modalPresentationStyle = .fullScreen
        vc2?.modalPresentationStyle = .fullScreen
        if constant.authToken == "" {
            self.present(vc!, animated: true)
        }else {
            var isFav = false
            DispatchQueue.main.async {
            sender.startAnimation()
            }
            Service.FavListApi { result in
                DispatchQueue.main.async {
                sender.stopAnimation()
                }
                
                if result.success {
                    if result.data.count == 0 {
                        self.present(vc!, animated: true)
                    }else {
                    for i in result.data {
                        if i.is_default! {
                            isFav = true
                            constant.fav_data = i
                        }
                    }
                    if isFav {
                        self.present(vc2!, animated: true)
                    }else {
                        self.present(vc!, animated: true)
                    }
                    }
                }
            } failure: { err in
                DispatchQueue.main.async {
                sender.stopAnimation()
                }
            }
        }
    }
    
    @objc func FavAction(sender: UIButton) {
        if constant.authToken == "" {
            self.performSegue(withIdentifier: K.Segues.toAuth, sender: self)
            
        }else {
        let tag = sender.tag-10000
            let id = homeData!.data!.results![tag].id
            DispatchQueue.main.async {
        self.showLoader(controller: self)
            }
        if sender.currentTitle == "+" {
            Service.AddToFavApi(salat_Id: "\(id)",is_default: "False") { resutl in
                if resutl.success {
                    self.HomeApiCalling()
                    self.showToast(message: resutl.message, styleColor: .white, backgroundColor: .systemGreen)
                }else {
                    self.showToast(message: resutl.message, styleColor: .white, backgroundColor: .red)
                }
            } failure: { err in
                self.showToast(message: err, styleColor: .white, backgroundColor: .red)
            }

        }else {
            Service.RemoveToFavSalatApi(salat_Id: "\(id)") { resutl in
                if resutl.success {
                    self.HomeApiCalling()
                    self.showToast(message: resutl.message, styleColor: .white, backgroundColor: .systemGreen)
                }else {
                    self.showToast(message: resutl.message, styleColor: .white, backgroundColor: .red)
                }
            } failure: { err in
                self.showToast(message: err, styleColor: .white, backgroundColor: .red)
            }
        }
        
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if homeData != nil {
            return (homeData?.data!.results!.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as? HomeCell
        if homeData?.data!.results![indexPath.row].mosque_icon != nil {
        cell?.imgView.sd_setImage(with: URL(string: (homeData?.data!.results![indexPath.row].mosque_icon)!), placeholderImage: UIImage(named: "icon"))
        }else {
            cell?.imgView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "icon"))
        }
        cell?.addLbl.text = (homeData?.data!.results![indexPath.row].state)! + ", " + (homeData?.data!.results![indexPath.row].city)! + ", " + (homeData?.data!.results![indexPath.row].country)!
        cell?.add_rm_fav_btn.tag = 10000+indexPath.row
        cell?.add_rm_fav_btn.addTarget(self, action: #selector(FavAction(sender:)), for: .touchUpInside)
        if homeData!.data!.results![indexPath.row].is_add_fav {
            cell?.add_rm_fav_btn.setTitle("-", for: .normal)
        }else {
            cell?.add_rm_fav_btn.setTitle("+", for: .normal)
        }
        cell?.selectedBackgroundView = UIView()
        cell?.nameLbl.text = homeData?.data!.results![indexPath.row].mosque_name
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MasjidDetailsViewController") as? MasjidDetailsViewController
        vc?.data = homeData?.data!.results![indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
}


extension HomeViewController: CLLocationManagerDelegate {
    //method that gets triggered when location, managed by CLLocationManager, is updated
    //input is self and array of fetched locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //get last location fetched
        if let location = locations.last {
            //stop updating location while fetching from array
            
            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            constant.lat = myLocation.latitude
            constant.lon = myLocation.longitude
            
            geocode(latitude: myLocation.latitude, longitude: myLocation.longitude) { placemark, error in
                guard let placeMark = placemark, error == nil else { return }
                // you should always update your UI in the main thread
                if let city = placeMark.locality {
                            print(city)
                    constant.city = city
                    
                        }
                        // State
                        if let state = placeMark.administrativeArea {
                            print(state)
                            constant.state = state
                        }
                        // Zip code
                        if let zipCode = placeMark.postalCode {
                            print(zipCode)
                            
                        }
                        // Country
                        if let country = placeMark.country {
                            print(country)
                            constant.country = country
                        }
                self.HomeApiCalling()
            }
            locationManager.stopUpdatingLocation()
            //call method of prayer times manager to perform GET request from the API to fetch the latest prayer times and update the UI
           
        }
    }
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
          CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
      }
    
    //in case updating location fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
