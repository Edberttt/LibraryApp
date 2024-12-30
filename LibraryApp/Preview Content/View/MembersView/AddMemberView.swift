//
//  AddMemberView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import SwiftUI

struct AddMemberView: View {
    @EnvironmentObject var memberVM: MemberViewModel
    @State private var memberName = ""
    @State private var memberPhone = ""
    @State private var memberNIM = ""
    @State private var memberMajor = ""
    @State private var message = ""
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Member Details")) {
                    TextField("Name", text: $memberName)
                    TextField("Phone", text: $memberPhone)
                        .keyboardType(.phonePad)
                    TextField("NIM", text: $memberNIM)
                    TextField("Major", text: $memberMajor)
                }
                
                Button(action: addMember) {
                    Text("Add Member")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Add Member")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(message), dismissButton: .default(Text("OK")))
            }
        }
    }

    func addMember() {
        guard !memberName.isEmpty, !memberPhone.isEmpty, !memberNIM.isEmpty, !memberMajor.isEmpty else {
            message = "All fields are required"
            showAlert = true
            return
        }

        let parameters = [
            "member_name": memberName,
            "member_phone": memberPhone,
            "member_nim": memberNIM,
            "member_major": memberMajor
        ]
        
        memberVM.addMember(parameters: parameters) { success, errorMessage in
            if success {
                message = "Member added successfully"
            } else {
                message = errorMessage ?? "Failed to add member"
            }
            showAlert = true
        }
        
        memberVM.fetchMembers()
    }
}
