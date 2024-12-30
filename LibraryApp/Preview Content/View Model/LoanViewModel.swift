//
//  LoanViewModel.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 30/12/24.
//

import Foundation

class LoanViewModel: ObservableObject {
    @Published var loans: [Loan] = []
    
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
    
    func addLoan(loanID: Int, bookID: String, memberID: String, loanDate: String, returnDate: String?) {
        guard let url = URL(string: "http://localhost/libraryapp/add_loans.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Prepare JSON body
        let loanData: [String: Any] = [
            "loan_id": loanID,  // Pass as Int
            "book_id": bookID,
            "member_id": memberID,
            "loan_date": loanDate,
            "return_date": returnDate ?? NSNull()
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loanData)
        } catch {
            print("Error serializing loan data: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            // Debugging: print the raw response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received Data: \(jsonString)")
            }

            do {
                if let result = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let success = result["success"] as? Bool, success {
                        print("Loan added successfully, Loan ID: \(result["loan_id"] ?? "N/A")")
                        
                        // Fetch loans after successful addition
                        DispatchQueue.main.async {
                            self.fetchLoans()
                        }
                    } else {
                        print("Error adding loan: \(result["error"] ?? "Unknown error")")
                    }
                } else {
                    print("Unexpected response format")
                }
            } catch {
                print("Error parsing response JSON: \(error)")
            }
        }.resume()
    }
    
    func editLoan(loanID: Int, bookID: String, memberID: String, loanDate: String, returnDate: String?) {
        guard let url = URL(string: "http://localhost/libraryapp/edit_loans.php") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare JSON body
        let loanData: [String: Any] = [
            "loan_id": loanID,
            "book_id": bookID,
            "member_id": memberID,
            "loan_date": loanDate,
            "return_date": returnDate ?? NSNull()
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loanData)
        } catch {
            print("Error serializing loan data: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Debugging: print the raw response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received Data: \(jsonString)")
            }
            
            do {
                if let result = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let success = result["success"] as? Bool, success {
                        print("Loan edited successfully, Loan ID: \(result["loan_id"] ?? "N/A")")
                        
                        // Fetch loans after successful edition
                        DispatchQueue.main.async {
                            self.fetchLoans()
                        }
                    } else {
                        print("Error editing loan: \(result["error"] ?? "Unknown error")")
                    }
                } else {
                    print("Unexpected response format")
                }
            } catch {
                print("Error parsing response JSON: \(error)")
            }
        }.resume()
    }
}
