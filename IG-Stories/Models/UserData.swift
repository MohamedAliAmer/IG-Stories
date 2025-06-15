//
//  UserData.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import Foundation

struct UserPagesContainer: Decodable {
    let pages: [UserPage]
}

struct UserPage: Decodable {
    let users: [UserJSON]
}

struct UserJSON: Decodable, Identifiable {
    let id: Int
    let name: String
    let profilePictureURL: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePictureURL = "profile_picture_url"
    }
}
