//
//  MembersView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import SwiftUI

struct MembersView: View {
    @EnvironmentObject var memberVM: MemberViewModel
    @State private var showAddMemberView = false // State to manage sheet visibility
    @State private var selectedMember: Member? = nil// State to hold the selected member for editing
    @State private var showEditMemberView: Bool = false

    var body: some View {
        NavigationView {
            List(memberVM.members) { member in
                VStack(alignment: .leading) {
                    Text(member.member_name)
                        .font(.headline)
                    Text("Phone: \(member.member_phone)")
                        .font(.subheadline)
                    
                    HStack{
                        Button(action: {
                            showEditMemberView = true
                            selectedMember = member
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
                .padding(.bottom, 10)
                
            }
            .navigationTitle("Members")
            .sheet(isPresented: $showAddMemberView) {
                AddMemberView()
                    .environmentObject(memberVM)
            }
            .sheet(isPresented: $showEditMemberView) {
                if let selectedMember = selectedMember {
                    EditMemberView(member: selectedMember) // Pass the unwrapped Binding<Member>
                        .environmentObject(memberVM)
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddMemberView = true // Show the AddMemberView as a sheet
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
//    MembersView()
//        .environmentObject(LibraryViewModel())
//}
