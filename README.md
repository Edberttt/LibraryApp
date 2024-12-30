# LibraryApp

This repository contains two main projects: `libraryapp` for the backend and `LibraryApp` for the frontend.

## Projects

### Backend: libraryapp

The backend project is responsible for handling the server-side logic, database interactions, and API endpoints. It is built using PHP and MySQL.

#### Project Structure
libraryapp/ ├── .DS_Store ├── src/ │ ├── main/ │ │ ├── php/ │ │ │ └── api/ │ │ │ ├── add_books.php │ │ │ ├── add_member.php │ │ │ ├── add_loans.php │ │ │ ├── delete_books.php │ │ │ ├── delete_member.php │ │ │ ├── delete_loans.php │ │ │ ├── edit_books.php │ │ │ ├── edit_member.php │ │ │ ├── edit_loans.php │ │ │ ├── fetch_books.php │ │ │ ├── fetch_member.php │ │ │ ├── fetch_loanedbooks.php │ │ │ ├── reactivate_delete_books.php │ │ │ ├── reactivate_delete_member.php │ │ │ └── reactivate_delete_loans.php │ └── resources/ │ ├── db/ │ │ └── database.sql │ └── config/ │ └── config.php ├── README.md

Frontend: LibraryApp
The frontend project is an iOS application built using Swift and SwiftUI.

Project Structure
LibraryApp/
├── .DS_Store
├── Assets.xcassets/
│   ├── AccentColor.colorset/
│   ├── AppIcon.appiconset/
│   ├── [Contents.json](http://_vscodecontentref_/0)
│   └── ListBackgroundColor.colorset/
├── [Const.swift](http://_vscodecontentref_/1)
├── [ContentView.swift](http://_vscodecontentref_/2)
├── [LibraryAppApp.swift](http://_vscodecontentref_/3)
├── Preview Content/
│   ├── Helper/
│   ├── Model/
│   ├── Preview Assets.xcassets/
│   ├── View/
│   └── View Model/
├── [LibraryApp.xcodeproj](http://_vscodecontentref_/4)
│   ├── [project.pbxproj](http://_vscodecontentref_/5)
│   ├── project.xcworkspace/
│   └── xcuserdata/
├── LibraryAppTests/
│   └── [LibraryAppTests.swift](http://_vscodecontentref_/6)
├── LibraryAppUITests/
│   ├── [LibraryAppUITests.swift](http://_vscodecontentref_/7)
│   └── [LibraryAppUITestsLaunchTests.swift](http://_vscodecontentref_/8)
└── README.md

How to Run
Open LibraryApp/LibraryApp.xcodeproj in Xcode.
Select the target device or simulator.
Build and run the project by clicking the "Run" button or using the shortcut Cmd + R.
License
This project is licensed under the MIT License - see the LICENSE file for details.

