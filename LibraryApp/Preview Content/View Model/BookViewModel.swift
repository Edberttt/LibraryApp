//
//  BookViewModel.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import Foundation

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    
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
    
    func addBook(parameters: [String: String]) {
        guard let url = URL(string: "http://localhost/libraryapp/add_books.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set up form data
        let bodyData = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyData.data(using: .utf8)
        
        // Set content type header
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Make network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            
            // Check response status code
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // Handle the response if status is OK
                    if let data = data, let jsonResponse = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            print("Response: \(jsonResponse)")
                            self.fetchBooks() // Fetch updated books list
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Error: Invalid response from server, status code: \(httpResponse.statusCode)")
                    }
                }
            }
        }.resume()
    }

    func editBook(bookID: Int, parameters: [String: String]) {
        guard let url = URL(string: "http://localhost/libraryapp/edit_books.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Include book ID in the parameters
        var allParameters = parameters
        allParameters["book_id"] = "\(bookID)"
        
        // Set up form data
        let bodyData = allParameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyData.data(using: .utf8)
        
        // Set content type header
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // Handle the response if status is OK
                    if let data = data, let jsonResponse = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            print("Response: \(jsonResponse)")
                            self.fetchBooks() // Fetch updated books list
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Error: Invalid response from server, status code: \(httpResponse.statusCode)")
                    }
                }
            }
        }.resume()
    }

    func deleteBook(bookID: String) {
        guard let url = URL(string: "http://localhost/libraryapp/delete_books.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let postString = "book_id=\(bookID)"
        request.httpBody = postString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received.")
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(json["message"] as? String ?? "No message")
            }

            DispatchQueue.main.async {
                // Automatically fetch books after deletion
                self.fetchBooks()
            }
        }.resume()
    }
    
    func reactivateDeleteBook(bookID: String) {
        guard let url = URL(string: "http://localhost/libraryapp/reactivate_delete_books.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let postString = "book_id=\(bookID)"
        request.httpBody = postString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received.")
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(json["message"] as? String ?? "No message")
            }

            DispatchQueue.main.async {
                // Automatically fetch books after deletion
                self.fetchBooks()
            }
        }.resume()
    }

}
