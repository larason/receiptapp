# future instructions

* add firebase firestore database

* add a login screen but the registration isonly via the console

* Do not present this QR code as authenticity verification.

  QrImageView encodes only receipt.voucherNo. A scanner will return that
  plain identifier. It cannot open an official portal or prove that the
  receipt is authentic.

  Use a backend-issued verification URL or signed token before showing this
  claim. Otherwise, remove the verification instruction until the
  verification service is available.

# THE FUTURE PHASES

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
