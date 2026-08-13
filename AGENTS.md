# AGENTS.md

# Receipt Generator & Printing App — Development Agent Instructions

## Objective

Your task is to implement the application logic for the Receipt Generator & Printing App.

**The UI, layouts, navigation, and screen designs are already complete and must not be redesigned.**

Your responsibility is to connect the existing UI with business logic, local state management, Firebase services, receipt generation, and printing functionality.

Work incrementally and complete one phase before moving to the next. Do not begin a later phase until the current phase is fully implemented, tested, and stable.

Project licensed under Apache 2.0

---

# General Rules

## UI

* Do not redesign any screen.
* Do not change the application's navigation.
* Do not modify colors, typography, spacing, icons, or layout.
* Only connect the existing widgets to application logic.

---

## Code Quality

Follow Flutter best practices.

Requirements:

* Clean Architecture (lightweight)
* Feature-first folder organization
* Small reusable services
* Strong typing
* Null safety
* Proper error handling
* Avoid duplicated logic
* Keep widgets lightweight
* Separate UI from business logic

---

## State Management

Use Provider.

Avoid placing business logic inside widgets.

Create dedicated providers/services for:

* ReceiptProvider
* PrinterProvider
* FirestoreService
* PdfService

---

## Firebase

Use:

* firebase_core
* cloud_firestore
* firebase Authentication

There will be one Firestore database.

---

## Data Model

Create a Receipt model.

Suggested fields:

* id
* voucherNumber
* mineralType
* mineralValue
* quantity
* vehicleNumber
* transportPhone
* buyerName
* destination
* productionCenter
* sellerName
* licenseNumber
* salesDate
* qrData
* createdAt
* updatedAt

Provide:

* fromMap()
* toMap()
* copyWith()

---

# Current phase

# PHASE 2 — Receipt Form Logic

Goal

Connect all input fields.

Implement:

* Text controllers
* Form validation
* Required field validation
* Numeric validation
* Phone validation
* Read-only constant fields
* Current date/time generation
* Voucher number prefix handling (always begins with "A437")
* Mineral value prefix handling (always begins with "TZS")

The user should only enter the editable portion of prefixed fields.

Completion Criteria

The form validates correctly and produces a complete Receipt object.

---

# Firestore Structure

Collection

receipts

Each document should contain:

* voucherNumber
* mineralType
* mineralValue
* quantity
* vehicleNumber
* transportPhone
* buyerName
* destination
* productionCenter
* sellerName
* licenseNumber
* salesDate
* qrData
* createdAt
* updatedAt

---

# Flutter Packages

Use only well-maintained packages.

Core packages include:

* firebase_core
* cloud_firestore
* provider
* intl
* uuid
* pdf
* printing
* qr_flutter
* shared_preferences

For printing, choose stable packages that support both Bluetooth and network (Wi-Fi) thermal receipt printers.

Avoid adding unnecessary dependencies.

---

# Development Workflow

Every phase must follow this sequence:

1. Implement the feature.
2. Resolve all compilation issues.
3. Test the feature thoroughly.
4. Remove dead or unused code.
5. Refactor if necessary.
6. Ensure existing functionality is not broken.
7. Commit the phase before starting the next.

Never skip phases.

---

# Definition of Done

A phase is complete only when:

* The project builds successfully.
* No analyzer errors remain.
* No runtime exceptions occur during normal use.
* Existing functionality continues to work.
* The feature has been manually tested.
* Code follows Flutter best practices.

Do not continue to the next phase until all of these conditions are satisfied.

---

# Final Goal

The completed application should provide a seamless workflow:

1. User creates a new receipt.
2. The app validates all inputs.
3. A receipt preview is generated.
4. The user confirms the details.
5. The receipt is saved to Firestore.
6. A QR code is generated and embedded.
7. A printable PDF is created.
8. The receipt is printed to the selected printer.
9. The receipt appears immediately in Receipt History.
10. Users can later search, view, edit, delete, or reprint any saved receipt.
11. Only bootstraped user will be able to login and access the app features and functions.

Maintain clean, modular, production-quality code throughout the implementation. Focus on reliability, maintainability, and minimal disruption to the existing UI while implementing each phase.
