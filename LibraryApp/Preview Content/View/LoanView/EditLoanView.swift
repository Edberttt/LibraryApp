//
//  EditLoanView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 30/12/24.
//

import SwiftUI

//struct EditLoanView: View {
//    @EnvironmentObject var bookVM: BookViewModel
//    @EnvironmentObject var memberVM: MemberViewModel
//    @EnvironmentObject var loanVM: LoanViewModel
//    @Environment(\.presentationMode) var presentationMode
//    
//    var loan: Loan
//    
//    // States for the form fields
//    @State private var loanDate: String
//    @State private var returnDate: String
//    @State private var selectedBookID: String
//    @State private var selectedMemberID: String
//    
//    // Custom initializer to set initial state
//    init(loan: Loan) {
//        self.loan = loan
//        _loanDate = State(initialValue: loan.loan_date)
//        _returnDate = State(initialValue: loan.return_date ?? "")
//        _selectedBookID = State(initialValue: loan.book_id)
//        _selectedMemberID = State(initialValue: loan.member_id)
//    }
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                // Loan Details Section
//                Section(header: Text("Loan Details")) {
//                    TextField("Loan Date", text: $loanDate)
//                        .keyboardType(.numbersAndPunctuation)
//                    TextField("Return Date", text: $returnDate)
//                        .keyboardType(.numbersAndPunctuation)
//                }
//                
//                // Book and Member Selection Section
//                Section(header: Text("Select Book and Member")) {
//                    PickerView(title: "Select Book", selection: $selectedBookID, items: bookVM.books, labelKey: \.book_name, idKey: \.id)
//                    PickerView(title: "Select Member", selection: $selectedMemberID, items: memberVM.members, labelKey: \.member_name, idKey: \.id)
//                }
//                
//                // Save Changes Button
//                Button(action: saveChanges) {
//                    Text("Save Changes")
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
//            }
//            .navigationTitle("Edit Loan")
//        }
//    }
//    
//    // Function to handle saving the loan
//    private func saveChanges() {
//        // Validate the fields
//        if loanDate.isEmpty || returnDate.isEmpty || selectedBookID.isEmpty || selectedMemberID.isEmpty {
//            print("Error: All fields are required.")
//            return
//        }
//        if let loanID = Int(loan.id) {
//            let parameters: [String: String] = [
//                "loan_id": String(loanID),
//                "book_id": selectedBookID,
//                "member_id": selectedMemberID,
//                "loan_date": loanDate,
//                "return_date": returnDate
//            ]
//            
//            // Call the editMember function
//            memberVM.editMember(parameters: parameters) { success, errorMessage in
//                if success {
//                    print("Member updated successfully.")
//                } else {
//                    print("Failed to update member: \(errorMessage ?? "Unknown error")")
//                }
//            }
//        } else {
//            print("Error: Invalid member id")
//        }
//        // Dismiss the view after saving changes
//        presentationMode.wrappedValue.dismiss()
//    }
//}
//
//// Reusable Picker View for Book and Member
//struct PickerView<Item: Identifiable, LabelKey: Hashable>: View {
//    let title: String
//    @Binding var selection: String
//    let items: [Item]
//    let labelKey: KeyPath<Item, LabelKey>
//    let idKey: KeyPath<Item, String>
//    
//    var body: some View {
//        Picker(title, selection: $selection) {
//            ForEach(items) { item in
//                Text(item[keyPath: labelKey] as! String)
//                    .tag(item[keyPath: idKey] as! String)
//            }
//        }
//        .pickerStyle(MenuPickerStyle())
//        .onAppear {
//            if let firstItem = items.first {
//                selection = firstItem[keyPath: idKey]
//            }
//        }
//    }
//}

struct EditLoanView: View {
    @EnvironmentObject var bookVM: BookViewModel
    @EnvironmentObject var memberVM: MemberViewModel
    @EnvironmentObject var loanVM: LoanViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var loan: Loan
    
    // States for the form fields
    @State private var loanDate: String
    @State private var returnDate: String
    @State private var selectedBookID: String
    @State private var selectedMemberID: String
    
    // Custom initializer to set initial state
    init(loan: Loan) {
        self.loan = loan
        _loanDate = State(initialValue: loan.loan_date)
        _returnDate = State(initialValue: loan.return_date ?? "")
        _selectedBookID = State(initialValue: loan.book_id)
        _selectedMemberID = State(initialValue: loan.member_id)
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Loan Details Section
                Section(header: Text("Loan Details")) {
                    TextField("Loan Date", text: $loanDate)
                        .keyboardType(.numbersAndPunctuation)
                    TextField("Return Date", text: $returnDate)
                        .keyboardType(.numbersAndPunctuation)
                }
                
                // Book and Member Selection Section
                Section(header: Text("Select Book and Member")) {
                    PickerView(title: "Select Book", selection: $selectedBookID, items: bookVM.books, labelKey: \.book_name, idKey: \.id)
                    PickerView(title: "Select Member", selection: $selectedMemberID, items: memberVM.members, labelKey: \.member_name, idKey: \.id)
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
        if loanDate.isEmpty || returnDate.isEmpty || selectedBookID.isEmpty || selectedMemberID.isEmpty {
            print("Error: All fields are required.")
            return
        }

        // Ensure loan ID is an integer
        if let loanID = Int(loan.id) {
            // Call the editLoan function on loanVM
            loanVM.editLoan(loanID: loanID, bookID: selectedBookID, memberID: selectedMemberID, loanDate: loanDate, returnDate: returnDate)
        } else {
            print("Error: Invalid loan ID")
        }
        
        // Dismiss the view after saving changes
        presentationMode.wrappedValue.dismiss()
    }
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
            if let firstItem = items.first {
                selection = firstItem[keyPath: idKey]
            }
        }
    }
}
