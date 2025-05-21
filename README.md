# 📝 Flutter Notes App

A clean and scalable **Flutter Notes App** built using Clean Architecture, Firebase Authentication, Cloud Firestore, and GetIt for dependency injection. This app allows users to securely create, edit, delete, and view their personal notes with full support for localization and persistent sessions.

---

## ✅ Features

### 1. 🔐 User Authentication
- **Firebase Authentication** with Email & Password
- Features:
    - Sign Up
    - Login
    - Logout
- Persistent login using:
    - `shared_preferences`
    - Firebase's session handling

---

### 2. 🗂️ Notes Management (CRUD)
- **Create, Read, Update, Delete** operations for notes using **Cloud Firestore**
- Each note contains:
    - `title` (String)
    - `description` (String)
    - `createdAt` (Timestamp)
    - `updatedAt` (Timestamp)
    - `userId` (String)

---

### 3. 🏠 Dashboard (Home Page)
- Displays all notes created by the **currently logged-in user**
- List view includes:
    - Title
    - Short preview of description
    - Created or Updated Date/Time
- Sorted by **most recent**

---

### 4. 📄 Note Details Page
- Displays the **full content** of a selected note
- Options to:
    - Edit note
    - Delete note

---

### 5. ✍️ Add/Edit Note Page
- Simple and user-friendly form
- Fields:
    - Title
    - Description
- On submission:
    - Creates or updates the note in **Firestore**
    - Automatically sets `createdAt` or `updatedAt` timestamps

---

## 🧱 Architecture

This app uses **Clean Architecture** with separation of concerns in the following layers:

- **Presentation Layer**  
  UI widgets, screens, localization, form validation, state management

- **Domain Layer**  
  UseCases, Entities, Repositories (abstract)

- **Data Layer**  
  Firebase services, Repositories (implementations), Models

---

## 🧰 Tech Stack

- **Flutter**
- **Firebase (Auth + Firestore)**
- **GetIt** – Dependency Injection
- **Injectable** – Code generation for DI
- **Build Runner** – For generating injection code
- **Shared Preferences** – For storing session-related data
- **Intl** – Localization and internationalization

---

## 🌐 Localization

- Supports multiple languages using the `intl` package
- All static texts are internationalized and defined in `.arb` files

---

