//
//  PrayerTimeManager.swift
//  Salli
//
//  Created by Omar Khodr on 5/26/20.
//  Copyright © 2020 Omar Khodr. All rights reserved.
//

import Foundation
import CoreLocation


//Handles requests and responses from the Prayer Times API to fetch the latest prayer times
//link: https://aladhan.com/prayer-times-api

class PrayerTimesManager {
    
    //takes delegate to do operations (on UI, for e.g.) when events occur, such as when prayer times are updated or when an error occurs
    var delegate: PrayerTimesManagerDelegate?
    
    let defaults = UserDefaults.standard
    
    //called from CLLocationManager's didUpdateLocation() method where the current location's latitude and longitude are taken to complete the URL to perform the GET request from the
    func fetchTimings(coordinates location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        //completes URL with latitude and longitude and the 4th method of prayer times calculations, currently hardcoded as 4 - Umm Al-Qura University, Makkah
        let method = defaults.integer(forKey: K.Keys.calculationMethod)
        let urlString = "\(K.prayerTimesURL)timings?latitude=\(latitude)&longitude=\(longitude)&method=\(method)"
        //perform reverse geocode location operation to get user-friendly location representation (i.e. city, state, country) from coordinates.
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: Locale.init(identifier: "lang".localized)) { (placemarksArray, error) in
            if let error = error {
                self.delegate?.didFailReverseGeolocation(self, error: error)
            } else {
                if let placemark = placemarksArray?.last {
                    var city = ""
                    if let ct = placemark.locality {
                        city = "\(ct), "
                    }
                    var state = ""
                    if let st = placemark.administrativeArea {
                        state = "\(st), "
                    }
                    var country = ""
                    if let cot = placemark.country {
                        country = "\(cot)"
                    }
                    let locationStr = "\(city)\(state)\(country)"
                    self.performRequest(with: urlString, locationString: locationStr)
                }
            }
        }
    }
    
    func fetchTimings(city: String, country: String) {
        let method = defaults.integer(forKey: K.Keys.calculationMethod)
        let cityURL = URLify(city)
        let countryURL = URLify(country)
        let urlString = "\(K.prayerTimesURL)timingsByCity?city=\(cityURL)&country=\(countryURL)&method=\(method)"
        let locationStr = "\(city), \(country)"
        self.performRequest(with: urlString, locationString: locationStr)
    }
    
    func performRequest(with urlString: String, locationString: String) {
        //1. Creating URL from string
        if let url = URL(string: urlString) {
            //2. Creating URLSession
            let session = URLSession(configuration: .default)
            //3. Adding task to the session with the newly created URL along with completion handler method to handle success or failure of GET request
            let task = session.dataTask(with: url) { (data, response, error) in
                let outputStr  = String(data: data!, encoding: String.Encoding.utf8) as String?
//                print(outputStr)
                if let error = error {
                    self.delegate?.didFailWithError(self, error: error)
                    return
                }
                if let safeData = data {
                    
                    //build model by parsing JSON data and adding location string, then pass that model to the delegate
                    if let model = self.buildModel(data: safeData, location: locationString) {
                        
                        self.delegate?.didUpdatePrayerTimes(self, model)
                    }
                    
                }
            }
            //4. Starting the task (it says resume() but it actually just starts it)
            task.resume()
        }
    }
    
    func buildModel(data prayerTimesData: Foundation.Data, location: String) -> PrayerTimesModel? {
        //initializes decoder
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PrayerTimesData.self, from: prayerTimesData)
            //create model from decoded data of type PrayerTimesData to properly format the dates from strings to actual date types
            let times: [String] = [
                decodedData.data.timings.Fajr,
                decodedData.data.timings.Sunrise,
                decodedData.data.timings.Dhuhr,
                decodedData.data.timings.Asr,
                decodedData.data.timings.Maghrib,
                decodedData.data.timings.Isha,
                decodedData.data.timings.Midnight,
                decodedData.data.timings.Imsak
            ]
            let latitude = decodedData.data.meta.latitude
            let longitude = decodedData.data.meta.longitude
            let model = PrayerTimesModel(stringArray: times, location: location, latitude: latitude, longitude: longitude)
            //return the model for it to be passed as argument to didUpdatePrayerTimes() to be used by the delegate
            return model
            
        }
        catch {
            //in case decoding fails (usually either bad format of the JSON response or bad format of data class)
            print("Failed to build model: \(error)")
            delegate?.didFailWithError(self, error: error)
            return nil
        }
        
    }
    
    func URLify(_ data: String) -> String {
        var result: String = ""
        for char in data {
            if char != " " {
                result.append(char)
            } else {
                result.append("%20")
            }
        }
        return result
    }
    
    
}
