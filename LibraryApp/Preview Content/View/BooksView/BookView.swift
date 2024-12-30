//
//  BookView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

//import SwiftUI
//
//struct BooksView: View {
//    @EnvironmentObject var bookVM: BookViewModel
//    @EnvironmentObject var loanVM: LoanViewModel
//    @State private var selectedTab: Int = 0
//    @State private var showAddBookView: Bool = false // State to control the modal
//    @State private var showingAddLoan = false
//    @State private var showEditBookView: Bool = false
//    @State private var selectedBook: Book? = nil
//    @State private var showDeleteAlert: Bool = false
//    
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Picker("", selection: $selectedTab) {
//                    Text("Available").tag(0)
//                    Text("Unavailable").tag(1)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding()
//
//                if selectedTab == 0 {
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            showAddBookView.toggle() // Show the modal
//                        }) {
//                            Text("Add Book")
//                                .foregroundColor(.white)
//                                .padding()
//                                .background(Color.blue)
//                                .cornerRadius(8)
//                        }
//                        .padding(.trailing, 16)
//                    }
//
//                    List(bookVM.books) { book in
//                        VStack(alignment: .leading) {
//                            Text(book.book_name)
//                                .font(.headline)
//                            Text(book.author_name)
//                                .font(.subheadline)
//                            HStack {
//                                Spacer()
//                                Button(action: {
//                                    showEditBookView = true
//                                    selectedBook = book
//                                }) {
//                                    Image(systemName: "pencil") // Pencil symbol for editing
//                                        .foregroundColor(.blue)
//                                        .padding(8)
//                                        .background(
//                                            RoundedRectangle(cornerRadius: 5)
//                                                .stroke(Color.blue, lineWidth: 1)
//                                        )
//                                }
//
//                                Button(action: {
//                                    showDeleteAlert = true
//                                    bookVM.deleteBook(bookID: book.id)
//                                }) {
//                                    Image(systemName: "trash") // Trash symbol for deleting
//                                        .foregroundColor(.red)
//                                        .padding(8)
//                                        .background(
//                                            RoundedRectangle(cornerRadius: 5)
//                                                .stroke(Color.red, lineWidth: 1)
//                                        )
//                                }
//                                
//                            }
//                        }
//                    }
//                } else {
//                    List(bookVM.books) { book in
//                        VStack(alignment: .leading) {
//                            Text(book.book_name)
//                                .font(.headline)
//                            Text(book.author_name)
//                                .font(.subheadline)
//                            HStack {
//                                Spacer()
//                                Button(action: {
//                                    showEditBookView = true
//                                    selectedBook = book
//                                }) {
//                                    Text("Edit")
//                                        .foregroundColor(.blue)
//                                        .padding(.horizontal)
//                                        .padding(.vertical, 6)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 5)
//                                                .stroke(Color.blue, lineWidth: 1)
//                                        )
//                                }
//                                
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Books")
//            .sheet(isPresented: $showAddBookView) {
//                AddBookView() // Present AddBookView as a modal
//            }
//            .sheet(isPresented: $showEditBookView) {
//                if let selectedBook = selectedBook {
//                    EditBookView(book: selectedBook)
//                        .environmentObject(bookVM)
//                }
//            }
//
//
//        }
//    }
//}


import SwiftUI

struct BooksView: View {
    @EnvironmentObject var bookVM: BookViewModel
    @EnvironmentObject var loanVM: LoanViewModel
    @State private var selectedTab: Int = 0
    @State private var showAddBookView: Bool = false // State to control the modal
    @State private var showingAddLoan = false
    @State private var showEditBookView: Bool = false
    @State private var selectedBook: Book? = nil
    @State private var showDeleteAlert: Bool = false
    @State private var bookToDelete: Book? = nil // To store the book to be deleted

    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("Available").tag(0)
                    Text("Unavailable").tag(1)
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

                    /*List(bookVM.books)*/
                    List(bookVM.books.filter { $0.delete_status == "0" }) { book in
                        VStack(alignment: .leading) {
                            Text(book.book_name)
                                .font(.headline)
                            Text(book.author_name)
                                .font(.subheadline)
                            HStack {
                                Spacer()
                                Button(action: {
                                    showEditBookView = true
                                    selectedBook = book
                                }) {
                                    Image(systemName: "pencil") // Pencil symbol for editing
                                        .foregroundColor(.blue)
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.blue, lineWidth: 1)
                                        )
                                }

                                Button(action: {
                                    // Store the book to be deleted
                                    bookToDelete = book
                                    showDeleteAlert = true // Show delete confirmation alert
                                }) {
                                    Image(systemName: "trash") // Trash symbol for deleting
                                        .foregroundColor(.red)
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.red, lineWidth: 1)
                                        )
                                }
                                
                            }
                        }
                    }
                } else {
                    List(bookVM.books.filter { $0.delete_status == "1" }) { book in
                        VStack(alignment: .leading) {
                            Text(book.book_name)
                                .font(.headline)
                            Text(book.author_name)
                                .font(.subheadline)
                            HStack {
                                Spacer()
                                Button(action: {
                                    showEditBookView = true
                                    selectedBook = book
                                }) {
                                    Text("Edit")
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
                    }
                }
            }
            .navigationTitle("Books")
            .sheet(isPresented: $showAddBookView) {
                AddBookView() // Present AddBookView as a modal
            }
            .sheet(isPresented: $showEditBookView) {
                if let selectedBook = selectedBook {
                    EditBookView(book: selectedBook)
                        .environmentObject(bookVM)
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Book"),
                    message: Text("Are you sure you want to delete this book?"),
                    primaryButton: .destructive(Text("Delete")) {
                        // Call the delete function when confirmed
                        if let bookToDelete = bookToDelete {
                            bookVM.deleteBook(bookID: bookToDelete.id)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}



//struct BooksView: View {
//    @EnvironmentObject var bookVM: BookViewModel
//    @EnvironmentObject var loanVM: LoanViewModel
//    @State private var selectedTab: Int = 0
//    @State private var showAddBookView: Bool = false
//    @State private var showingAddLoan = false
//    @State private var showEditBookView: Bool = false
//    @State private var selectedBook: Book? = nil
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Picker("", selection: $selectedTab) {
//                    Text("Available").tag(0)
//                    Text("Unavailable").tag(1)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding()
//
//                if selectedTab == 0 {
//                    // Show available books
//                    BookListView(
//                        books: bookVM.books.filter { $0.delete_status == false },
//                        showEditBookView: $showEditBookView,
//                        selectedBook: $selectedBook,
//                        onDelete: { book in
//                            bookVM.deleteBook(bookID: book.id)
//                        }
//                    )
//                } else {
//                    // Show unavailable books
//                    BookListView(
//                        books: bookVM.books.filter { $0.delete_status == true },
//                        showEditBookView: $showEditBookView,
//                        selectedBook: $selectedBook,
//                        onDelete: nil // Disable delete for unavailable books
//                    )
//                }
//            }
//            .navigationTitle("Books")
//            .sheet(isPresented: $showAddBookView) {
//                AddBookView()
//            }
//            .sheet(isPresented: $showEditBookView) {
//                if let selectedBook = selectedBook {
//                    EditBookView(book: selectedBook)
//                        .environmentObject(bookVM)
//                }
//            }
//        }
//    }
//}
//
//// Helper view for displaying book lists
//struct BookListView: View {
//    let books: [Book]
//    @Binding var showEditBookView: Bool
//    @Binding var selectedBook: Book?
//    let onDelete: ((Book) -> Void)?
//
//    var body: some View {
//        List(books) { book in
//            VStack(alignment: .leading) {
//                Text(book.book_name)
//                    .font(.headline)
//                Text(book.author_name)
//                    .font(.subheadline)
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        showEditBookView = true
//                        selectedBook = book
//                    }) {
//                        Text("Edit")
//                            .foregroundColor(.blue)
//                            .padding(.horizontal)
//                            .padding(.vertical, 6)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 5)
//                                    .stroke(Color.blue, lineWidth: 1)
//                            )
//                    }
//
//                    if let onDelete = onDelete {
//                        Button(action: {
//                            onDelete(book)
//                        }) {
//                            Text("Delete")
//                                .foregroundColor(.red)
//                                .padding(.horizontal)
//                                .padding(.vertical, 6)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 5)
//                                        .stroke(Color.red, lineWidth: 1)
//                                )
//                        }
//                    }
//                }
//            }
//        }
//    }
//}


// MARK: - Preview
//#Preview {
//    BooksView()
//        .environmentObject(LibraryViewModel())
//}
