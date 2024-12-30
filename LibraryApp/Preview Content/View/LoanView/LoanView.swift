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
                .padding()
                
                Button(action: {
                    showAddLoanView.toggle() // Show the modal
                }) {
                    Text("Add Loan")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.trailing, 16)

                if selectedTab == 0 {
                    List(loanVM.loans.filter { $0.delete_status == "0" }) { loan in
                        VStack(alignment: .leading) {
                            Text(loan.book_name)
                                .font(.headline)
                            Text("Loaned by: \(loan.member_name)")
                                .font(.subheadline)
                            Text("Loan Date: \(loan.loan_date)")
                                .font(.caption)
                            Text("Return Date: \(loan.return_date)")
                                .font(.caption)
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    selectedLoan = loan
                                }) {
                                    Text("Edit")
                                        .foregroundColor(.blue)
                                }
                                
                                Button(action: {
                                    loanToDelete = loan
                                    alertType = .delete(loan)
                                }) {
                                    Text("Returned")
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
                        .padding(.bottom, 10)
                    }
                }
                else {
                    List(loanVM.loans.filter { $0.delete_status == "1" }) { loan in
                        VStack(alignment: .leading) {
                            Text(loan.book_name)
                                .font(.headline)
                            Text("Loaned by: \(loan.member_name)")
                                .font(.subheadline)
                            Text("Loan Date: \(loan.loan_date)")
                                .font(.caption)
                            Text("Return Date: \(loan.return_date)")
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
                        .padding(.bottom, 10)
                    }
                }
                
            }
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
                        primaryButton: .destructive(Text("Reactivate")) {
                            loanVM.reactivateDeleteLoan(loanID: loan.id)
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
}
