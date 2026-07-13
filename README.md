# Simple Library

A Flutter application that simulates a basic library management system.
This project is intended to serve as a learning foundation, exploring mobile development concepts, code organization, and good practices.

---

## Introduction

This app works as a simple platform for managing a library, allowing users to:

* Register books
* List and organize items
* Use an initial structure for data management

The main goal is not to be a complete production-ready solution, but rather a didactic project for academic and educational purposes.

---

## Technologies Used

* Flutter
* Dart
* (Optional) Firebase or another backend, if implemented

---

## How to Run the Project Locally

### Prerequisites

* Flutter installed (>= 3.x)
* Dart installed (>= 3.x)
* Android/iOS emulator or physical device

### Steps

```bash
# Clone the repository
git clone https://github.com/VitaoDeveloper/Biblioteca_Flutter.git

# Access the project folder
cd Biblioteca_Flutter

# Install dependencies
flutter pub get

# Run the project
flutter run
```

---

## Project Structure

```bash
lib/
├── main.dart                          # Minimal entry point
├── app.dart                           # App MaterialApp setup
├── controllers/
│   └── library_controller.dart        # State management and business logic
└── screens/
    └── home/
        ├── home.dart                  # StatefulWidget + State
        └── widgets/
            ├── genre_dropdown.dart
            ├── genre_actions.dart
            └── book_list_tile.dart    # Book list item and actions
```

---

## Contribution

Even though this is an academic project, contributions are welcome!

### How to contribute:

1. Fork the project
2. Create a branch:

   ```bash
   git checkout -b my-feature
   ```
3. Commit your changes:

   ```bash
   git commit -m "feat: New feature"
   ```
4. Push to your repository:

   ```bash
   git push origin my-feature
   ```
5. Open a Pull Request

### Best practices:

* Use clear variable names
* Follow the project's organization pattern
* Prefer descriptive commits

---

## Notice

This project **does not have a license** and was developed **exclusively for academic and educational purposes**.
It should not be used in production.

---

## Related Issue

**Improve the project's README documentation**

This README was structured based on the need to make the documentation clearer and more accessible for new developers, including:

* Better project description
* Local setup guide
* Code organization
* Contribution guidelines

---
