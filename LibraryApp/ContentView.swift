//
//  ContentView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var libraryVM: LibraryViewModel

    var body: some View {
        TabView {
            // Books Tab
            BooksView()
                .tabItem {
                    Label("Books", systemImage: "book.fill")
                }
            
            // Members Tab
            MembersView()
                .tabItem {
                    Label("Members", systemImage: "person.2.fill")
                }
        }
        .onAppear {
            libraryVM.fetchBooks()
            libraryVM.fetchMembers()
            libraryVM.fetchLoans()
        }
    }
}

// MARK: - Preview
//#Preview {
//    ContentView()
//        .environmentObject(LibraryViewModel())
//}
