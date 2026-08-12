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

# PHASE 3 — Receipt Preview & Verification

Goal

Implement receipt preview.

Requirements

Pressing "Generate Receipt" must NOT print immediately.

Workflow:

Create Receipt

↓

Generate Receipt object

↓

Open Preview

↓

Display all entered values

↓

Ask:

"Are all the details correct?"

Only after confirmation may printing proceed.

Completion Criteria

Printing is blocked until confirmation.

---

# PHASE 4 — Firestore Integration

Goal

Store receipts.

Create:

Firestore collection:

receipts

Implement:

Create receipt

Read receipts

Update receipt

Delete receipt

Sort by newest first.

Store timestamps using server timestamps where appropriate.

Completion Criteria

CRUD operations work correctly.

---

# PHASE 5 — Receipt History

Goal

Connect the existing Receipt History UI.

Implement:

* Load all receipts
* Search
* Sorting
* Pull-to-refresh
* Empty state handling
* Loading state
* Error handling

Search should support:

* Voucher Number
* Buyer Name
* Vehicle Number

Completion Criteria

History screen fully functional.

---

# PHASE 6 — Receipt Details

Goal

Connect the detail screen.

Display all stored information.

Buttons:

* Edit
* Delete
* Print

Deletion requires confirmation.

Completion Criteria

Receipt detail screen fully operational.

---

# PHASE 7 — Editing Receipts

Goal

Allow editing.

Load Firestore data into the existing form.

Implement:

* Update receipt
* Save changes
* Refresh history
* Refresh detail screen

Completion Criteria

Editing works without creating duplicate receipts.

---

# PHASE 8 — QR Code Generation

Goal

Generate QR codes.

Use an appropriate Flutter package.

The QR code should encode either:

* Receipt ID (preferred)
* Voucher Number

Display the QR code:

* Preview screen
* Printed receipt

Completion Criteria

Every receipt has a valid QR code.

---

# PHASE 9 — PDF Generation

Goal

Generate printable receipts.

Use:

pdf

Create:

PdfService

The PDF must mirror the existing receipt design exactly.

Include:

Business information

Receipt information

Mineral information

QR code

Footer

Completion Criteria

PDF generation matches the designed receipt layout.

---

# PHASE 10 — Printer Integration

Goal

Support receipt printers.

Use suitable Flutter packages for:

Bluetooth printers

Wi-Fi printers

Implement:

Printer discovery

Printer selection

Connection

Automatic reconnection

Test print

Actual receipt printing

Store the selected printer locally so it reconnects automatically when possible.

Completion Criteria

Users can print receipts with one action after confirmation.

---

# PHASE 11 — Local Preferences

Use SharedPreferences.

Store:

* Selected printer
* Printer type
* Last printer IP
* Last Bluetooth device
* Application preferences

Do not store receipt data locally.

Firestore remains the source of truth.

---

# PHASE 12 — Error Handling

Handle gracefully:

No internet

Firestore unavailable

Printer disconnected

Bluetooth disabled

Wi-Fi unavailable

PDF generation failures

Printing failures

Display clear, user-friendly error messages.

---

# PHASE 13 — Performance Optimization

Optimize:

Firestore reads

Firestore writes

Widget rebuilds

Provider listeners

Memory usage

Large receipt history

Avoid unnecessary rebuilds.

---

# PHASE 14 — Testing

Verify:

Receipt creation

Receipt editing

Receipt deletion

Receipt history

Search

Firestore synchronization

QR generation

PDF generation

Printer connection

Printing

App restart

Offline behavior

No crashes
