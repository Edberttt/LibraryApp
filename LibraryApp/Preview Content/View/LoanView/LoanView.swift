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
    
    var body: some View {
        NavigationView {
            VStack {
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
                
                List(loanVM.loans) { loan in
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
                        }
                    }
                    .padding(.bottom, 10)
                }
            }
            .navigationTitle("Loans")
            .sheet(isPresented: $showAddLoanView) {
                AddLoanView(loanID: loanVM.loans.count + 1)
            }
            .sheet(item: $selectedLoan) { loan in
                EditLoanView(loan: loan)
            }
        }
    }
}
