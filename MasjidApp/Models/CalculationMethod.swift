//
//  CalculationMethod.swift
//  Salli
//
//  Created by Omar Khodr on 7/16/20.
//  Copyright © 2020 Omar Khodr. All rights reserved.
//

import Foundation

class CalculationMethod {
    let name: String
    var selected: Bool
    
    init(name: String) {
        self.name = name
        selected = false
    }
}
struct prayerTimeModel: Codable {
    let status: String?
    let data: [dataTime]?
}

struct dataTime: Codable {
    let timings: Timings
}

struct prayerTimeModel2: Codable {
    let status: String?
    let data: dataTime?
}

struct dataTime2: Codable {
    let timings: Timings
}
struct APIError: Codable {
    let statusCode: Int?
    let data: ErrosClass?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct ErrosClass: Codable {
    let errors: Errors?
}

struct Errors: Codable {
    let code: String?
    let messages: [String]?
}


struct logInModel: Codable {
    let success:Bool
    let message:String?
    let token: String?
    let user: userData?
}

struct sendPushModel: Codable {
    let success:Bool
    let message:String?
    let data: sendPushDataModel?
}
struct sendPushDataModel: Codable {
    let recipients: Int
}

struct userData: Codable {
    let image: String?
    let email: String
    let is_creator: Bool?
}

struct MosquesModel: Codable {
    let success:Bool
    let message: String?
    let data: [MosquesData]?
}

struct TimeZoneModel: Codable {
    let success:Bool
    let time_zone: String?
    let country: String?
}

struct DayInfoModel: Codable {
    let data: DayInfoDataModel?
}

struct DayInfoDataModel: Codable {
    let timings: DayInfoTimingModel?
}

struct DayInfoTimingModel: Codable {
    let Sunset: String?
}
struct MosquesHomeModel: Codable {
    let success:Bool
    let message: String?
    var data: MosquesHomeData?
}
struct MosquesHomeData: Codable {
    let next:String?
    let previous:String?
    var results:[MosquesData]?
}
struct MosquesData: Codable {
    let id:Int
    let mosque_name: String
    let mosque_icon: String?
    let is_add_fav: Bool
    let Fajr: String?
    let Dhuhr: String?
    let Asr: String?
    let Maghrib: String?
    let Isha: String?
    let city: String?
    let state: String?
    let country: String?
}

struct schUpdModel: Codable {
    let success:Bool
    let message: String?
    let data: [schUpdDAta]?
}
struct schUpdDAta: Codable {
    let id:Int
    let name: String?
    let update_date:String?
    let Fajr: String?
    let Dhuhr: String?
    let Asr: String?
    let Maghrib: String?
    let Isha: String?
    let is_expired: Bool
}

struct AddFavModel: Codable {
    let success:Bool
    let message: String
}

struct FavListModel: Codable {
    let success:Bool
    let message: String?
    let data:[FavListDataModel]
}
struct FavListDataModel: Codable {
    let id:Int
    let is_default:Bool?
    let salat_Id:[MosquesData]
}
