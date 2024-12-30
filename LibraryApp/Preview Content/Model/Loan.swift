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
    let book_name: String  
    let member_id: String
    let member_name: String
    let loan_date: String
    let return_date: String?
}
