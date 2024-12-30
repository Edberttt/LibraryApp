//
//  MemberViewModel.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 30/12/24.
//

import Foundation

class MemberViewModel: ObservableObject {
    @Published var members: [Member] = []
    
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
                        self.fetchMembers() // Fetch updated members list
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
