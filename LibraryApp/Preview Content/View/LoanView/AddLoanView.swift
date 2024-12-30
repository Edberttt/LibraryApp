//
//  AddLoanView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import SwiftUI

struct AddLoanView: View {
    @EnvironmentObject var libraryVM: LibraryViewModel
    @Environment(\.dismiss) var dismiss

    @State private var loanID: String = ""
    @State private var selectedBookID: String = ""
    @State private var selectedMemberID: String = ""
    @State private var loanDate: String = ""
    @State private var returnDate: String = ""
    

    var body: some View {
        NavigationView {
            Form {
                // Loan ID
//                TextField("Loan ID", text: $loanID)

                // Book Picker
                Picker("Select Book", selection: $selectedBookID) {
                    ForEach(libraryVM.books) { book in
                        Text(book.book_name) // Display book name
                            .tag(book.id)    // `book.id` is a String, matching `selectedBookID`
                    }
                }
                .pickerStyle(MenuPickerStyle())

                // Member Picker
                Picker("Select Member", selection: $selectedMemberID) {
                    ForEach(libraryVM.members){ member in
                        Text(member.member_name)
                            .tag(member.id)
                    }
                }

                // Loan Date
                TextField("Loan Date (YYYY-MM-DD)", text: $loanDate)

                // Return Date
                TextField("Return Date (YYYY-MM-DD, optional)", text: $returnDate)

                // Add Loan Button
                Button("Add Loan") {
                    guard !loanID.isEmpty, !selectedBookID.isEmpty, !selectedMemberID.isEmpty, !loanDate.isEmpty else {
                        print("All fields except Return Date are required")
                        return
                    }

                    libraryVM.addLoan(
                        loanID: loanID,
                        bookID: selectedBookID,
                        memberID: selectedMemberID,
                        loanDate: loanDate,
                        returnDate: returnDate.isEmpty ? nil : returnDate
                    )
                    dismiss()
                }
            }
            .navigationTitle("Add Loan")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
