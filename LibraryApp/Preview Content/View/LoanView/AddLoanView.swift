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
    @State private var loanDate: Date = Date() // Date type for loan date
    @State private var returnDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date() // Default +7 days
    let loanID: Int

    // Filtered active books
    var activeBooks: [Book] {
        bookVM.books.filter { $0.delete_status == "0" } // Only books with delete_status == "0"
    }

    // Filtered active members
    var activeMembers: [Member] {
        memberVM.members.filter { $0.delete_status == "0" } // Only members with delete_status == "0"
    }

    var body: some View {
        NavigationView {
            Form {
                // Book Picker
                Picker("Select Book", selection: $selectedBookID) {
                    ForEach(activeBooks, id: \.id) { book in
                        Text(book.book_name).tag(book.id)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onAppear {
                    if let firstBook = activeBooks.first {
                        selectedBookID = firstBook.id
                    }
                }

                // Member Picker
                Picker("Select Member", selection: $selectedMemberID) {
                    ForEach(activeMembers, id: \.id) { member in
                        Text(member.member_name).tag(member.id)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onAppear {
                    if let firstMember = activeMembers.first {
                        selectedMemberID = firstMember.id
                    }
                }

                // Loan Date Picker
                DatePicker("Loan Date", selection: $loanDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .onChange(of: loanDate) { newLoanDate in
                        // Ensure returnDate is at least 7 days after loanDate
                        if returnDate < newLoanDate {
                            returnDate = Calendar.current.date(byAdding: .day, value: 7, to: newLoanDate) ?? newLoanDate
                        }
                    }

                // Return Date Picker
                DatePicker("Return Date", selection: $returnDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .onChange(of: returnDate) { newReturnDate in
                        // If returnDate is set earlier than loanDate, adjust loanDate
                        if newReturnDate < loanDate {
                            loanDate = newReturnDate
                        }
                    }

                // Add Loan Button
                Button("Add Loan") {
                    let loanDateString = formatDate(loanDate)
                    let returnDateString = formatDate(returnDate)

                    guard !selectedBookID.isEmpty,
                          !selectedMemberID.isEmpty else {
                        print("Please select a book and a member.")
                        return
                    }

                    loanVM.addLoan(
                        loanID: loanID,
                        bookID: selectedBookID,
                        memberID: selectedMemberID,
                        loanDate: loanDateString,
                        returnDate: returnDateString
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

    // Helper function to format Date to "yyyy-MM-dd"
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
