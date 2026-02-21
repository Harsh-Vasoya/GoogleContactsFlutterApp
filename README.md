# google_contacts_flutter

A new Google Contact Flutter project.

## Getting Started

Flutter Contacts App (MVVM + GetX + SQLite)

This project is a Google Contacts–style mobile application developed using Flutter. It follows the MVVM architecture pattern and uses GetX for state management and routing, with SQLite for offline data storage.

Architecture

- MVVM (Model–View–ViewModel)
- GetX for state management, routing, and dependency injection
- SQLite for local database storage
- Clean and scalable project structure

Features

- Bottom navigation with two tabs:
  - Contacts
  - Favorites
- View all contacts
- Add new contact (name, phone, email, etc.)
- Edit contact details
- Delete contact with confirmation dialog
- View detailed contact profile
- Call contact directly from the app
- Mark/unmark contacts as favorites
- Offline data persistence using SQLite

Database

SQLite is used for storing contact data locally.
Full CRUD operations are implemented.

Example contact fields:
- id
- name
- phone
- email
- isFavorite
- createdAt

Installation

1. Clone the repository:
   git clone https://github.com/Harsh-Vasoya/GoogleContactsFlutterApp.git
   cd your-repo-name

2. Install dependencies:
   flutter pub get

3. Run the app:
   flutter run

Dependencies

- get
- sqflite
- path_provider
- url_launcher
- shared_preferences (if used)

Notes

- Material Design UI
- Responsive layout
- Optimized and clean code
- Follows Flutter best practices
