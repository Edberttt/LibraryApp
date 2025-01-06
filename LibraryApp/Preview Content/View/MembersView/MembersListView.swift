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
//    @State private var showEditMemberView: Bool = false
    @State private var memberToDelete: Member? = nil
    @State private var memberToReactivate: Member? = nil
    @State private var alertType: AlertType? = nil
    @State private var searchQuery: String = "" // State for search query
    
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

    var filteredMembers: [Member] {
        if searchQuery.isEmpty {
            return memberVM.members
        } else {
            return memberVM.members.filter { $0.member_name.localizedCaseInsensitiveContains(searchQuery) }
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
                .padding(.horizontal)
                
                if selectedTab == 0 {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(filteredMembers.filter { $0.delete_status == "0" }, id: \.id) { member in
                                VStack(alignment: .leading) {
                                    Text("Name: \(member.member_name)")
                                        .font(.headline)
                                    Text("Phone: \(member.member_phone)")
                                        .font(.subheadline)
                                    Text("NIM: \(member.member_nim)")
                                        .font(.subheadline)
                                    Text("Major: \(member.member_major)")
                                        .font(.subheadline)
                                    
                                    HStack{
                                        Spacer()
                                        Button(action: {
//                                            showEditMemberView = true
                                            selectedMember = member
                                        }) {
                                            Image(systemName: "pencil")
                                                .foregroundColor(.blue)
                                                .padding(8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.blue, lineWidth: 1)
                                                )
                                        }
                                        
                                        Button(action: {
                                            memberToDelete = member
                                            alertType = .delete(member)
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                                .padding(6)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.red, lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                                .padding()
                                Divider()
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding()
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(filteredMembers.filter { $0.delete_status == "1" }, id: \.id) { member in
                                VStack(alignment: .leading) {
                                    Text("Name: \(member.member_name)")
                                        .font(.headline)
                                    Text("Phone: \(member.member_phone)")
                                        .font(.subheadline)
                                    Text("NIM: \(member.member_nim)")
                                        .font(.subheadline)
                                    Text("Major: \(member.member_major)")
                                        .font(.subheadline)
                                    
                                    HStack{
                                        Spacer()
                                        Button(action: {
                                            memberToReactivate = member
                                            alertType = .reactivate(member)
                                        }) {
                                            Text("Reactivate")
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
                                .padding()
                                Divider()
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding()
                    }
                }
            }
            .background(.listBackground)
            .navigationTitle("Members")
            .sheet(isPresented: $showAddMemberView) {
                AddMemberView()
                    .environmentObject(memberVM)
            }
            .sheet(item: $selectedMember) { member in
                EditMemberView(member: member)
                    .environmentObject(memberVM)
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
                        primaryButton: .default(Text("Reactivate")) {
                            memberVM.reactivateDeleteMember(memberID: member.id)
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddMemberView = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .searchable(text: $searchQuery)
        }
    }
}



// MARK: - Preview
//#Preview {
//    MembersView()
//        .environmentObject(LibraryViewModel())
//}
