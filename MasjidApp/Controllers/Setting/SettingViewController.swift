//
//  SettingViewController.swift
//  MasjidApp
//
//  Created by Sohel Rana on 20/12/22.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var timeFormatSeg: UISegmentedControl!
    @IBOutlet weak var timeZone: UILabel!
    @IBOutlet weak var segButton: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        if constant.TimeFormat == 12 {
            timeFormatSeg.selectedSegmentIndex = 0
        }else {
            timeFormatSeg.selectedSegmentIndex = 1
        }
        checkPushNotificationAllowed { result in
            if result {
                 // User is registered for notification
                DispatchQueue.main.async {
                    self.segButton.selectedSegmentIndex = 0
                }
                
            } else {
                 // Show alert user is not registered for notification
                DispatchQueue.main.async {
                self.segButton.selectedSegmentIndex = 1
                }
            }
        }
        
        self.navigationController?.navigationBar.tintColor = .black

        // Do any additional setup after loading the view.
        Service.getSettingsApi { result in
            if result.success {
                self.timeZone.text = result.time_zone
                self.country.text = result.country
            }
        } failure: { err in
            
        }
    }
    
    private func checkPushNotificationAllowed(completionHandler: @escaping (Bool) -> Void) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if settings.authorizationStatus == .notDetermined || settings.authorizationStatus == .denied {
                    completionHandler(false)
                }
                else {
                    completionHandler(true)
                }
            }
        }
        else {
            if let settings = UIApplication.shared.currentUserNotificationSettings {
                if settings.types.isEmpty {
                    completionHandler(false)
                }
                else {
                    completionHandler(true)
                }
            }
            else {
                completionHandler(false)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    @IBAction func hoursSelect(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
                {
        case 0:
            constant.TimeFormat = 12
        case 1:
            constant.TimeFormat = 24
        default:
            break;
        }
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex
                {
        case 0:
            UIApplication.shared.registerForRemoteNotifications()
                    NSLog("Popular selected")
                    //show popular view
        case 1:
            UIApplication.shared.unregisterForRemoteNotifications()
                    NSLog("History selected")
                    //show history view
                default:
                    break;
                }
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
