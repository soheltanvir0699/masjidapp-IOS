
//
//  ApiManager.swift
//  ShadyPinesRadio
//
//  Created by Mujahid on 2/23/21.
//  Copyright © 2021 ASN GROUP LLC. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


struct APIManager {
    
    static var manager: Session!
    
    /// GET FROM API
    ///
    /// - Parameters:
    ///   - url: URL API
    ///   - method: methods
    ///   - parameters: parameters
    ///   - encoding: encoding
    ///   - headers: headers
    ///   - completion: completion
    ///   - failure: failure
    static func request(_ url: String, method: HTTPMethod, parameters: Parameters, encoding: ParameterEncoding, headers: HTTPHeaders, completion: @escaping (_ response: Data) ->(), failure: @escaping (_ error: String, _ errorCode: Int) -> ()) {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        
        
        manager = Alamofire.Session(configuration: configuration)
        
        let apiURL = APIEnvironment.baseURL + url
        debugPrint("-- URL API: \(apiURL), \n\n-- headers: \(headers), \n\n-- Parameters: \(parameters)")
        
        print(parameters)
       
        
        AF.request(
            apiURL,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers).response { (response) in
                    
                debugPrint("--\n \n CALLBACK RESPONSE: \(response)")
                print(response.response?.statusCode)
//                print(headers)
//                print(constant.AccessToken)
                print(response.response)
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                        guard let callback = response.data else {
                            failure(self.generateRandomError(), 200)
                            return
                        }
                        let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                        print(responseString)
                        DispatchQueue.main.async {
                            completion(callback)
                        }
                    } else if response.response?.statusCode == 401 {
                        failure(self.generateRandomError(), 401)
                    }else if response.response?.statusCode == 202 {
                        guard let callback = response.data else {
                            failure(self.generateRandomError(), 202)
                            return
                        }
                        let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                        
                        DispatchQueue.main.async {
                            completion(callback)
                        }
                    }
                    else {
                        print(response.error.debugDescription)
                        print("else")
                        guard let callbackError = response.data else {
                            failure(self.generateRandomError(), response.response?.statusCode ?? 500)
                            return
                        }
                        
                        do {
                            let decoded = try JSONDecoder().decode(APIError.self, from: callbackError)
                            if let messageError = decoded.data?.errors?.messages, let errorCode = decoded.statusCode {
                                let messages = messageError.joined(separator: ", ")
                                failure(messages, errorCode)
                            } else {
                                failure(APIManager.generateRandomError(), response.response!.statusCode)
                            }
                        } catch _ {
                            failure(APIManager.generateRandomError(), response.response!.statusCode)
                        }
                    }
                    
                   manager.session.finishTasksAndInvalidate()
        }
        
    }
    
    static func requestWithUrl(_ url: String, method: HTTPMethod, parameters: Parameters, encoding: ParameterEncoding, headers: HTTPHeaders, completion: @escaping (_ response: Data) ->(), failure: @escaping (_ error: String, _ errorCode: Int) -> ()) {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        
        
        manager = Alamofire.Session(configuration: configuration)
        
        let apiURL = url
        debugPrint("-- URL API: \(apiURL), \n\n-- headers: \(headers), \n\n-- Parameters: \(parameters)")
        
        print(parameters)
       
        
        AF.request(
            apiURL,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers).response { (response) in
                    
                print("--\n \n CALLBACK RESPONSE: \(response)")
                print(response.response?.statusCode)
//                print(headers)
//                print(constant.AccessToken)
                print(response.response)
            
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                        guard let callback = response.data else {
                            failure(self.generateRandomError(), 200)
                            return
                        }
                        let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                        print("response string: ",responseString)
                        DispatchQueue.main.async {
                            completion(callback)
                        }
                    } else if response.response?.statusCode == 401 {
                        failure(self.generateRandomError(), 401)
                    }else if response.response?.statusCode == 202 {
                        guard let callback = response.data else {
                            failure(self.generateRandomError(), 202)
                            return
                        }
                        let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                        
                        DispatchQueue.main.async {
                            completion(callback)
                        }
                    }
                    else {
                        print("else")
                        guard let callbackError = response.data else {
                            failure(self.generateRandomError(), response.response?.statusCode ?? 500)
                            return
                        }
                        
                        do {
                            let decoded = try JSONDecoder().decode(APIError.self, from: callbackError)
                            if let messageError = decoded.data?.errors?.messages, let errorCode = decoded.statusCode {
                                let messages = messageError.joined(separator: ", ")
                                failure(messages, errorCode)
                            } else {
                                failure(APIManager.generateRandomError(), response.response!.statusCode)
                            }
                        } catch _ {
                            failure(APIManager.generateRandomError(), response.response!.statusCode)
                        }
                    }
                    
                   manager.session.finishTasksAndInvalidate()
        }
        
    }
    static func upload(_ url: String, headers: HTTPHeaders, parameters: [String: Any], images: [String: UIImage], completion: @escaping (_ response: Data) ->(), failure: @escaping (_ error: String) -> ()) {

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary

        manager = Alamofire.Session(configuration: configuration)

        let apiURL = APIEnvironment.baseURL + url
        debugPrint("URL API: \(apiURL)")
        
       

//        AF.upload(multipartFormData: { partData in
//
//            // parameters
//            for (key, value) in parameters {
//                partData.append(key.data(using: .utf8)!, withName: value as! String)
//            }
//
//            if !images.isEmpty {
//                for (key, value) in images {
//                    let imageData = value.jpegData(compressionQuality: 0.4)
//                    partData.append(imageData!, withName: key)
//                }
//            }
//
//
//        },
//                       to: apiURL, usingThreshold: UInt64.init(),
//       method: .post,
//       headers: APIManager.requestHeader()) { encodingResult in
//
//            switch encodingResult {
//            case .success(let upload, _, _):
//                upload.responseString(
//                    queue: DispatchQueue.main,
//                    encoding: .utf8,
//                    completionHandler: { response in
//
//                        debugPrint("RESPONSE UPLOAD: \(response)")
//
//                        if response.response?.statusCode == 200 {
//                            guard let callback = response.data else {
//                                failure(self.generateRandomError())
//                                return
//                            }
//                            completion(callback)
//
//                        } else if response.response?.statusCode == 401 {
//                            StopAppBaseView.logoutApp()
//                        } else {
//                            guard let callbackError = response.data else {
//                                return
//                            }
//
//                            do {
//                                let decoded = try JSONDecoder().decode(
//                                    APIError.self, from: callbackError)
//                                if let messageError = decoded.data?.errors?.messages {
//                                    let messages = messageError.joined(separator: ", ")
//                                    failure(messages)
//                                } else {
//                                    failure(APIManager.generateRandomError())
//                                }
//                            } catch _ {
//                                failure(APIManager.generateRandomError())
//                            }
//                        }
//
//                        return
//
//                })
//            case .failure(let encodingError):
//
//                debugPrint(encodingError)
//            }
//
//        }

    }


    /// GENERATE RANDOM ERROR
    ///
    /// - Returns: string error randoms
    static func generateRandomError() -> String {
        return "Oops. Please try again."
    }

    static func requestHeader() -> HTTPHeaders {
            return [
                "Content-Type": "application/json",
                "Accept":"application/json",
            ]
        
    }
    static func requestHeaderWithToken() -> HTTPHeaders {
            return [
                "Content-Type": "application/json",
                "Accept":"application/json",
                "Authorization": "Token "+constant.authToken
            ]
        
    }
    
}

