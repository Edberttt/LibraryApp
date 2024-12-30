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
    @State private var showEditBookView: Bool = false
    @State private var selectedBook: Book? = nil
    @State private var bookToDelete: Book? = nil // To store the book to be deleted
    @State private var bookToReactivate: Book? = nil
    @State private var alertType: AlertType? = nil
    
    enum AlertType: Identifiable {
        case delete(Book)
        case reactivate(Book)
        
        var id: String {
            switch self {
            case .delete(let book):
                return "delete-\(book.id)"
            case .reactivate(let book):
                return "reactivate-\(book.id)"
            }
        }
    }

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
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(bookVM.books.filter { $0.delete_status == "0" }, id: \.id) { book in
                                VStack(alignment: .leading) {
                                    Text("Title: \(book.book_name)")
                                        .font(.headline)
                                    Text("Author: \(book.author_name)")
                                        .font(.subheadline)
                                    Text("Year Release: \(book.book_year)")
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
                                            alertType = .delete(book)
                                        }) {
                                            Image(systemName: "trash") // Trash symbol for deleting
                                                .foregroundColor(.red)
                                                .padding(6)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.red, lineWidth: 1)
                                                )
                                                
                                        }
                                    }
                                }
                                .padding()
                                Divider()
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding()
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(bookVM.books.filter { $0.delete_status == "1" }, id: \.id) { book in
                                VStack(alignment: .leading) {
                                    Text("Title: \(book.book_name)")
                                        .font(.headline)
                                    Text("Author: \(book.author_name)")
                                        .font(.subheadline)
                                    Text("Year Release: \(book.book_year)")
                                        .font(.subheadline)
                                    HStack {
                                        Spacer()

                                        Button(action: {
                                            // Store the book to be deleted
                                            bookToReactivate = book
                                            alertType = .reactivate(book)
                                        }) {
                                            Text("Reactivate")
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
                                .padding()
                                Divider()
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding()
                    }
                }
            }
            .background(.listBackground)
            
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
            .alert(item: $alertType) { alertType in
                switch alertType {
                case .delete(let book):
                    return Alert(
                        title: Text("Delete Book"),
                        message: Text("Are you sure you want to delete \(book.book_name)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            bookVM.deleteBook(bookID: book.id)
                        },
                        secondaryButton: .cancel()
                    )
                case .reactivate(let book):
                    return Alert(
                        title: Text("Reactivate Book"),
                        message: Text("Are you sure you want to reactivate \(book.book_name)?"),
                        primaryButton: .default(Text("Reactivate").foregroundColor(.green)) {
                            bookVM.reactivateDeleteBook(bookID: book.id)
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddBookView.toggle() // Show the AddMemberView as a sheet
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
        }
    }
}



// MARK: - Preview
//#Preview {
//    BooksView()
//        .environmentObject(LibraryViewModel())
//}
