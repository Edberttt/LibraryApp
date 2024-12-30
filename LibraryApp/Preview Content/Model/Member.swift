//
//  MemberModel.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import Foundation

struct Member: Identifiable, Decodable {
    var id: String
    var member_name: String
    var member_phone: String
    var member_nim: String
    var member_major: String
    
    
    enum CodingKeys: String, CodingKey {
        case id = "member_id" // Map the "id" key to "member_id"
        case member_name
        case member_phone
        case member_nim
        case member_major
    }
}

