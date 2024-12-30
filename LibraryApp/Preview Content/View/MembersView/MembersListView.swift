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
    @State private var selectedTab: Int = 0
    @State private var showEditMemberView: Bool = false
//    @State private var showDeleteAlert: Bool = false
    @State private var memberToDelete: Member? = nil
    @State private var memberToReactivate: Member? = nil
//    @State private var showReactivateAlert: Bool = false
    @State private var alertType: AlertType? = nil
    
    enum AlertType: Identifiable {
        case delete(Member)
        case reactivate(Member)
        
        var id: String {
            switch self {
            case .delete(let member):
                return "delete-\(member.id)"
            case .reactivate(let member):
                return "reactivate-\(member.id)"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                Picker("", selection: $selectedTab) {
                    Text("Active").tag(0)
                    Text("Inactive").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                if selectedTab == 0 {
                    List(memberVM.members.filter { $0.delete_status == "0" }){ member in
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
                                
                                Button(action: {
                                    // Store the member to be deleted
                                    memberToDelete = member
                                    alertType = .delete(member)
                                    print("Delete alert triggered for member: \(member.member_name)")
                                }) {
                                    Image(systemName: "trash") // Trash symbol for deleting
                                        .foregroundColor(.red)
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.red, lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.bottom, 10)
                        
                    }
                }
                else{
                    List(memberVM.members.filter { $0.delete_status == "1" }){ member in
                        VStack(alignment: .leading) {
                            Text(member.member_name)
                                .font(.headline)
                            Text("Phone: \(member.member_phone)")
                                .font(.subheadline)
                            
                            HStack{
                                
                                Button(action: {
                                    // Store the member to be deleted
                                    memberToReactivate = member
                                    alertType = .reactivate(member)
                                    print("Reactive alert triggered for member: \(member.member_name)")
                                }) {
                                    Image(systemName: "trash") // Trash symbol for deleting
                                        .foregroundColor(.red)
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.red, lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.bottom, 10)
                        
                    }
                }
            }
            .background(.listBackground)
            
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
            .alert(item: $alertType) { alertType in
                switch alertType {
                case .delete(let member):
                    return Alert(
                        title: Text("Delete Member"),
                        message: Text("Are you sure you want to delete \(member.member_name)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            memberVM.deleteMember(memberID: member.id)
                        },
                        secondaryButton: .cancel()
                    )
                case .reactivate(let member):
                    return Alert(
                        title: Text("Reactivate Member"),
                        message: Text("Are you sure you want to reactivate \(member.member_name)?"),
                        primaryButton: .destructive(Text("Reactivate")) {
                            memberVM.reactivateDeleteMember(memberID: member.id)
                        },
                        secondaryButton: .cancel()
                    )
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
