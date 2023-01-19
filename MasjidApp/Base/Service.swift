//
//  Service.swift
//  MasjidApp
//
//  Created by Sohel Rana on 13/10/22.
//

import Foundation
import Alamofire
import UIKit
import OneSignal

class Service: NSObject {
    
    static func generateRandomError() -> String {
        return "Oops. Please reload again."
    }
    static var isPaginating = false
    class func LoginApi(email:String,pass:String,success: @escaping (logInModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/login/"
        var parameterDictionary = ["username" : email, "password":pass,"user_id":constant.onesegnalId]
        APIManager.request(url, method: .post, parameters: parameterDictionary, encoding: JSONEncoding.default, headers: APIManager.requestHeader()) { response in
            do {
                let decoded = try JSONDecoder().decode(logInModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
    
    class func HomeApi(isPaginating:Bool=false,success: @escaping (MosquesHomeModel) -> (), failure: @escaping (String) -> ()) {
        Service.isPaginating = isPaginating
        let url = "api/all-masjid/"
        let parameterDictionary = ["email" : constant.loginEmail, "state":constant.state, "city":constant.city,"country":constant.country]
        APIManager.request(url, method: .post, parameters: parameterDictionary, encoding: JSONEncoding.default, headers: APIManager.requestHeader()) { response in
            do {
                let decoded = try JSONDecoder().decode(MosquesHomeModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
            Service.isPaginating = false
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
            Service.isPaginating = false
        }
        
    }
    
    class func HomeApiWithUrl(url:String,isPaginating:Bool=false,success: @escaping (MosquesHomeModel) -> (), failure: @escaping (String) -> ()) {
        Service.isPaginating = isPaginating
        let parameterDictionary = ["email" : constant.loginEmail, "state":constant.state, "city":constant.city,"country":constant.country]
        APIManager.requestWithUrl(url, method: .post, parameters: parameterDictionary, encoding: JSONEncoding.default, headers: APIManager.requestHeader()) { response in
            do {
                let decoded = try JSONDecoder().decode(MosquesHomeModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
            Service.isPaginating = false
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
            Service.isPaginating = false
        }
        
    }
    
    class func getSchMasjidApi(success: @escaping (schUpdModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/create-sch-masjid/"
        APIManager.request(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: APIManager.requestHeaderWithToken()) { response in
            do {
                let decoded = try JSONDecoder().decode(schUpdModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
    
    class func FavListApi(success: @escaping (FavListModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/fav-masjid/"
        let parameterDictionary = ["email" : constant.loginEmail]
        APIManager.request(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: APIManager.requestHeaderWithToken()) { response in
            do {
                let decoded = try JSONDecoder().decode(FavListModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
    
    class func MyMasjidListApi(success: @escaping (MosquesModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/salat_times/"
        let parameterDictionary = ["email" : constant.loginEmail]
        APIManager.request(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: APIManager.requestHeaderWithToken()) { response in
            do {
                let decoded = try JSONDecoder().decode(MosquesModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
    
    
    class func getSettingsApi(success: @escaping (TimeZoneModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/update_timezone/"
        APIManager.request(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: APIManager.requestHeaderWithToken()) { response in
            do {
                let decoded = try JSONDecoder().decode(TimeZoneModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
    
    class func getDayINfo(city:String,country:String,success: @escaping (DayInfoModel) -> (), failure: @escaping (String) -> ()) {
        let url = "https://api.aladhan.com/v1/timingsByAddress?address=\(city),\(country)"
//        let url = "https://api.aladhan.com/v1/timingsByAddress?address=dhaka,bangladesh"
        APIManager.requestWithUrl(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: APIManager.requestHeaderWithToken()) { response in
            do {
                let decoded = try JSONDecoder().decode(DayInfoModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
    
    class func SearchApi(keyword:String,success: @escaping (MosquesHomeModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/search-masjid/?keyword=\(keyword)"
        let parameterDictionary = ["email" : constant.loginEmail]
        APIManager.request(url, method: .post, parameters: parameterDictionary, encoding: JSONEncoding.default, headers: APIManager.requestHeader()) { response in
            do {
                let decoded = try JSONDecoder().decode(MosquesHomeModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
    
    class func AddToFavApi(salat_Id:String,is_default:String,success: @escaping (AddFavModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/fav-masjid/"
        let parameterDictionary = ["salat_Id" : salat_Id,"is_default":is_default]
        APIManager.request(url, method: .post, parameters: parameterDictionary, encoding: JSONEncoding.default, headers: APIManager.requestHeaderWithToken()) { response in
            do {
                let decoded = try JSONDecoder().decode(AddFavModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
    
    class func RemoveToFavIdApi(fav_id:String,success: @escaping (AddFavModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/remove-fav-fav/"
        let parameterDictionary = ["fav_id" : fav_id]
        APIManager.request(url, method: .post, parameters: parameterDictionary, encoding: JSONEncoding.default, headers: APIManager.requestHeaderWithToken()) { response in
            do {
                let decoded = try JSONDecoder().decode(AddFavModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
    
    class func RemoveToFavSalatApi(salat_Id:String,success: @escaping (AddFavModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/remove-fav-salat/"
        let parameterDictionary = ["salat_Id" : salat_Id]
        APIManager.request(url, method: .post, parameters: parameterDictionary, encoding: JSONEncoding.default, headers: APIManager.requestHeaderWithToken()) { response in
            do {
                let decoded = try JSONDecoder().decode(AddFavModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
    
    class func RemoveMasjid(salat_Id:String,success: @escaping (AddFavModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/remove-masjid/"
        let parameterDictionary = ["salat_Id" : salat_Id]
        APIManager.request(url, method: .post, parameters: parameterDictionary, encoding: JSONEncoding.default, headers: APIManager.requestHeaderWithToken()) { response in
            do {
                let decoded = try JSONDecoder().decode(AddFavModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
    
    class func RemoveSch(Id:String,success: @escaping (AddFavModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/delete_sch_masjid/"
        let parameterDictionary = ["id" : Id]
        APIManager.request(url, method: .post, parameters: parameterDictionary, encoding: JSONEncoding.default, headers: APIManager.requestHeaderWithToken()) { response in
            do {
                let decoded = try JSONDecoder().decode(AddFavModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
    class func NextUpdate(name:String,date:String,Fajr:String,Dhuhr:String,Asr:String,Maghrib:String,Isha:String,success: @escaping (logInModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/create-sch-masjid/"
        let parameterDictionary = ["name":name,"date":date,"Fajr":Fajr,"Dhuhr":Dhuhr,"Asr":Asr,"Maghrib":Maghrib,"Isha":Isha] as [String : Any]
        APIManager.request(url, method: .post, parameters: parameterDictionary, encoding: JSONEncoding.default, headers: APIManager.requestHeaderWithToken()) { response in
            do {
                let decoded = try JSONDecoder().decode(logInModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
    }
    
    class func Sch_Update(name:String,date:String,id:String,Fajr:String,Dhuhr:String,Asr:String,Maghrib:String,Isha:String,success: @escaping (logInModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/update_sch_masjid/"
        let parameterDictionary = ["name":name,"date":date,"id":id,"Fajr":Fajr,"Dhuhr":Dhuhr,"Asr":Asr,"Maghrib":Maghrib,"Isha":Isha] as [String : Any]
        APIManager.request(url, method: .post, parameters: parameterDictionary, encoding: JSONEncoding.default, headers: APIManager.requestHeaderWithToken()) { response in
            do {
                let decoded = try JSONDecoder().decode(logInModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
    }
    
    class func sendPush(title:String,des:String,success: @escaping (sendPushModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/send_push_notifictions/"
        let parameterDictionary = ["title":title,"descriptions":des] as [String : Any]
        APIManager.request(url, method: .post, parameters: parameterDictionary, encoding: JSONEncoding.default, headers: APIManager.requestHeaderWithToken()) { response in
            do {
                let decoded = try JSONDecoder().decode(sendPushModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
    }
    
    class func CreateAndUpdateMasjid(id:String,state:String,city:String,country:String,url:String,mosque_name:String,mosque_icon:UIImage,Fajr:String,Dhuhr:String,Asr:String,Maghrib:String,Isha:String,success: @escaping (AddFavModel) -> (), failure: @escaping (String) -> ()) {
        let url = url
        let parameterDictionary = ["id":id,"mosque_name" : mosque_name,"mosque_icon":mosque_icon,"Fajr":Fajr,"Dhuhr":Dhuhr,"Asr":Asr,"Maghrib":Maghrib,"Isha":Isha,"state":state,"city":city,"country":country] as [String : Any]
        AF.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(mosque_name.data(using: .utf8)!,
                withName: "mosque_name")
            multipartFormData.append(Fajr.data(using: .utf8)!,
                withName: "Fajr")
            multipartFormData.append(Dhuhr.data(using: .utf8)!,
                withName: "Dhuhr")
            multipartFormData.append(Asr.data(using: .utf8)!,
                withName: "Asr")
            multipartFormData.append(Maghrib.data(using: .utf8)!,
                withName: "Maghrib")
            multipartFormData.append(Isha.data(using: .utf8)!,
                withName: "Isha")
            multipartFormData.append(id.data(using: .utf8)!,
                withName: "id")
            multipartFormData.append(state.data(using: .utf8)!,
                withName: "state")
            multipartFormData.append(city.data(using: .utf8)!,
                withName: "city")
            multipartFormData.append(country.data(using: .utf8)!,
                withName: "country")
            
            
            if mosque_icon != nil {
                let imageData = mosque_icon.jpegData(compressionQuality: 0.4)
                if imageData != nil {
                    multipartFormData.append(imageData!, withName: "mosque_icon", fileName: "photo.jpg", mimeType: "image/png")
                }
                
            }
            
        },
//                         usingThreshold: UInt64.init(),
           to: APIEnvironment.baseURL + url,
           method: .post,
                  headers: APIManager.requestHeaderWithToken()).response { (response) in
            
            if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                guard let callback = response.data else {
                    failure(generateRandomError())
                    return
                }
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                print(responseString)
                
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode(AddFavModel.self, from: callback)
                        success(decoded)
                    } catch _ {
                        failure(generateRandomError())
                    }
                }
                print(200)
            } else if response.response?.statusCode == 401 {
                failure(generateRandomError())
            }else if response.response?.statusCode == 202 {
                guard let callback = response.data else {
                    failure(generateRandomError())
                    return
                }
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                print(responseString)
                
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode(AddFavModel.self, from: callback)
                        success(decoded)
                    } catch _ {
                        failure(generateRandomError())
                    }
                }
            }
            else {
                print("else")
                guard let callbackError = response.data else {
                    failure(generateRandomError())
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(APIError.self, from: callbackError)
                    if let messageError = decoded.data?.errors?.messages, let errorCode = decoded.statusCode {
                        let messages = messageError.joined(separator: ", ")
                        failure(messages)
                    } else {
                        failure(generateRandomError())
                    }
                } catch _ {
                    failure(generateRandomError())
                }
            }
    }
        
    }
    
    
    class func LogupApi(image:UIImage,is_creator:String,name:String,email:String,pass:String,success: @escaping (logInModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/singup/"
        let parameterDictionary = ["name":name,"email":email,"username" : email, "password":pass,"is_creator":is_creator]
        AF.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(is_creator.data(using: .utf8)!,
                withName: "is_creator")
            multipartFormData.append(name.data(using: .utf8)!,
                withName: "name")
            multipartFormData.append(email.data(using: .utf8)!,
                withName: "email")
            multipartFormData.append(email.data(using: .utf8)!,
                withName: "username")
            multipartFormData.append(pass.data(using: .utf8)!,
                withName: "password")
            
            
            if image != nil {
                let imageData = image.jpegData(compressionQuality: 0.4)
                if imageData != nil {
                    multipartFormData.append(imageData!, withName: "image", fileName: "photo.jpg", mimeType: "image/png")
                }
                
            }
            
        },
//                         usingThreshold: UInt64.init(),
           to: APIEnvironment.baseURL + url,
           method: .post,
                  headers: APIManager.requestHeader()).response { (response) in
            
            if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                guard let callback = response.data else {
                    failure(generateRandomError())
                    return
                }
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                print(responseString)
                
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode(logInModel.self, from: callback)
                        success(decoded)
                    } catch _ {
                        failure(generateRandomError())
                    }
                }
                print(200)
            } else if response.response?.statusCode == 401 {
                failure(generateRandomError())
            }else if response.response?.statusCode == 202 {
                guard let callback = response.data else {
                    failure(generateRandomError())
                    return
                }
                let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                print(responseString)
                
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode(logInModel.self, from: callback)
                        success(decoded)
                    } catch _ {
                        failure(generateRandomError())
                    }
                }
            }
            else {
                print("else")
                guard let callbackError = response.data else {
                    failure(generateRandomError())
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(APIError.self, from: callbackError)
                    if let messageError = decoded.data?.errors?.messages, let errorCode = decoded.statusCode {
                        let messages = messageError.joined(separator: ", ")
                        failure(messages)
                    } else {
                        failure(generateRandomError())
                    }
                } catch _ {
                    failure(generateRandomError())
                }
            }
    }
        
    }
    
    class func LogOutApi(success: @escaping (logInModel) -> (), failure: @escaping (String) -> ()) {
        let url = "api/logout/"
//        let parameterDictionary = [:]
        APIManager.request(url, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: APIManager.requestHeaderWithToken()) { response in
            do {
                let decoded = try JSONDecoder().decode(logInModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
    
    class func PasswordResetApi(email:String,success: @escaping (logInModel) -> (), failure: @escaping (String) -> ()) {
        let url = "reset-link/"
        let parameterDictionary = ["email":email]
        APIManager.request(url, method: .post, parameters: parameterDictionary, encoding: JSONEncoding.default, headers: APIManager.requestHeader()) { response in
            do {
                let decoded = try JSONDecoder().decode(logInModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
    
    
    class func prayerTimesWithCoord(lon:String,lat:String,success: @escaping (prayerTimeModel) -> (), failure: @escaping (String) -> ()) {
    
//        "ApiConstant.timesApi+"?latitude=\(lat)&longitude=\(lon)&method=2&month=4&year=2017"
        if let monthInt = Calendar.current.dateComponents([.month], from: Date()).month {
//            let monthStr = Calendar.current.monthSymbols[monthInt-1]
            print(monthInt) // 4
//            print(monthStr) // April
            let method = UserDefaults.standard.integer(forKey: K.Keys.calculationMethod)
        
        APIManager.requestWithUrl("https://api.aladhan.com/v1/calendar?latitude=\(lat)&longitude=\(lon)&method=\(method)&month=\(monthInt)", method: .get, parameters: [:], encoding: URLEncoding.default, headers: APIManager.requestHeader()) { response in
            do {
                let decoded = try JSONDecoder().decode(prayerTimeModel.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        }
    }
    class func prayerTimesWithCity(city:String,country:String,success: @escaping (prayerTimeModel2) -> (), failure: @escaping (String) -> ()) {
    
//        "ApiConstant.timesApi+"?latitude=\(lat)&longitude=\(lon)&method=2&month=4&year=2017"
        if let monthInt = Calendar.current.dateComponents([.month], from: Date()).month {
//            let monthStr = Calendar.current.monthSymbols[monthInt-1]
            print(monthInt,"dsdsd") // 4
//            print(monthStr) // April
        }
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
        let dateTomorrow = Calendar.current.date(from: tomorrow)!
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let tomDAte = inputFormatter.string(from: dateTomorrow)
        let method = UserDefaults.standard.integer(forKey: K.Keys.calculationMethod)
        print(method)
        
        APIManager.requestWithUrl("https://api.aladhan.com/v1/timingsByAddress/\(tomDAte)?address=\(city),\(country)&method=\(method)", method: .get, parameters: [:], encoding: URLEncoding.default, headers: APIManager.requestHeader()) { response in
            do {
                let decoded = try JSONDecoder().decode(prayerTimeModel2.self, from: response)
                success(decoded)
            } catch _ {
                failure(APIManager.generateRandomError())
            }
        } failure: { error, errorCode in
            failure(APIManager.generateRandomError())
        }
        
    }
}
