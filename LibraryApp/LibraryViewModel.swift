//
//  LibraryViewModel.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import Foundation

class LibraryViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var loans: [Loan] = []
    @Published var members: [Member] = []
    
    func fetchBooks() {
        guard let url = URL(string: "http://localhost/libraryapp/fetch_books.php") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Debugging: print the raw response data to ensure it's JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received Data Books: \(jsonString)")
            }
            
            do {
                let fetchedBooks = try JSONDecoder().decode([Book].self, from: data)
                DispatchQueue.main.async {
                    self.books = fetchedBooks
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func fetchLoans() {
        guard let url = URL(string: "http://localhost/libraryapp/fetch_loanedbooks.php") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Debugging: print the raw response data to ensure it's JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received Loan Data: \(jsonString)")
            }
            
            do {
                let fetchedLoans = try JSONDecoder().decode([Loan].self, from: data)
                DispatchQueue.main.async {
                    self.loans = fetchedLoans
                }
            } catch {
                print("Error decoding Loan JSON: \(error)")
            }
        }.resume()
    }
    
    func fetchMembers() {
        guard let url = URL(string: "http://localhost/libraryapp/fetch_member.php") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            // Debugging: print the raw response data to ensure it's JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received Data Member: \(jsonString)")
            }
            
            do {
                let fetchedMembers = try JSONDecoder().decode([Member].self, from: data)
                DispatchQueue.main.async {
                    self.members = fetchedMembers
                }
            } catch {
                print("Error decoding Member JSON: \(error)")
            }
        }.resume()
    }
}
