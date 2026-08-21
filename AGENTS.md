# AGENTS.md

# Mineral Receipt App — Development Agent Instructions

## Project Objective

Develop the existing Flutter Mineral Receipt application into a fully functional offline-first receipt management and printing application.

**Important: The UI, screens, navigation, layouts, styling, and visual designs have already been implemented.**

Do **not** redesign or replace the existing UI.

The remaining work is application logic, local database integration, receipt generation, QR-code generation, thermal-printer integration, data export, sharing, and testing.

The application is designed for **one user on one device**.

Therefore:

> **Do NOT use Firebase, Firestore, Firebase Authentication, Cloud Functions, or any remote backend.**

The application's primary data source must be a local SQLite database.

---

# Core Architecture Decision

Use:

**Flutter + SQLite + Drift**

Preferred database implementation:

```text
Drift
  ↓
SQLite
  ↓
Local device storage
```

Drift is preferred over directly using `sqflite` because it provides:

* Type-safe queries
* Generated database code
* Better schema management
* Migrations
* Reactive queries
* Compile-time query validation

If the existing project already has a stable `sqflite` implementation that would require significant unnecessary migration work, `sqflite` may be retained.

However, for new database implementation:

> Prefer Drift.

---

# Application Characteristics

The application must be:

* Offline-first
* Local-first
* Fast
* Reliable
* Simple
* Single-user
* Printer-oriented
* Independent of internet connectivity

Internet access must NOT be required to:

* Create receipts
* View receipts
* Edit receipts
* Delete receipts
* Generate QR codes
* Preview receipts
* Print receipts
* Search receipt history

Internet may only be required when the user explicitly chooses to share/export a file through another application such as Google Drive.

---

# Existing UI Must Be Preserved

The AI coding agent must inspect the existing project before making changes.

Do not recreate the screens.

Do not redesign:

* Home
* Navigation drawer
* Receipt form
* Receipt preview
* Receipt verification
* Receipt history
* Receipt details
* Edit receipt
* Printer interface
* Settings
* Dialogs
* login

Do not change:

* Colors
* Typography
* DM Sans
* Blue/white theme
* Existing spacing
* Existing icons
* Existing layouts
* Existing navigation structure

Only connect the existing UI to the underlying application logic.

If a UI widget requires a small modification to support functionality, make the smallest possible change.

---

# Application Navigation

The existing navigation consists of only:

```text
Home
Receipt 
History
```

**Remove the three layered icon on the topbar since all navigation is already available on the bottom bar**.

Do not add unnecessary navigation destinations.

---

# Receipt Data Model

Create a strongly typed Receipt model.

The receipt must contain:

```text
id
mineralType
voucherNumber
mineralValue
quantity
vehicleNumber
transportPhone
buyerName
destination
productionCenter
sellerName
licenseNumber
salesDate
qrData
createdAt
updatedAt
```

Recommended types:

```text
id                 String / int
mineralType        String
voucherNumber      String
mineralValue       Decimal-safe numeric representation
quantity           Decimal-safe numeric representation
vehicleNumber      String
transportPhone     String
buyerName          String
destination        String
productionCenter   String
sellerName         String
licenseNumber      String
salesDate          DateTime
qrData             String
createdAt          DateTime
updatedAt          DateTime
```

Do not use floating-point arithmetic for currency if it can cause precision problems.

Prefer storing currency values as integer TZS units.

For example:

```text
150000 TZS → 150000
```

rather than:

```text
150000.00 as double
```

---

# SQLite Database

Create a local SQLite database containing a `receipts` table.

Suggested schema:

```text
receipts
---------
id
mineral_type
voucher_number
mineral_value
quantity
vehicle_number
transport_phone
buyer_name
destination
production_center
seller_name
license_number
sales_date
qr_data
created_at
updated_at
```

Add appropriate indexes for frequently searched fields.

At minimum consider indexes for:

```text
voucher_number
buyer_name
vehicle_number
sales_date
```

---

# Database Layer

Use a dedicated database layer.

Recommended structure:

```text
lib/
  database/
    app_database.dart
    tables/
      receipts_table.dart
    daos/
      receipts_dao.dart
```

The UI must never directly execute SQL.

Use:

```text
UI
 ↓
Provider / Controller
 ↓
Repository
 ↓
DAO
 ↓
Drift
 ↓
SQLite
```

---

# Repository Layer

Create:

```text
ReceiptRepository
```

Responsibilities:

* Create receipt
* Get receipt
* Get all receipts
* Search receipts
* Update receipt
* Delete receipt
* Get recent receipts

The repository should hide database implementation details from the UI.

---

# State Management

Use the project's existing state-management solution if one is already established.

If no state management solution exists, use:

**Provider**

Recommended providers/controllers:

```text
ReceiptProvider
PrinterProvider
ExportProvider
```

Do not put database queries directly inside widgets.

---

# Current phase

# PHASE 3 — Implement SQLite / Drift

Add the required Drift dependencies.

Implement:

```text
AppDatabase
ReceiptsTable
ReceiptsDao
ReceiptRepository
```

Configure generated Drift code correctly.

Implement database initialization during application startup.

The database must automatically be created on first launch.

No setup screen should be required.

---

# Recommended Project Structure

Use a structure similar to:

```text
lib/

  core/
    constants/
    config/
    utils/

  database/
    app_database.dart
    tables/
    daos/

  models/
    receipt.dart

  repositories/
    receipt_repository.dart

  services/
    qr_service.dart
    printer_service.dart
    pdf_service.dart
    export_service.dart
    share_service.dart

  providers/
    receipt_provider.dart
    printer_provider.dart

  screens/
    home/
    receipt/
    history/
    details/
    printer/

  widgets/

  main.dart
```

Adapt this to the existing project rather than restructuring the entire application unnecessarily.

---

# Service Responsibilities

## ReceiptRepository

Responsible for:

```text
Create
Read
Update
Delete
Search
Recent receipts
```

## QRService

Responsible for:

```text
QR data creation
QR representation
```

## PrinterService

Responsible for:

```text
Printer discovery
Connection
ESC/POS formatting
Printing
Printer status
```

## PdfService

Responsible for:

```text
Receipt PDF generation
```

## ExportService

Responsible for:

```text
CSV export
SQLite backup
```

## ShareService

Responsible for:

```text
Share exported files using share_plus
```

---

# Receipt Output Consistency

There must be one canonical Receipt model.

All output formats must derive from the same data:

```text
Receipt
   ├── UI Preview
   ├── QR Code
   ├── PDF
   ├── ESC/POS Print
   └── CSV
```

Do not duplicate receipt data manually across services.

This prevents inconsistencies between what the user sees and what gets printed.

---

# Receipt Printing Workflow

The final workflow should be:

```text
New Receipt
     ↓
Enter Details
     ↓
Validate
     ↓
Generate Receipt Model
     ↓
Generate QR Data
     ↓
Show Preview
     ↓
User Reviews Details
     ↓
Confirm
     ↓
Save to SQLite
     ↓
Generate ESC/POS commands
     ↓
Print
     ↓
Show Success
```

If printing fails:

```text
Save to SQLite
     ↓
Print fails
     ↓
Show error
     ↓
Retry
```

Do not create another receipt when retrying.

---

# Home Screen

Connect the existing Home screen to SQLite.

Show:

* New Receipt action
* Recent receipt previews

Recent receipts should come directly from the local database.

The Home screen must update when a receipt is:

* Created
* Edited
* Deleted

---

# Receipt History

The history screen must query SQLite rather than loading everything into memory unnecessarily.

For large datasets, use:

* Pagination
* Lazy loading
* Database-level search

where appropriate.

Do not perform expensive filtering entirely inside Dart if SQLite can efficiently perform the query.

---

# Testing Strategy

Every implementation phase must be tested before proceeding.

At minimum test:

## Receipt Creation

* Valid receipt
* Missing fields
* Invalid voucher
* Invalid currency
* Invalid quantity
* Invalid phone

## Receipt Editing

* Change one field
* Change multiple fields
* Save changes
* Verify no duplicate

## Receipt Deletion

* Cancel deletion
* Confirm deletion

## Search

* Voucher
* Buyer
* Vehicle

## QR

* QR generated
* QR displayed in preview
* QR encoded data is correct

## Printing

* Printer connected
* Printer disconnected
* Print failure
* Retry print
* Verify no duplicate receipt

## Database

* App restart
* Data persistence
* Database migration
* Large receipt history

## Export

* SQLite backup
* CSV
* PDF
* Share sheet

---

# Development Process

Implement strictly in phases.

Recommended sequence:

```text
Phase 1
Project Inspection

        ↓

Phase 2
Remove Firebase

        ↓

Phase 3
SQLite / Drift

        ↓

Phase 4
Receipt CRUD

        ↓

Phase 5
Receipt Form Logic

        ↓

Phase 6
Validation & Verification

        ↓

Phase 7
QR Code

        ↓

Phase 8
Receipt Preview

        ↓

Phase 9
Printer Integration

        ↓

Phase 10
History / Details / Editing

        ↓

Phase 11
PDF Export

        ↓

Phase 12
CSV Export

        ↓

Phase 13
SQLite Backup

        ↓

Phase 14
Share with share_plus

        ↓

Phase 15
Error Handling

        ↓

Phase 16
Testing & Optimization
```

Do not jump directly to printer implementation before the database and receipt model are stable.

---

# Phase Completion Rules

A phase is complete only when:

* Code compiles.
* `flutter analyze` passes.
* No unnecessary analyzer warnings remain.
* Existing UI remains intact.
* Feature works on a real device where applicable.
* Existing functionality has not regressed.
* Error states are handled.
* No temporary/debug code remains.
* Database changes are migration-safe.
* The implementation is documented where necessary.

Only then proceed to the next phase.

---

# Agent Behavior

The coding agent must:

1. Inspect before modifying.
2. Reuse existing UI.
3. Make small, controlled changes.
4. Avoid unnecessary refactoring.
5. Implement one phase at a time.
6. Test after each phase.
7. Keep dependencies minimal.
8. Never reintroduce Firebase.
9. Never move receipt data to a remote backend.
10. Never convert the receipt to an image before ESC/POS printing.
11. Never silently delete user data.
12. Never generate duplicate receipts because of printing failures.
13. Preserve existing receipt data during migrations.
14. Keep the application fully usable offline.

---

# Explicitly Prohibited

The agent must NOT:

* Add Firebase.
* Add Firestore.
* Add Firebase Authentication.
* Add Cloud Functions.
* Add a remote API unnecessarily.
* Require internet for core functionality.
* Upload receipts to a server.
* Convert receipts to screenshots/images before thermal printing.
* Generate QR codes remotely.
* Implement Google Drive API authentication unnecessarily.
* Redesign existing screens.
* Replace the existing UI architecture without justification.
* Store currency as unreliable floating-point values.
* Delete the SQLite database during updates.
* Create duplicate receipts when retrying a print.

---

# Final Definition of Done

The application is complete when a user can perform the entire workflow without internet:

```text
Open App
   ↓
Home
   ↓
Create Receipt
   ↓
Enter Mineral Receipt Details
   ↓
Validate
   ↓
Generate Receipt
   ↓
Preview Receipt
   ↓
View QR Code
   ↓
Verify Details
   ↓
Confirm
   ↓
Save to SQLite
   ↓
Print Directly Using ESC/POS
   ↓
Receipt Saved
   ↓
View in History
   ↓
Open Receipt
   ↓
Edit / Delete / Reprint
```

The user must also be able to:

```text
Export SQLite database
Export CSV
Export PDF
Share exported files
```

through the operating system's share mechanism using `share_plus`, allowing the user to choose Google Drive or another installed application.

The final architecture should be:

```text
                 ┌──────────────────┐
                 │   Flutter UI     │
                 └────────┬─────────┘
                          │
                 ┌────────▼─────────┐
                 │ Provider/Logic   │
                 └────────┬─────────┘
                          │
             ┌────────────┼─────────────┐
             │            │             │
             ▼            ▼             ▼
       ┌──────────┐ ┌────────────┐ ┌───────────┐
       │ SQLite   │ │ QR Service │ │  Printer  │
       │  Drift   │ │ qr_flutter │ │ ESC/POS   │
       └──────────┘ └────────────┘ └───────────┘
             │
             │
       ┌─────▼──────────┐
       │ Export Service │
       ├────────────────┤
       │ SQLite         │
       │ CSV            │
       │ PDF            │
       └───────┬────────┘
               │
               ▼
          share_plus
               │
               ▼
       Android/iOS Share
             Sheet
               │
               ▼
        Google Drive /
        Other Apps
```

## Final Architectural Principle

**SQLite is the source of truth.**

The application should be completely functional without Firebase or an internet connection.

Receipt data is created, stored, queried, edited, deleted, searched, and backed up locally.

QR codes are generated locally.

Thermal receipts are printed directly as ESC/POS commands.

PDF, CSV, and SQLite exports are generated locally.

`share_plus` delegates sharing to the operating system, allowing the user to save backups to Google Drive without requiring a Google Drive API integration.

Keep the implementation simple, reliable, maintainable, and appropriate for a single-user receipt application.
