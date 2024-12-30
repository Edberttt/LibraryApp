//
//  Book.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//


import Foundation

struct Book: Identifiable, Decodable {
    let id: String  // SwiftUI requires `id` for Identifiable protocol
    let book_name: String
    let book_year: String
    let author_name: String
    let delete_status: String

    enum CodingKeys: String, CodingKey {
        case id = "book_id"  // Map `id` to `book_id` in the JSON response
        case book_name
        case book_year
        case author_name
        case delete_status
    }
}

