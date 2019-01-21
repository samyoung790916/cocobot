//
//  APIService.swift
//  cocobot
//
//  Created by samyoung79 on 02/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import Foundation
import Alamofire


struct URLPath{
    static let shared = URLPath()
    static let baseURLstring = "http://35.200.206.16:8080/"
    static let baseURL = URL(string: baseURLstring)
}


class APIService{
    static let shared = APIService()
    private init(){}
    
    enum communitcation_result{
        case success
        case fail
    }
    
    var headers:[String:String] = {
        var headers = [String:String]()
        return headers
    }()
    
    typealias completion = (_ result:[String:Any]?, _ error: Error?) -> Void
    func postWithImages(url: URL, imageDataArray: [Data], parameters: [String:Any]?, completionHandler: @escaping completion){
    }
    
    typealias resultCompletion = (communitcation_result, [String: Any]) ->Void
    func post(url: String, string: String?, resultCompletion completion: @escaping resultCompletion){
        
        let request_url = URL(string:"\(URLPath.baseURLstring)\(url)")!
        var requset = URLRequest(url: request_url)
        
        if string != nil{
            
            let jsonData = string!.data(using: .utf8)!
            var json = NSData()
            
            do{
                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as? [Dictionary<String,Any>]{
                    do{
                        json = try JSONSerialization.data(withJSONObject: jsonArray[0], options: .prettyPrinted) as NSData
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }catch let error as NSError{
                print(error)
            }
            
            requset.httpMethod = "POST"
            requset.setValue("\(json.length)",   forHTTPHeaderField: "Content-Length")
            requset.setValue("application/json", forHTTPHeaderField: "Content-Type")
            requset.httpBody = json as Data
        }
        else{
            requset.httpMethod = "GET"
        }
        
        URLSession.shared.dataTask(with: requset) { (data, response, error) in
            if error != nil{
                return
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]
                    let returnvalue : communitcation_result
                    
                    if let result = json!["status"] as? String, result == "ok"{
                        returnvalue = .success
                    }else{
                        returnvalue = .fail
                    }
    
                    DispatchQueue.main.async {
                        completion(returnvalue, json!)
                    }
                }catch{
                    print(error)
                }
            }
        }.resume()
    }
    
    
    
    
    typealias binaryCompletion = (communitcation_result) -> Void
    func post_binary_reqeust(url: URL, parameters: String?, binaryCompletion completion: @escaping binaryCompletion){
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let values = parameters{
            request.httpBody = values.data(using: .utf8)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil{
                print(error!)
                return
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]
                    let returnvalue : communitcation_result
                    
                    if let result = json!["return"] as? String, result == "true"{
                        returnvalue = .success
                    }else{
                        returnvalue = .fail
                    }
                    
                    DispatchQueue.main.async {
                        completion(returnvalue)
                    }
                }catch{
                    print(error)
                }
            }
        }.resume()
    }
    
    
    typealias completedClosure = ([String:Any]) -> Void
    func get(url:URL, completionHandler completion: @escaping completedClosure){
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil{
                return
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]
                    DispatchQueue.main.async {
                        completion(json!)
                    }
                }catch{
                    print(error)
                }
                
            }
        }.resume()
    }
    
    typealias arrayofDictCompletion = ([[String:Any]]) ->Void
    func postArrayofDict(url: URL, parameters: String?, completionHandler completion: @escaping arrayofDictCompletion){
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let values = parameters{
            request.httpBody = values.data(using: .utf8)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil{
                print(error!)
                return
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: Any]]
                    DispatchQueue.main.async {
                        completion(json!)
                    }
                }catch{
                    print(error)
                }
            }
        }.resume()
        
    }
}
