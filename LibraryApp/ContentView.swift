//
//  ContentView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var libraryVM: LibraryViewModel
    
    var body: some View {
        NavigationView {
            List(libraryVM.books) { book in
                VStack(alignment: .leading) {
                    Text(book.book_name)
                        .font(.headline)
                    Text(book.author_name)
                        .font(.subheadline)
                }
            }
            .onAppear {
                libraryVM.fetchBooks()
            }
            .navigationTitle("Library Catalog")
        }
    }
}

//
//#Preview {
//    ContentView()
//}

//Picker("", selection: $selectedTab) {
//    Text("Available").tag(0)
//    Text("On Loan").tag(1)
//}
//.pickerStyle(SegmentedPickerStyle())
//.frame(width: 400,height: 100)
