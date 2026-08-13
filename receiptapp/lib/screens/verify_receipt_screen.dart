import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:receiptapp/core/constants/app_constants.dart';
import 'package:receiptapp/core/utils/date_formatter.dart';
import 'package:receiptapp/models/receipt.dart';

class VerifyReceiptScreen extends StatelessWidget {
  /// The receipt produced by the form, validated in Phase 2.
  ///
  /// Displayed on this screen starting in Phase 3 — Receipt Preview &
  /// Verification.
  final Receipt? receipt;
  final VoidCallback? onBackToEdit;
  final VoidCallback? onPrintReceipt;

  const VerifyReceiptScreen({
    super.key,
    this.receipt,
    this.onBackToEdit,
    this.onPrintReceipt,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F57A6);
    const secondaryTextColor = Color(0xFF64748B);

    final receipt = this.receipt;
    final mineralBadge = _mineralBadge(receipt?.mineralType);
    final valueText = _formatNumber(receipt?.mineralValue);
    final totalText = valueText == '—'
        ? '—'
        : '$valueText ${AppConstants.currencyCode}';
    final issueDate = receipt == null
        ? '—'
        : DateFormatter.historyDate(receipt.salesDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        automaticallyImplyLeading: false, // Removes the hamburger menu icon
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: onBackToEdit ?? () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Verify Receipt',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),

      // Scrollable Body Content
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle explanation (Breadcrumb & main title removed)
            const Text(
              'Review the transaction data before final generation and export.',
              style: TextStyle(fontSize: 13, color: secondaryTextColor),
            ),
            const SizedBox(height: 16),

            // Main Card Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Blue Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Summary Review',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'DRAFT MODE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer Information Section
                        const Text(
                          'CUSTOMER INFORMATION',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoDetailItem(
                                label: 'Customer Name',
                                value: _orPlaceholder(receipt?.buyerName),
                              ),
                              const SizedBox(height: 8),
                              _InfoDetailItem(
                                label: 'License Number',
                                value: _orPlaceholder(receipt?.licenseNumber),
                              ),
                              const SizedBox(height: 8),
                              _InfoDetailItem(
                                label: 'Phone Number',
                                value: _orPlaceholder(receipt?.transportPhone),
                              ),
                              const SizedBox(height: 8),
                              _InfoDetailItem(
                                label: 'Location',
                                value: _orPlaceholder(receipt?.destination),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Mineral Line Items Section
                        const Text(
                          'MINERAL LINE ITEMS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              // Table Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEDEBF7),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Item',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Grade',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Weight',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Mineral Row
                              _TableRowItem(
                                item: _orPlaceholder(receipt?.mineralType),
                                badgeText: mineralBadge.text,
                                badgeColor: mineralBadge.background,
                                badgeTextColor: mineralBadge.foreground,
                                weight: _orPlaceholder(receipt?.quantity),
                              ),
                              const Divider(
                                height: 1,
                                color: Color(0xFFE2E8F0),
                              ),

                              // Total Row
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEEF2FF),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Total Payable Amount',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      totalText,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Meta Information List
                        _MetaInfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Issue Date',
                          value: issueDate,
                        ),
                        const SizedBox(height: 12),
                        _MetaInfoRow(
                          icon: Icons.local_shipping_outlined,
                          label: 'Vehicle Number',
                          value: _orPlaceholder(receipt?.vehicleNumber),
                        ),
                        const SizedBox(height: 12),
                        _MetaInfoRow(
                          icon: Icons.confirmation_number_outlined,
                          label: 'Voucher Number',
                          value: _orPlaceholder(receipt?.voucherNumber),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Are All Details Correct Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF2F7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD3E2F8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified_outlined,
                      color: primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Are all the details correct?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Please confirm that all data points match the physical manifest provided by the trader.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: secondaryTextColor),
                  ),
                  const SizedBox(height: 16),

                  // Print Receipt Button
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: onPrintReceipt,
                      icon: const Icon(
                        Icons.print_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Print Receipt',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Back to Edit Button
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      onPressed:
                          onBackToEdit ?? () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: primaryColor,
                        size: 18,
                      ),
                      label: const Text(
                        'Back to Edit',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFE2E8F0),
                        side: const BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Finalizing Note Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: secondaryTextColor,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Finalizing this receipt will deduct items from the current inventory ledger and generate a unique tracking QR code.',
                            style: TextStyle(
                              fontSize: 11,
                              color: secondaryTextColor,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Returns the value or an em-dash placeholder when it is null or blank.
  String _orPlaceholder(String? value) {
    if (value == null || value.trim().isEmpty) return '—';
    return value;
  }

  /// Formats a numeric string with thousands separators (e.g. `1,500,000`).
  String _formatNumber(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '—';
    final number = num.tryParse(text);
    return number == null ? text : NumberFormat('#,##0.##').format(number);
  }

  /// Grade badge label and colors for a mineral type.
  ({String text, Color background, Color foreground}) _mineralBadge(
    String? mineralType,
  ) {
    switch (mineralType) {
      case 'Gold Concentrate':
        return (
          text: 'GOLD',
          background: const Color(0xFFECEFF1),
          foreground: const Color(0xFF37474F),
        );
      case 'Copper':
        return (
          text: 'COPPER',
          background: const Color(0xFFEFEBE9),
          foreground: const Color(0xFF4E342E),
        );
      case 'Tanzanite':
        return (
          text: 'TANZANITE',
          background: const Color(0xFFE8EAF6),
          foreground: const Color(0xFF1A237E),
        );
      case 'Iron Ore':
        return (
          text: 'IRON ORE',
          background: const Color(0xFFFBE9E7),
          foreground: const Color(0xFFBF360C),
        );
      case 'Diamond':
        return (
          text: 'DIAMOND',
          background: const Color(0xFFE0E7FF),
          foreground: const Color(0xFF3730A3),
        );
      default:
        return (
          text: '—',
          background: const Color(0xFFE2E8F0),
          foreground: const Color(0xFF334155),
        );
    }
  }
}

// Helper Widgets
class _InfoDetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoDetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _TableRowItem extends StatelessWidget {
  final String item;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final String weight;

  const _TableRowItem({
    required this.item,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              weight,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
