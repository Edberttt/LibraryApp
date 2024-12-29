//
//  Loan.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import Foundation

struct Loan: Identifiable, Decodable {
    var id: String { loan_id }
    let loan_id: String
    let book_id: String
    let book_name: String  // Now you have book_name
    let author_name: String
    let member_id: String
    let member_name: String  // Now you have member_name
    let loan_date: String
    let return_date: String
}
