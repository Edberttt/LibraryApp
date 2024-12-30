//
//  LoanView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import SwiftUI

struct LoanView: View {
    @EnvironmentObject var loanVM: LoanViewModel
    @State private var showAddLoanView = false
    @State private var showEditLoanView = false
    @State private var selectedLoan: Loan? = nil
    @State private var selectedTab: Int = 0
    @State private var loanToDelete: Loan? = nil // To store the book to be deleted
    @State private var loanToReactive: Loan? = nil
    
    @State private var alertType: AlertType? = nil
    enum AlertType: Identifiable {
        case delete(Loan)
        case reactivate(Loan)
        
        var id: String {
            switch self {
            case .delete(let loan):
                return "delete-\(loan.id)"
            case .reactivate(let loan):
                return "reactivate-\(loan.id)"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("Ongoing").tag(0)
                    Text("Returned").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if selectedTab == 0 {
                    ScrollView{
                        VStack(alignment: .leading) {
                            ForEach(loanVM.loans.filter { $0.delete_status == "0"}, id: \.id) {loan in
                                VStack(alignment: .leading) {
                                    Text(loan.book_name)
                                        .font(.headline)
                                    Text("Loaned by: \(loan.member_name)")
                                        .font(.subheadline)
                                    Text("Loan Date: \(loan.loan_date)")
                                        .font(.caption)
                                    Text("Return Date: \(formatDate(loan.return_date))")
                                        .font(.caption)
                                    
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            selectedLoan = loan
                                            showEditLoanView = true
                                        }) {
                                            Image(systemName: "pencil") // Pencil symbol for editing
                                                .foregroundColor(.blue)
                                                .padding(8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.blue, lineWidth: 1)
                                                )
                                        }
                                        
                                        Button(action: {
                                            loanToDelete = loan
                                            alertType = .delete(loan)
                                        }) {
                                            Image(systemName: "trash") // Trash symbol for deleting
                                                .foregroundColor(.red)
                                                .padding(6)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.red, lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                                .padding()
                                Divider()
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding()
                    }
                }
                else {
                    ScrollView{
                        VStack(alignment: .leading) {
                            ForEach(loanVM.loans.filter { $0.delete_status == "1"}, id: \.id) {loan in
                                VStack(alignment: .leading) {
                                    Text(loan.book_name)
                                        .font(.headline)
                                    Text("Loaned by: \(loan.member_name)")
                                        .font(.subheadline)
                                    Text("Loan Date: \(loan.loan_date)")
                                        .font(.caption)
                                    Text("Return Date: \(loan.return_date ?? "Not Set")")
                                        .font(.caption)
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Button(action: {
                                            loanToReactive = loan
                                            alertType = .reactivate(loan)
                                        }) {
                                            Text("Reactivate")
                                                .foregroundColor(.blue)
                                                .padding(.horizontal)
                                                .padding(.vertical, 6)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.blue, lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                                .padding()
                                Divider()
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding()
                    }
                }
                
            }
            .background(.listBackground)
            
            .navigationTitle("Loans")
            .sheet(isPresented: $showAddLoanView) {
                AddLoanView(loanID: loanVM.loans.count + 1)
            }
            .sheet(item: $selectedLoan) { loan in
                EditLoanView(loan: loan)
            }
            
            .alert(item: $alertType) { alertType in
                switch alertType {
                case .delete(let loan):
                    return Alert(
                        title: Text("Loan Returned"),
                        message: Text("Are you sure you this loan has been returned? \n \(loan.book_name) loaned by \(loan.member_name)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            loanVM.deleteLoan(loanID: loan.id)
                        },
                        secondaryButton: .cancel()
                    )
                case .reactivate(let loan):
                    return Alert(
                        title: Text("Reactivate Book"),
                        message: Text("Are you sure you want to reactivate \(loan.book_name)?"),
                        primaryButton: .default(Text("Reactivate")) {
                            loanVM.reactivateDeleteLoan(loanID: loan.id)
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddLoanView.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
        }
    }
    
    private func formatDate(_ date: String?) -> String {
        guard let date = date else { return "Not Set" }
        return date // Assuming dates are already in the desired format
    }

}
