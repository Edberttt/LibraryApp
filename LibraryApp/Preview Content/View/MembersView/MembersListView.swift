//
//  MembersView.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import SwiftUI

struct MembersView: View {
    @EnvironmentObject var libraryVM: LibraryViewModel

    var body: some View {
        NavigationView {
            List(libraryVM.members) { member in
                VStack(alignment: .leading) {
                    Text(member.member_name)
                        .font(.headline)
                    Text("Phone: \(member.member_phone)")
                        .font(.subheadline)
                }
                .padding(.bottom, 10) // Added some padding for better spacing
            }
            .navigationTitle("Members")
        }
    }
}

// MARK: - Preview
//#Preview {
//    MembersView()
//        .environmentObject(LibraryViewModel())
//}
