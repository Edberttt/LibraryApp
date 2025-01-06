//
//  EditLoanView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 30/12/24.
//

import SwiftUI

struct EditLoanView: View {
    @EnvironmentObject var bookVM: BookViewModel
    @EnvironmentObject var memberVM: MemberViewModel
    @EnvironmentObject var loanVM: LoanViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var loan: Loan
    
    var activeBooks: [Book] {
        bookVM.books.filter { $0.delete_status == "0" } // Only books with delete_status == "0"
    }

    // Filtered active members
    var activeMembers: [Member] {
        memberVM.members.filter { $0.delete_status == "0" } // Only members with delete_status == "0"
    }
    
    // States for the form fields
    @State private var loanDate: Date
    @State private var returnDate: Date
    @State private var selectedBookID: String
    @State private var selectedMemberID: String
    
    // Custom initializer to set initial state
    init(loan: Loan) {
        self.loan = loan
        _loanDate = State(initialValue: Self.dateFormatter.date(from: loan.loan_date) ?? Date())
        _returnDate = State(initialValue: Self.dateFormatter.date(from: loan.return_date ?? "") ?? Calendar.current.date(byAdding: .day, value: 7, to: Date())!)
        _selectedBookID = State(initialValue: loan.book_id)
        _selectedMemberID = State(initialValue: loan.member_id)
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Loan Details Section
                Section(header: Text("Loan Details")) {
                    // Loan Date Picker
                    DatePicker("Loan Date", selection: $loanDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle()) // Compact style
                        .onChange(of: loanDate) { newDate in
                            // Automatically update returnDate to 7 days after loanDate
                            if newDate > returnDate {
                                returnDate = newDate
                            }
                        }
                    // Return Date Picker
                    DatePicker("Return Date", selection: $returnDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                }
                
                // Book and Member Selection Section
                Section(header: Text("Select Book and Member")) {
                    PickerView(title: "Select Book", selection: $selectedBookID, items: activeBooks, labelKey: \.book_name, idKey: \.id)
                    PickerView(title: "Select Member", selection: $selectedMemberID, items: activeMembers, labelKey: \.member_name, idKey: \.id)
                    
                }
                
                // Save Changes Button
                Button(action: saveChanges) {
                    Text("Save Changes")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Edit Loan")
        }
    }
    
    // Function to handle saving the loan
    private func saveChanges() {
        // Validate the fields
        if selectedBookID.isEmpty || selectedMemberID.isEmpty {
            print("Error: All fields are required.")
            return
        }

        // Ensure loan ID is an integer
        if let loanID = Int(loan.id) {
            // Format dates to string for saving
            let loanDateString = Self.dateFormatter.string(from: loanDate)
            let returnDateString = Self.dateFormatter.string(from: returnDate)
            
            // Call the editLoan function on loanVM
            loanVM.editLoan(
                loanID: loanID,
                bookID: selectedBookID,
                memberID: selectedMemberID,
                loanDate: loanDateString,
                returnDate: returnDateString
            )
        } else {
            print("Error: Invalid loan ID")
        }
        
        // Dismiss the view after saving changes
        presentationMode.wrappedValue.dismiss()
    }
    
    // Date Formatter
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

// Reusable Picker View for Book and Member
struct PickerView<Item: Identifiable, LabelKey: Hashable>: View {
    let title: String
    @Binding var selection: String
    let items: [Item]
    let labelKey: KeyPath<Item, LabelKey>
    let idKey: KeyPath<Item, String>
    
    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(items) { item in
                Text(item[keyPath: labelKey] as! String)
                    .tag(item[keyPath: idKey] as! String)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .onAppear {
            // Ensure the current selection is preserved if it's valid
            if !items.contains(where: { $0[keyPath: idKey] == selection }), let firstItem = items.first {
                selection = firstItem[keyPath: idKey]
            }
        }
    }
}
