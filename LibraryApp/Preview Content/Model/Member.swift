//
//  MemberModel.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import Foundation

struct Member: Identifiable, Decodable {
    let id: String
    let member_name: String
    let member_phone: String
    let member_nim: String
    let member_major: String
    let delete_status: String
    
    
    enum CodingKeys: String, CodingKey {
        case id = "member_id" // Map the "id" key to "member_id"
        case member_name
        case member_phone
        case member_nim
        case member_major
        case delete_status
    }
}

