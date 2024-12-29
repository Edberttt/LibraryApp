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
    
//    func fetchMembers() {
//        guard let url = URL(string: "http://localhost/libraryapp/fetch_member.php") else { return }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//            // Debugging: print the raw response data to ensure it's JSON
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Received Data Member: \(jsonString)")
//            }
//            
//            do {
//                let fetchedMembers = try JSONDecoder().decode([Member].self, from: data)
//                DispatchQueue.main.async {
//                    self.members = fetchedMembers
//                }
//            } catch {
//                print("Error decoding Member JSON: \(error)")
//            }
//        }.resume()
//    }
    
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
                // Attempt to decode the array
                let fetchedMembers = try JSONDecoder().decode([Member].self, from: data)
                DispatchQueue.main.async {
                    self.members = fetchedMembers
                }
            } catch {
                print("Error decoding Member JSON: \(error)")
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

    func addMember(parameters: [String: String], completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "http://localhost/libraryapp/add_member.php") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Formulate POST body
        let bodyData = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyData.data(using: .utf8)
        
        // Set content type header
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, "Error: \(error.localizedDescription)")
                }
                return
            }
            
            if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let success = jsonResponse["success"] as? Bool, success {
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                } else {
                    let errorMessage = jsonResponse["error"] as? String ?? "Unknown error occurred"
                    DispatchQueue.main.async {
                        completion(false, errorMessage)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, "Invalid response from server")
                }
            }
        }.resume()
    }

    
}
