//
//  APIManager.swift
//  APIManager
//
//  Created by Amey Dalvi on 22/04/24.
//

import Foundation
import Alamofire

public class APIManagerService {
    
    static func fetchUserEmails(count: Int,completion: @escaping (_ isSuccess: Bool,_ userList: [User]?,_ page: Int?) -> Void) {
        let url = "https://reqres.in/api/users?page=\(count)"
        AF.request(url, encoding: JSONEncoding.default).responseString { response in
            switch response.result{
            case .success(let JSON):
                let responseDic = convertStringtoDict(json: JSON)
                let data = convertStringtoData(json: JSON)
                print("responseDic == \(responseDic)")
                if data == nil {
                    completion(false, nil, nil)
                }
                else {
                    let userModel = try? JSONDecoder().decode(UserModel.self, from: data!)
                    let userList = userModel?.userList ?? [User]()
                    let page = userModel?.page ?? 0
                 
                    if userList.isEmpty{
                       completion(false, nil, nil)
                    }
                    else{
                       completion(true, userList, page)
                    }
                }
               
                break
            case .failure(let error):
                completion(false, nil, nil)
                print("error \(error.responseCode ?? 0)")
            }
        }
    }
}


func convertStringtoDict(json: String) -> [String:AnyObject]?{
    if let data = json.data(using: String.Encoding.utf8){
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject]
            return json
        }
        catch{
            
        }
    }
    return nil
}

func convertStringtoData(json: String) -> Data?{
    if let data = json.data(using: String.Encoding.utf8){
        return data
    }
    else{
        return nil
    }
}
