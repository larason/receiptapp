import 'package:flutter/material.dart';
import '../models/receipt_record.dart';
import 'receipt_details.dart';

class ReceiptHistoryScreen extends StatefulWidget {
  final Function(ReceiptRecord)? onReceiptTap;

  const ReceiptHistoryScreen({super.key, this.onReceiptTap});

  @override
  State<ReceiptHistoryScreen> createState() => _ReceiptHistoryScreenState();
}

class _ReceiptHistoryScreenState extends State<ReceiptHistoryScreen> {
  int _selectedFilterIndex = 0;
  String _searchQuery = '';
  final List<String> _filters = [
    'Today',
    'This Week',
    'This Month',
    'This Year',
  ];

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final List<ReceiptRecord> _receipts = [
    ReceiptRecord(
      voucherNo: 'V-2024-001',
      buyer: 'Global Minerals Ltd',
      mineralType: 'Copper Concentrate',
      valueTzs: '14,250,000',
      date: _formatDate(DateTime.now()),
      quantity: '1,250 kg',
      vehicleNumber: 'T 123 ABC',
      transportPhone: '+255 744 555 123',
      destination: 'Dar es Salaam Port',
      productionCenter: 'Central Mineral Hub',
      sellerName: 'Official Dealer',
      licenseNumber: 'LIC-2024-889',
    ),
    ReceiptRecord(
      voucherNo: 'V-2024-002',
      buyer: 'East Africa Ores',
      mineralType: 'Gold Bullion (1kg)',
      valueTzs: '182,400,000',
      date: _formatDate(DateTime.now().subtract(const Duration(days: 3))),
      quantity: '1 kg',
      vehicleNumber: 'T 456 DEF',
      transportPhone: '+255 744 555 456',
      destination: 'Mwanza Port',
      productionCenter: 'Geita Gold Hub',
      sellerName: 'Licensed Gold Dealer',
      licenseNumber: 'LIC-2024-890',
    ),
    ReceiptRecord(
      voucherNo: 'V-2024-003',
      buyer: 'Summit Mining Co.',
      mineralType: 'Graphite Grade A',
      valueTzs: '8,900,000',
      date: _formatDate(DateTime.now().subtract(const Duration(days: 20))),
      quantity: '2,400 kg',
      vehicleNumber: 'T 789 GHI',
      transportPhone: '+255 744 555 789',
      destination: 'Tanga Port',
      productionCenter: 'Mererani Graphite Hub',
      sellerName: 'Licensed Mineral Dealer',
      licenseNumber: 'LIC-2024-891',
    ),
  ];

  final List<ReceiptRecord> _moreReceipts = [
    ReceiptRecord(
      voucherNo: 'V-2024-004',
      buyer: 'Nile Valley Metals',
      mineralType: 'Diamond',
      valueTzs: '64,000,000',
      date: _formatDate(DateTime.now().subtract(const Duration(days: 45))),
      quantity: '320 ct',
      vehicleNumber: 'T 321 JKL',
      transportPhone: '+255 744 555 321',
      destination: 'Dodoma Hub',
      productionCenter: 'Mwadui Diamond Mine',
      sellerName: 'Licensed Diamond Dealer',
      licenseNumber: 'LIC-2024-892',
    ),
    ReceiptRecord(
      voucherNo: 'V-2024-005',
      buyer: 'Lake Zone Traders',
      mineralType: 'Iron Ore',
      valueTzs: '21,500,000',
      date: _formatDate(DateTime.now().subtract(const Duration(days: 75))),
      quantity: '18,000 kg',
      vehicleNumber: 'T 654 MNO',
      transportPhone: '+255 744 555 654',
      destination: 'Mwanza Port',
      productionCenter: 'Liganga Iron Hub',
      sellerName: 'Licensed Iron Dealer',
      licenseNumber: 'LIC-2024-893',
    ),
  ];

  List<ReceiptRecord> get _visibleReceipts {
    final query = _searchQuery.trim().toLowerCase();
    return _receipts.where((receipt) {
      final matchesSearch =
          query.isEmpty ||
          receipt.voucherNo.toLowerCase().contains(query) ||
          receipt.buyer.toLowerCase().contains(query) ||
          receipt.vehicleNumber.toLowerCase().contains(query);
      return matchesSearch && _matchesFilter(receipt);
    }).toList();
  }

  bool _matchesFilter(ReceiptRecord receipt) {
    final date = _parseDate(receipt.date);
    if (date == null) return true;
    final now = DateTime.now();
    switch (_selectedFilterIndex) {
      case 0: // Today
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      case 1: // This Week (within the last 7 days)
        final daysAgo = now.difference(date).inDays;
        return daysAgo >= 0 && daysAgo < 7;
      case 2: // This Month
        return date.year == now.year && date.month == now.month;
      case 3: // This Year
        return date.year == now.year;
    }
    return true;
  }

  DateTime? _parseDate(String value) {
    final parts = value.split(' ');
    if (parts.length != 3) return null;
    final month = _months.indexOf(parts[0]) + 1;
    if (month == 0) return null;
    final day = int.tryParse(parts[1].replaceAll(',', ''));
    final year = int.tryParse(parts[2]);
    if (day == null || year == null) return null;
    return DateTime(year, month, day);
  }

  static String _formatDate(DateTime date) =>
      '${_months[date.month - 1]} ${date.day}, ${date.year}';

  void _loadMore() {
    setState(() {
      _receipts.addAll(_moreReceipts);
      _moreReceipts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F57A6);
    const secondaryTextColor = Color(0xFF64748B);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Receipt History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),

          // Search Field
          TextField(
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
            decoration: InputDecoration(
              hintText: 'Search Voucher, Buyer, or Vehicle...',
              hintStyle: const TextStyle(
                color: secondaryTextColor,
                fontSize: 14,
              ),
              prefixIcon: const Icon(Icons.search, color: secondaryTextColor),
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Filter Chips
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;
                return ChoiceChip(
                  label: Text(_filters[index]),
                  selected: isSelected,
                  selectedColor: primaryColor,
                  backgroundColor: const Color(0xFFE2E8F0),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 12,
                  ),
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide.none,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedFilterIndex = index);
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Receipt List
          if (_visibleReceipts.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No receipts match your search or filter.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _visibleReceipts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final receipt = _visibleReceipts[index];
                return _ReceiptHistoryCard(
                  receipt: receipt,
                  onTap: () {
                    if (widget.onReceiptTap != null) {
                      widget.onReceiptTap!(receipt);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReceiptDetailsScreen(receipt: receipt),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          const SizedBox(height: 20),

          // Load More History Button (hidden once all history is loaded)
          if (_moreReceipts.isNotEmpty)
            Center(
              child: OutlinedButton.icon(
                onPressed: _loadMore,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: primaryColor,
                ),
                label: const Text(
                  'Load More History',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// Receipt Item Card Widget
class _ReceiptHistoryCard extends StatelessWidget {
  final ReceiptRecord receipt;
  final VoidCallback onTap;

  const _ReceiptHistoryCard({required this.receipt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F57A6);
    const labelStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: Color(0xFF64748B),
      letterSpacing: 0.5,
    );

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Voucher & Buyer
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('VOUCHER #', style: labelStyle),
                        const SizedBox(height: 2),
                        Text(
                          receipt.voucherNo,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('BUYER', style: labelStyle),
                        const SizedBox(height: 2),
                        Text(
                          receipt.buyer,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                    // Overflow action: open this receipt's details.
                    onPressed: onTap,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Row 2: Mineral Type & Value
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('MINERAL TYPE', style: labelStyle),
                        const SizedBox(height: 2),
                        Text(
                          receipt.mineralType,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('VALUE (TZS)', style: labelStyle),
                        const SizedBox(height: 2),
                        Text(
                          receipt.valueTzs,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Row 3: Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DATE', style: labelStyle),
                  const SizedBox(height: 2),
                  Text(
                    receipt.date,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
