//
//  BookView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import SwiftUI

struct BooksView: View {
    @EnvironmentObject var bookVM: BookViewModel
    @EnvironmentObject var loanVM: LoanViewModel
    @State private var selectedTab: Int = 0
    @State private var showAddBookView: Bool = false // State to control the modal
    @State private var showingAddLoan = false
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("Available").tag(0)
                    Text("On Loan").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedTab == 0 {
                    HStack {
                        Spacer()
                        Button(action: {
                            showAddBookView.toggle() // Show the modal
                        }) {
                            Text("Add Book")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding(.trailing, 16)
                    }

                    List(bookVM.books) { book in
                        VStack(alignment: .leading) {
                            Text(book.book_name)
                                .font(.headline)
                            Text(book.author_name)
                                .font(.subheadline)
                        }
                    }
                } else {
                    List(loanVM.loans) { loan in
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
            }
            .navigationTitle("Books")
            .sheet(isPresented: $showAddBookView) {
                AddBookView() // Present AddBookView as a modal
            }
        }
    }
}


// MARK: - Preview
//#Preview {
//    BooksView()
//        .environmentObject(LibraryViewModel())
//}
