//
//  UserModel.swift
//  APIManager
//
//  Created by Amey Dalvi on 22/04/24.
//


import Foundation

// MARK: - UserModel
public struct UserModel: Codable {
    var page, perPage, total, totalPages: Int?
    var userList: [User]?
    var support: Support?

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case perPage = "per_page"
        case total = "total"
        case totalPages = "total_pages"
        case userList = "data"
        case support = "support"
    }
}
// MARK: - Datum
public struct User: Codable {
    var id: Int?
    var email, firstName, lastName: String?
    var avatar: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "avatar"
    }
}

extension User{
    func toDict() -> [String:Any]
    {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try? encoder.encode(self)
        let dict = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String:Any]
        return dict ?? [:]
    }
    
}


// MARK: - Support
public struct Support: Codable {
    var url: String?
    var text: String?
}
