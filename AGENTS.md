# AGENTS.md

# Mineral Receipt App — Development Agent Instructions

## 1. Project Objective

Develop the existing Flutter Mineral Receipt application into a fully functional offline-first receipt management and printing application.

**Important: The UI, screens, navigation, layouts, styling, and visual designs have already been implemented.**

Do **not** redesign or replace the existing UI.

The remaining work is application logic, local database integration, receipt generation, QR-code generation, thermal-printer integration, data export, sharing, and testing.

The application is designed for **one user on one device**.

Therefore:

> **Do NOT use Firebase, Firestore, Firebase Authentication, Cloud Functions, or any remote backend.**

The application's primary data source must be a local SQLite database.

---

# 2. Core Architecture Decision

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

# 3. Application Characteristics

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

# 4. Existing UI Must Be Preserved

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

# 5. Application Navigation

The existing navigation consists of only:

```text
Home
Receipt 
History
```

**Remove the three layered icon on the topbar since all navigation is already available on the bottom bar**.

Do not add unnecessary navigation destinations.

---

# 6. Receipt Data Model

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

# 7. SQLite Database

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

# 8. Database Layer

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

# 9. Repository Layer

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

# 10. State Management

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

# 11. PHASE 1 — Project Inspection

Before changing code:

1. Inspect the entire project structure.
2. Identify all existing screens.
3. Identify existing models.
4. Identify existing providers/controllers.
5. Identify existing services.
6. Identify existing dependencies.
7. Identify existing receipt UI.
8. Identify existing printer UI.
9. Identify whether Firebase code currently exists.
10. Identify whether any database implementation already exists.

Do not immediately rewrite files.

First understand the existing architecture.

---

# 12. PHASE 2 — Remove Firebase Backend

Remove Firebase as the application's data backend.

Remove:

```text
firebase_core
cloud_firestore
firebase_auth
cloud_functions
```

and any other Firebase packages that are no longer required.

Remove:

* Firebase initialization
* Firestore repositories
* Cloud Function calls
* Firebase authentication checks
* Firebase-specific models
* Firebase-specific providers
* Firebase security assumptions

Remove unused Firebase configuration only when it is safe to do so.

The final application must build without Firebase.

Do not leave Firebase code as an unnecessary dependency.

---

# 13. PHASE 3 — Implement SQLite / Drift

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

# 14. PHASE 4 — Database CRUD

Implement:

### Create

Save a receipt locally.

### Read

Retrieve:

* Individual receipt
* Recent receipts
* All receipts

### Update

Update an existing receipt without creating a duplicate.

### Delete

Delete a receipt after user confirmation.

### Search

Search by:

* Voucher Number
* Buyer Name
* Vehicle Number

### Sort

Default:

```text
Newest first
```

Use `salesDate` or `createdAt` appropriately.

---

# 15. PHASE 5 — Receipt Form Logic

Connect the existing receipt form.

Fields must be handled in this order:

1. Mineral Type
2. Voucher Number
3. Mineral Value
4. Quantity
5. Vehicle Number
6. Transport Phone
7. Buyer Name
8. Destination
9. Production Center
10. Seller Name
11. License Number
12. Sales Date

---

# 16. Voucher Number

Voucher Number must always begin with:

```text
A437
```

Validate the value before saving.

Examples:

```text
A4370001
A4370002
A4371234
```

Invalid:

```text
4370001
B4370001
123456
```

The prefix must not be accidentally removed during editing.

Do not blindly prepend `A437` multiple times.

For example:

```text
A437123
```

must remain:

```text
A437123
```

not:

```text
A437A437123
```

---

# 17. Mineral Value

Mineral Value must always use:

```text
TZS
```

The UI may display:

```text
TZS 150,000
```

Internally store the numeric value separately from the display prefix.

Do not store currency calculations as formatted strings.

For example:

Correct:

```text
150000
```

Incorrect:

```text
"TZS 150,000"
```

The formatted value should be generated when displayed or printed.

---

# 18. Constant Fields

The following fields are constant/read-only:

```text
Production Center
Seller Name
License Number
```

Their values must come from application configuration rather than user input where possible.

Do not hard-code these values in multiple widgets.

Create a central configuration object/service.

For example:

```text
BusinessConfig
```

The UI can display them as read-only fields.

---

# 19. Sales Date

Automatically populate Sales Date using the device's current local date/time.

Example:

```text
20 Aug 2026, 16:05
```

Do not require the user to manually enter the date for a new receipt.

When editing an existing receipt:

* Preserve the original sales date unless the user explicitly changes it.
* Do not silently replace it with the current date.

---

# 20. PHASE 6 — Receipt Validation

Before generating a receipt, validate every required field.

Check:

* Required fields
* Voucher number format
* TZS amount
* Quantity
* Phone number
* Date
* Constant fields

Display clear validation errors.

Do not save incomplete receipts.

---

# 21. PHASE 7 — Receipt Verification

The application must NOT immediately print after form submission.

Required workflow:

```text
Enter Details
      ↓
Validate
      ↓
Generate Receipt Preview
      ↓
Verify Details
      ↓
User confirms
      ↓
Save / Print
```

The verification screen must display the complete receipt information.

The user must have the option:

```text
Edit
```

before printing.

---

# 22. PHASE 8 — Local QR Code Generation

Use:

```text
qr_flutter
```

Do NOT use a remote QR service.

Do NOT generate QR codes through Firebase.

QR data should be generated locally.

Preferred QR content:

```text
Receipt ID
Voucher Number
```

or a compact structured receipt identifier.

Example:

```text
MINERAL-RECEIPT:A43700123
```

The QR data must be deterministic and stored with the receipt.

---

# 23. QR Preview

The QR code must be visible in the receipt preview before printing.

The same QR data must be used for:

```text
Preview
PDF export
Printed receipt
```

Do not generate different QR values for different output formats.

---

# 24. PHASE 9 — Receipt Saving

When the user confirms the receipt:

1. Create the Receipt model.
2. Generate QR data.
3. Save receipt to SQLite.
4. Update the UI.
5. Prepare it for printing if printing was requested.

The receipt must be persisted locally before printing where possible.

This prevents a successfully printed receipt from being lost from the database.

---

# 25. PHASE 10 — Thermal Printing

Use:

```text
unified_esc_pos_printer
```

for thermal printer integration.

The printing pipeline must use ESC/POS commands directly.

**Do NOT convert the receipt to an image before printing.**

Do not use:

```text
Widget → Screenshot → Image → Printer
```

Do not use:

```text
PDF → Image → Printer
```

Instead use:

```text
Receipt Data
     ↓
ESC/POS Formatter
     ↓
ESC/POS Commands
     ↓
Thermal Printer
```

---

# 26. Printing Requirements

Support appropriate thermal printer connections according to the capabilities of `unified_esc_pos_printer`.

The printer service should handle:

* Printer discovery where supported
* Connection
* Connection status
* Printing
* Disconnecting
* Errors
* Reconnection where possible

Do not assume every printer supports every connection type.

Keep printer-specific implementation isolated in:

```text
PrinterService
```

---

# 27. Printer Settings

Store printer configuration locally.

Use:

```text
shared_preferences
```

for lightweight settings.

Possible values:

```text
printer type
printer name
Bluetooth identifier
IP address
port
paper width
```

Do not store printer settings in SQLite unless there is a strong reason to do so.

---

# 28. Test Printing

Provide a test-print operation using the existing printer UI.

The test print should not create a receipt in the database.

It should print a simple message such as:

```text
MINERAL RECEIPT

Printer Test Successful
```

---

# 29. Printing Failure Handling

If printing fails:

* Do not delete the receipt.
* Do not create a duplicate receipt.
* Keep the receipt stored locally.
* Display a clear error.
* Allow the user to retry printing.

Example:

```text
Receipt saved successfully,
but printing failed.

Retry Print
```

This distinction is important.

**Saving and printing are separate operations.**

---

# 30. PHASE 11 — Receipt History

Connect the existing History UI to SQLite.

Display:

* Voucher Number
* Buyer Name
* Mineral Type
* Mineral Value
* Sales Date

Newest receipts first.

The history screen must work completely offline.

---

# 31. PHASE 12 — Receipt Details

Connect the existing details screen.

Show all receipt information.

Actions:

```text
Edit
Print
Delete
```

Delete must require confirmation.

---

# 32. PHASE 13 — Editing

When editing a receipt:

1. Load the existing receipt.
2. Populate the existing form.
3. Preserve the original receipt ID.
4. Preserve the original createdAt.
5. Update updatedAt.
6. Validate the edited data.
7. Save using UPDATE.
8. Do not create a new receipt.

The QR data should remain associated with the receipt unless the application's business rules require regeneration.

---

# 33. PHASE 14 — Delete

Deleting a receipt must require confirmation.

Example:

```text
Delete Receipt?

This action cannot be undone.
```

Only delete after explicit confirmation.

Do not delete automatically after a failed print.

---

# 34. PHASE 15 — PDF Export

Provide local PDF generation.

Use:

```text
pdf
```

The PDF should contain the same receipt information and QR code shown in the preview.

PDF generation must work without Firebase.

The PDF should be suitable for:

* Archiving
* Sharing
* Printing
* Sending to another application

---

# 35. PHASE 16 — CSV Export

Implement CSV export for receipt data.

The CSV should contain useful fields such as:

```text
Receipt ID
Voucher Number
Mineral Type
Mineral Value
Quantity
Vehicle Number
Transport Phone
Buyer Name
Destination
Production Center
Seller Name
License Number
Sales Date
Created At
Updated At
```

Generate the CSV locally.

Do not upload it automatically.

---

# 36. PHASE 17 — SQLite Database Export

Provide an option to export the SQLite database file itself.

The exported file should be a copy of the database, not the actively open database file where platform restrictions make direct copying unsafe.

Recommended process:

```text
Close/flush database operations
       ↓
Create safe database copy
       ↓
Place copy in temporary/export location
       ↓
Share/save file
```

The exported file should have a meaningful filename, for example:

```text
mineral_receipts_backup_2026-08-20.sqlite
```

Do not corrupt the live database during export.

---

# 37. PHASE 18 — File Sharing

Use:

```text
share_plus
```

for sharing exported files.

The user should be able to invoke the operating system's share sheet.

Possible destinations include:

* Google Drive
* WhatsApp
* Email
* Files
* Other installed applications

The app should **not implement Google Drive API integration**.

Instead:

```text
Export File
     ↓
share_plus
     ↓
Android/iOS Share Sheet
     ↓
User chooses Google Drive
```

This keeps the application simple and avoids authentication/API integration with Google Drive.

---

# 38. Export Options

Provide appropriate export actions through the existing UI or a suitable existing menu.

Possible options:

```text
Export SQLite Backup
Export CSV
Export PDF
Share
```

Do not add a large amount of unnecessary UI.

---

# 39. Data Backup Philosophy

SQLite is the source of truth.

There is no cloud synchronization.

The application should make it easy for the user to manually create backups.

Recommended backup options:

```text
SQLite Backup
CSV Export
PDF Export
```

The user is responsible for saving backups to Google Drive or another storage provider.

---

# 40. PHASE 19 — Offline Behavior

The entire core application must work without internet.

Test with:

```text
Wi-Fi OFF
Mobile Data OFF
```

Verify:

* Home
* New Receipt
* Receipt Preview
* QR generation
* Receipt History
* Search
* Edit
* Delete
* PDF generation
* SQLite export
* CSV export

all continue to function.

Printing should work whenever the selected printer connection itself is available.

---

# 41. PHASE 20 — Error Handling

Handle errors gracefully.

Potential errors:

### Database

* Database initialization failure
* Corrupt database
* Migration failure
* Write failure
* Read failure

### Printer

* Printer unavailable
* Bluetooth unavailable
* Connection failure
* Network printer unavailable
* Printer disconnected
* Unsupported printer

### Export

* File creation failure
* Permission failure
* Share failure

Never expose raw stack traces to the user.

Log technical errors for debugging but show simple messages in the UI.

---

# 42. PHASE 21 — Database Migrations

Use Drift migrations properly.

Whenever the schema changes:

1. Increase schema version.
2. Add migration logic.
3. Preserve existing receipt data.
4. Test upgrading from the previous database version.

Never simply delete the user's database during development.

Never use destructive migration in production unless explicitly instructed.

---

# 43. PHASE 22 — Dependency Management

Keep dependencies minimal.

Core dependencies should include only what is necessary.

Expected packages include:

```text
drift
sqlite3_flutter_libs
provider
intl
qr_flutter
pdf
printing
shared_preferences
share_plus
unified_esc_pos_printer
path_provider
```

Use the latest stable versions compatible with the project's Flutter/Dart version.

Before adding a package:

1. Check whether the existing project already provides the functionality.
2. Prefer mature and actively maintained packages.
3. Avoid duplicate packages that solve the same problem.
4. Verify Android/iOS compatibility.
5. Run `flutter pub get`.
6. Run `flutter analyze`.

Do not blindly add dependencies.

---

# 44. Recommended Project Structure

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

# 45. Service Responsibilities

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

# 46. Receipt Output Consistency

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

# 47. Receipt Printing Workflow

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

# 48. Home Screen

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

# 49. Receipt History

The history screen must query SQLite rather than loading everything into memory unnecessarily.

For large datasets, use:

* Pagination
* Lazy loading
* Database-level search

where appropriate.

Do not perform expensive filtering entirely inside Dart if SQLite can efficiently perform the query.

---

# 50. Testing Strategy

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

# 51. Development Process

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

# 52. Phase Completion Rules

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

# 53. Agent Behavior

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

# 54. Explicitly Prohibited

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

# 55. Final Definition of Done

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
