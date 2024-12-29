//
//  BookView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import SwiftUI

struct BooksView: View {
    @EnvironmentObject var libraryVM: LibraryViewModel
    @State private var selectedTab: Int = 0

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
                    List(libraryVM.books) { book in
                        VStack(alignment: .leading) {
                            Text(book.book_name)
                                .font(.headline)
                            Text(book.author_name)
                                .font(.subheadline)
                        }
                    }
                } else {
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
            }
            .navigationTitle("Books")
        }
    }
}

// MARK: - Preview
//#Preview {
//    BooksView()
//        .environmentObject(LibraryViewModel())
//}
