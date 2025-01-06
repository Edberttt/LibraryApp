//
//  AddBookView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import SwiftUI

struct AddBookView: View {
    @EnvironmentObject var bookVM: BookViewModel
    @Environment(\.dismiss) var dismiss
    @State private var bookName = ""
    @State private var authorName = ""
    @State private var bookYear = ""
    @State private var message = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Book Details")) {
                    TextField("Book Name", text: $bookName)
                    TextField("Author Name", text: $authorName)
                    TextField("Year", text: $bookYear)
                        .keyboardType(.numberPad)
                }
                
                Button(action: {
                    addBook()
                    dismiss()
                }) {
                    Text("Add Book")
                }
                
                if !message.isEmpty {
                    Text(message)
                        .foregroundColor(message == "Book added successfully!" ? .green : .red)
                        .padding()
                }
            }
            .navigationTitle("Add Book")
        }
    }
    
    func addBook() {
        // Validate inputs
        guard !bookName.isEmpty, !authorName.isEmpty, !bookYear.isEmpty else {
            message = "All fields are required"
            return
        }
        
        let parameters = [
            "book_name": bookName,
            "author_name": authorName,
            "book_year": bookYear
        ]
        
        // Call the PHP function to insert the data
        bookVM.addBook(parameters: parameters)
        
        // Set success or error message based on the result
        message = "Book added successfully!" // This can be dynamically updated with the actual result of the API call.
    }
}
