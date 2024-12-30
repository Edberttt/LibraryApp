//
//  BorrowBookView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

//import SwiftUI
//
//struct BorrowBookView: View {
//    @EnvironmentObject var libraryVM: LibraryViewModel
//    let book: Book
//    
//    @State private var memberName: String = ""
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        VStack {
//            Text("Borrow \(book.title)")
//                .font(.largeTitle)
//                .padding()
//            
//            TextField("Enter Member Name", text: $memberName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            Button("Borrow") {
//                libraryVM.borrowBook(book: book, memberName: memberName)
//                dismiss()
//            }
//            .padding()
//            .disabled(memberName.isEmpty)
//        }
//        .padding()
//    }
//}
