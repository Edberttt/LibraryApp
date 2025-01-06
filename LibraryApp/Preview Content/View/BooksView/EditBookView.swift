//
//  EditBookView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 30/12/24.
//


import SwiftUI

struct EditBookView: View {
    @EnvironmentObject var bookVM: BookViewModel
    @Environment(\.presentationMode) var presentationMode
    var book: Book
    
    @State private var bookName: String = ""
    @State private var authorName: String = ""
    @State private var bookYear: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Book Details")) {
                    TextField("Book Name", text: $bookName)
                    TextField("Author Name", text: $authorName)
                    TextField("Book Year", text: $bookYear)
                }
                Button(action: {
                    // Check if the fields are non-empty
                    if bookName.isEmpty || authorName.isEmpty || bookYear.isEmpty {
                        print("Error: All fields are required.")
                        return
                    }
                    
                    // Convert book.id (String) to Int
                    if let bookID = Int(book.id) {
                        let parameters: [String: String] = [
                            "book_id": String(bookID),  // Pass the book_id as String
                            "book_name": bookName,
                            "author_name": authorName,
                            "book_year": bookYear
                        ]
                        bookVM.editBook(bookID: bookID, parameters: parameters)
                        print("INI PARAMETERR", parameters)
                    } else {
                        print("Error: Invalid book id")
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Changes")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }

            }
            .navigationTitle("Edit Book")
            .onAppear {
                bookName = book.book_name
                authorName = book.author_name
                bookYear = book.book_year
            }
        }
    }
}
