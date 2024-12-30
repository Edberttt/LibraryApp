//
//  LibraryAppApp.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 29/12/24.
//

import SwiftUI

@main
struct LibraryAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(LibraryViewModel())
        }
    }
}
