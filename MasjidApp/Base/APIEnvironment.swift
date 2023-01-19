//
//  APIEnvironment.swift
//  MasjidApp
//
//  Created by Sohel Rana on 13/10/22.
//

import Foundation

enum APIEnvironment {
    case staging
    case production
}

extension APIEnvironment {
    
    static var baseURL = "https://masjidappword.herokuapp.com/"
    
}
