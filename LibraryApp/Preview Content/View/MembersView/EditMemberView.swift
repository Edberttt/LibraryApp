//
//  EditMemberView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 30/12/24.
//

import SwiftUI

struct EditMemberView: View {
    @EnvironmentObject var memberVM: MemberViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var member: Member

    @State private var memberName: String
    @State private var memberPhone: String
    @State private var memberNim: String
    @State private var memberMajor: String
    
    // Custom initializer
    init(member: Member) {
        self.member = member
        _memberName = State(initialValue: member.member_name)
        _memberPhone = State(initialValue: member.member_phone)
        _memberNim = State(initialValue: member.member_nim)
        _memberMajor = State(initialValue: member.member_major)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Member Details")) {
                    TextField("Member Name", text: $memberName)
                    TextField("Member Phone", text: $memberPhone)
                    TextField("Member NIM", text: $memberNim)
                    TextField("Member Major", text: $memberMajor)
                }
                Button(action: {
                    // Validate the fields
                    if memberName.isEmpty || memberPhone.isEmpty || memberNim.isEmpty || memberMajor.isEmpty {
                        print("Error: All fields are required.")
                        return
                    }
                    
                    if let memberID = Int(member.id) {
                        let parameters: [String: String] = [
                            "member_id": String(memberID),
                            "member_name": memberName,
                            "member_phone": memberPhone,
                            "member_nim": memberNim,
                            "member_major": memberMajor
                        ]
                        
                        // Call the editMember function
                        memberVM.editMember(parameters: parameters) { success, errorMessage in
                            if success {
                                print("Member updated successfully.")
                            } else {
                                print("Failed to update member: \(errorMessage ?? "Unknown error")")
                            }
                        }
                    } else {
                        print("Error: Invalid member id")
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Changes")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Edit Member")
        }
    }
}
