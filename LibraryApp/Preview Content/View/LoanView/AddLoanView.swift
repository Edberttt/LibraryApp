//
//  AddLoanView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import SwiftUI

struct AddLoanView: View {
    @EnvironmentObject var bookVM: BookViewModel
    @EnvironmentObject var memberVM: MemberViewModel
    @EnvironmentObject var loanVM: LoanViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedBookID: String = ""
    @State private var selectedMemberID: String = ""
    @State private var loanDate: String = ""
    @State private var returnDate: String = ""
//    @State private var loanID: Int = 3 // Example: auto-generate or fetch next ID
    
    let loanID: Int
    
    var body: some View {
        NavigationView {
            Form {
                // Book Picker
                Picker("Select Book", selection: $selectedBookID) {
                    ForEach(bookVM.books, id: \.id) { book in
                        Text(book.book_name).tag(book.id) // Ensure valid tags
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onAppear {
                    if let firstBook = bookVM.books.first {
                        selectedBookID = firstBook.id
                    }
                }

                // Member Picker
                Picker("Select Member", selection: $selectedMemberID) {
                    ForEach(memberVM.members, id: \.id) { member in
                        Text(member.member_name).tag(member.id) // Ensure valid tags
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onAppear {
                    if let firstMember = memberVM.members.first {
                        selectedMemberID = firstMember.id
                    }
                }
                
                // Loan Date
                TextField("Loan Date (YYYY-MM-DD)", text: $loanDate)
                    .keyboardType(.numbersAndPunctuation)
                    .onChange(of: loanDate) { newValue in
                        if !isValidDate(newValue) {
                            print("Invalid date format. Use YYYY-MM-DD.")
                        }
                    }

                // Return Date
                TextField("Return Date (YYYY-MM-DD, optional)", text: $returnDate)
                    .keyboardType(.numbersAndPunctuation)
                    .onChange(of: returnDate) { newValue in
                        if !newValue.isEmpty && !isValidDate(newValue) {
                            print("Invalid date format for Return Date. Use YYYY-MM-DD.")
                        }
                    }

                // Add Loan Button
                Button("Add Loan") {
                    guard !selectedBookID.isEmpty,
                          !selectedMemberID.isEmpty,
                          !loanDate.isEmpty,
                          isValidDate(loanDate) else {
                        print("All fields except Return Date are required, and Loan Date must be valid.")
                        return
                    }

                    loanVM.addLoan(
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

    // Helper function to validate date format
    func isValidDate(_ date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date) != nil
    }
}
