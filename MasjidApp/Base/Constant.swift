//
//  Constant.swift
//  MasjidApp
//
//  Created by Sohel Rana on 10/10/22.
//

import Foundation
import UIKit

class constant {
    static var index = 1
    static var login_type = 0
    static var fav_data:FavListDataModel?
    static var isfirstopen = true
    static var on_signal_api = "5aac78d8-4ad3-4314-bfae-dbed8d042a86"
    static var Menu_Items_Array_login_admin = ["","Profile","My Masjid","Favorites List","Create / Update Next Schedule","Qibla Direction","Send Notifications","Submit Review","Settings","Sign Out"]
    static var Menu_icons_Array_login_admin = ["","man","note","wishlist","tasks","directions","bell-ring","rating","settings","logout"]
    
    static var Menu_Items_Array_login = ["","Profile","Favorites List","Qibla Direction","Submit Review","Settings","Sign Out"]
    static var Menu_icons_Array_login = ["","man","wishlist","directions","rating","settings","logout"]
    
    static var Menu_Items_Array = ["","Sign In","Qibla Direction","Submit Review","Settings"]
    static var Menu_icons_Array = ["","login","directions","rating","settings"]
    
    static var fatal_error = "init(coder:) has not been implemented"
    static var authToken: String {
          set {
              UserDefaults.standard.set(newValue, forKey: "authToken")
          } get {
              var user_value = ""
              if UserDefaults.standard.value(forKey: "authToken") != nil {
                  user_value = UserDefaults.standard.value(forKey: "authToken") as! String
              }
              return user_value
          }
      }
    static var onesegnalId: String {
          set {
              UserDefaults.standard.set(newValue, forKey: "onesegnalId")
          } get {
              var user_value = ""
              if UserDefaults.standard.value(forKey: "onesegnalId") != nil {
                  user_value = UserDefaults.standard.value(forKey: "onesegnalId") as! String
              }
              return user_value
          }
      }
    
    
    static var IsFirstTime: Bool {
          set {
              UserDefaults.standard.set(newValue, forKey: "IsFirstTime")
          } get {
              var user_value = false
              if UserDefaults.standard.value(forKey: "IsFirstTime") != nil {
                  user_value = UserDefaults.standard.value(forKey: "IsFirstTime") as! Bool
              }
              return user_value
          }
      }
    
    static var loginEmail: String {
          set {
              UserDefaults.standard.set(newValue, forKey: "loginEmail")
          } get {
              var user_value = ""
              if UserDefaults.standard.value(forKey: "loginEmail") != nil {
                  user_value = UserDefaults.standard.value(forKey: "loginEmail") as! String
              }
              return user_value
          }
      }
    static var state: String {
          set {
              UserDefaults.standard.set(newValue, forKey: "state")
          } get {
              var user_value = ""
              if UserDefaults.standard.value(forKey: "state") != nil {
                  user_value = UserDefaults.standard.value(forKey: "state") as! String
              }
              return user_value
          }
      }
    
    static var TimeFormat: Int {
          set {
              UserDefaults.standard.set(newValue, forKey: "TimeFormat")
          } get {
              var user_value = 12
              if UserDefaults.standard.value(forKey: "TimeFormat") != nil {
                  user_value = UserDefaults.standard.value(forKey: "TimeFormat") as! Int
              }
              return user_value
          }
      }
    
    static var city: String {
          set {
              UserDefaults.standard.set(newValue, forKey: "city")
          } get {
              var user_value = ""
              if UserDefaults.standard.value(forKey: "city") != nil {
                  user_value = UserDefaults.standard.value(forKey: "city") as! String
              }
              return user_value
          }
      }
    static var lat: Double {
          set {
              UserDefaults.standard.set(newValue, forKey: "lat")
          } get {
              var user_value = 0.0
              if UserDefaults.standard.value(forKey: "lat") != nil {
                  user_value = UserDefaults.standard.value(forKey: "lat") as! Double
              }
              return user_value
          }
      }
    static var lon: Double {
          set {
              UserDefaults.standard.set(newValue, forKey: "lon")
          } get {
              var user_value = 0.0
              if UserDefaults.standard.value(forKey: "lon") != nil {
                  user_value = UserDefaults.standard.value(forKey: "lon") as! Double
              }
              return user_value
          }
      }
    static var country: String {
          set {
              UserDefaults.standard.set(newValue, forKey: "country")
          } get {
              var user_value = ""
              if UserDefaults.standard.value(forKey: "country") != nil {
                  user_value = UserDefaults.standard.value(forKey: "country") as! String
              }
              return user_value
          }
      }
    static var isCreator: Bool {
          set {
              UserDefaults.standard.set(newValue, forKey: "isCreator")
          } get {
              var user_value = false
              if UserDefaults.standard.value(forKey: "isCreator") != nil {
                  user_value = UserDefaults.standard.value(forKey: "isCreator") as! Bool
              }
              return user_value
          }
      }
    static var userImage: String {
          set {
              UserDefaults.standard.set(newValue, forKey: "userImage")
          } get {
              var user_value = ""
              if UserDefaults.standard.value(forKey: "userImage") != nil {
                  user_value = UserDefaults.standard.value(forKey: "userImage") as! String
              }
              return user_value
          }
      }
    
}
class BoolConstant {
    static var is_true = true
    static var is_false = false
}

class CellConstant {
    static var menu_cell = "MenuCell"
    static var cell = "cell"
    static var header_view = "HeaderView"
    static var header = "header"
    static var header_title = "HeaderTitleCell"
    static var header_title_cell = "headerTitle"
    
}

class MenuConstant {
    static var Shady_Pines_Radio = "Profile"
    static var Sign_In = "Sign In"
    static var Sign_Out = "Sign Out"
    static var Favorites_List = "Favorites List"
    static var My_Masjid = "My Masjid"
    static var Update_Time_schedule = "Create / Update Next Schedule"
    static var Settings = "Settings"
    static var Qibla_Direction = "Qibla Direction"
    static var Send_Notifications = "Send Notifications"
    static var Submit_Review = "Submit Review"
}

class ApiConstant {
    static var timesApi = "http://api.aladhan.com/v1/calendar"
}
