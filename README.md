# Snapbit Assessment – iOS Application

## Overview

Snapbit Assessment is an iOS application built using **Swift and UIKit** that demonstrates a scalable architecture and server-driven UI implementation using **Firebase Firestore**.

The project follows **MVVM with Clean Architecture**, separating the application into clear layers to improve maintainability, scalability, and testability.

The application includes user authentication, a dynamic questionnaire fetched from the backend, and a persistent break timer system.

---

# Platform & Technologies

* Platform: iOS
* Minimum iOS Version: iOS 26
* Language: Swift
* UI Framework: UIKit
* Backend: Firebase Firestore
* Architecture: MVVM + Clean Architecture
* Design Principles: Protocol-Oriented Programming, Delegation Pattern

---

# Architecture

The project follows **MVVM combined with Clean Architecture** to keep the code modular and maintainable.

The application is divided into three main layers:

## Presentation Layer

Responsible for UI and user interactions.

Components:

* ViewControllers
* ViewModels
* UI Components

Example files:

* BreakViewController
* QuestionnaireViewController
* LoginViewController

The ViewModel communicates with the Domain layer through **UseCases**.

---

## Domain Layer

Contains the business logic of the application.

Components:

* UseCase Protocols
* Repository Protocols
* UseCase Implementations

The domain layer is completely independent of external frameworks.

---

## Data Layer

Responsible for data retrieval and persistence.

Components:

* Repository Implementations
* Firebase Services
* User Services

Example services:

* FirebaseBreakService
* FirebaseService
* UserService

---

# Features Implemented

## Authentication

* Login Screen
* Signup Screen

The signup screen was **not part of the provided design**, but it was added to enable proper account creation and testing of the authentication flow.

---

## Server Driven Questionnaire UI

The questionnaire screen is **fully driven by backend data**.

Questions are fetched from **Firebase Firestore**, and the UI is dynamically generated based on the response.

Features:

* Dynamic question rendering
* Answers controlled by backend data
* Flexible structure for adding or modifying questions without app updates

---

## Real-Time Progress Bar

The questionnaire includes a progress bar that updates dynamically.

Features:

* Progress increases as answers are selected
* Progress decreases if answers are changed
* Updates occur in real time

---

## Break Timer System

After completing the questionnaire, users are navigated to the **Break Timer Screen**.

Features:

* Start Break functionality
* Circular timer visualization
* Break duration tracking
* Ability to end break early
* Confirmation popup before ending break (as shown in the design)

### Persistent Timer

The break timer persists even if:

* The user closes the app
* The app is killed

When the user reopens the app, the timer correctly reflects the **elapsed break duration**.

---

## Help Menu (Developer Utility)

A Help button is available at the top of the Break Screen.

Although not part of the design specification, it was added for **testing purposes**.

Actions available:

* Logout
* Reset break timer

This allows reviewers or developers to easily test different states of the UI.

---

# Firebase Usage

Firebase Firestore is used as the backend for the application.

The following data is stored:

### Questionnaire Data

Used to dynamically generate the questionnaire UI.

### User Data

Stores user information such as:

* Email
* Username

### Break Timer Data

Stores break session information:

* Break start time
* Break end time

---

# Project Structure

Example important files:

Presentation Layer

* BreakViewController
* QuestionnaireViewController
* LoginViewController

ViewModels

* BreakViewModel
* QuestionnaireViewModel
* LoginViewModel

Services

* FirebaseBreakService
* FirebaseService
* UserService

---

# How to Run the Project

1. Unzip the project folder.
2. Open the project in **Xcode**.
3. Add your own **Firebase project**.

Steps:

1. Create a Firebase project.
2. Register the iOS app using your bundle identifier.
3. Download the **GoogleService-Info.plist** file.
4. Add the plist file to the project target.

After adding the plist file, build and run the project.

---

# Testing Notes

To test the application easily:

1. Create a new account using the Signup screen.
2. Complete the questionnaire.
3. Start a break.
4. Kill the app and reopen it to verify timer persistence.

The Help button on the Break screen can also be used to:

* Reset the timer
* Logout for testing.

---

# Assets Included

The submission package includes:

* Source Code
* README Documentation
* UI Screenshots
* Screen Recording Demonstrating the Flow

---

# Key Highlights

* Clean Architecture Implementation
* Protocol-Oriented Programming
* Server Driven UI using Firebase
* Persistent Break Timer
* Modular and Scalable Project Structure
* Production-style architecture suitable for large applications

---

# Author

Muhammad Saif
iOS Developer

