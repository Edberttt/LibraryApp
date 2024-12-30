//
//  LoanView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import SwiftUI

struct LoanView: View {
    @EnvironmentObject var libraryVM: LibraryViewModel
    @State private var showAddLoanView = false
    
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
                
                List(libraryVM.loans) { loan in
                    VStack(alignment: .leading) {
                        Text(loan.book_name)  // Book name that is loaned
                            .font(.headline)
                        Text("Loaned by: \(loan.member_name)") // Member who loaned
                            .font(.subheadline)
                        Text("Loan Date: \(loan.loan_date)") // Loan date
                            .font(.caption)
                        Text("Return Date: \(loan.return_date)") // Return date
                            .font(.caption)
                    }
                    .padding(.bottom, 10) // Added some padding for better spacing
                    
                }
                
            }
            .navigationTitle("Loans")
            .sheet(isPresented: $showAddLoanView) {
//                AddLoanView() // Present AddBookView as a modal
                AddLoanView(loanID: libraryVM.loans.count + 1)
            }
        }
    }
}
