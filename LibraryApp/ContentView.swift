//
//  ContentView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bookVM: BookViewModel
    @EnvironmentObject var loanVM: LoanViewModel
    @EnvironmentObject var memberVM: MemberViewModel
    
    
    var body: some View {
        TabView {
            // Books Tab
            BooksView()
                .tabItem {
                    Label("Books", systemImage: "book.fill")
                }
            
            LoanView()
                .tabItem {
                    Label("Loans", systemImage: "text.document")
                }
            
            // Members Tab
            MembersView()
                .tabItem {
                    Label("Members", systemImage: "person.2.fill")
                }
        }
        .onAppear {
            bookVM.fetchBooks()
            memberVM.fetchMembers()
            loanVM.fetchLoans()
        }
    }
}

// MARK: - Preview
//#Preview {
//    ContentView()
//        .environmentObject(LibraryViewModel())
//}
