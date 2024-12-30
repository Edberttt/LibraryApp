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

    var body: some View {
        NavigationView {
            List(memberVM.members) { member in
                VStack(alignment: .leading) {
                    Text(member.member_name)
                        .font(.headline)
                    Text("Phone: \(member.member_phone)")
                        .font(.subheadline)
                }
                .padding(.bottom, 10) // Added some padding for better spacing
            }
            .navigationTitle("Members")
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
            .sheet(isPresented: $showAddMemberView) {
                AddMemberView()
                    .environmentObject(memberVM) // Pass the environment object to AddMemberView
            }
        }
    }
}


// MARK: - Preview
//#Preview {
//    MembersView()
//        .environmentObject(LibraryViewModel())
//}
