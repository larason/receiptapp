import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receiptapp/core/constants/app_constants.dart';
import 'package:receiptapp/core/validators/receipt_validators.dart';
import 'package:receiptapp/providers/receipt_form_controller.dart';
import 'package:receiptapp/screens/verify_receipt_screen.dart';

class CreateReceiptScreen extends StatefulWidget {
  const CreateReceiptScreen({super.key});

  @override
  State<CreateReceiptScreen> createState() => _CreateReceiptScreenState();
}

class _CreateReceiptScreenState extends State<CreateReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ReceiptFormController>();
    const primaryColor = Color(0xFF0F57A6);
    const labelStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF333333),
    );

    return Column(
      children: [
        // App Bar
        AppBar(
          backgroundColor: const Color(0xFFF8FAFC),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: primaryColor),
            onPressed: () {},
          ),
          title: const Text(
            'Create Receipt',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),

        // Screen Body Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Voucher Generation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fill in the mineral transaction details below.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mineral Type', style: labelStyle),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: controller.mineralType,
                          decoration: _inputDecoration(),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          items: AppConstants.mineralTypes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.mineralType = value;
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        const Text('Voucher Number', style: labelStyle),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAEFF5),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: const Text(
                                'A437',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: controller.voucherNumberController,
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    ReceiptValidators.requiredField(value) ??
                                    ReceiptValidators.voucherNumber(value),
                                decoration: _inputDecoration(
                                  hintText: 'Enter digits',
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        const Text('Mineral Value', style: labelStyle),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAEFF5),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: const Text(
                                'TZS',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: controller.mineralValueController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                validator: (value) =>
                                    ReceiptValidators.requiredField(value) ??
                                    ReceiptValidators.number(
                                      value,
                                      allowDecimal: true,
                                      message: 'Enter a valid amount.',
                                    ),
                                decoration: _inputDecoration(
                                  hintText: '0.00',
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        const Text('Quantity (kg/ct)', style: labelStyle),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: controller.quantityController,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              ReceiptValidators.requiredField(value) ??
                              ReceiptValidators.number(
                                value,
                                allowDecimal: true,
                                message: 'Enter a valid quantity.',
                              ),
                          decoration: _inputDecoration(
                            hintText: 'Enter amount',
                          ),
                        ),
                        const SizedBox(height: 20),

                        Divider(color: Colors.grey.shade200, thickness: 1),
                        const SizedBox(height: 16),

                        const Text('Vehicle Number', style: labelStyle),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: controller.vehicleNumberController,
                          validator: ReceiptValidators.requiredField,
                          decoration: _inputDecoration(
                            hintText: 'e.g., T 123 ABC',
                          ),
                        ),
                        const SizedBox(height: 16),

                        const Text('Transport Phone', style: labelStyle),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: controller.transportPhoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              ReceiptValidators.requiredField(value) ??
                              ReceiptValidators.phone(value),
                          decoration: _inputDecoration(hintText: '+255...'),
                        ),
                        const SizedBox(height: 16),

                        const Text('Buyer Name', style: labelStyle),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: controller.buyerNameController,
                          validator: ReceiptValidators.requiredField,
                          decoration: _inputDecoration(
                            hintText: 'Full legal name',
                          ),
                        ),
                        const SizedBox(height: 16),

                        const Text('Destination', style: labelStyle),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: controller.destinationController,
                          validator: ReceiptValidators.requiredField,
                          decoration: _inputDecoration(
                            hintText: 'City or Delivery Point',
                          ),
                        ),
                        const SizedBox(height: 20),

                        Divider(color: Colors.grey.shade200, thickness: 1),
                        const SizedBox(height: 16),

                        _buildInfoCard(
                          label: 'PRODUCTION CENTER',
                          value: 'Central Mineral Hub',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          label: 'SELLER NAME',
                          value: 'Official Dealer',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          label: 'LICENSE NUMBER',
                          value: 'LIC-2024-889',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          label: 'SALES DATE & TIME',
                          value: _formatTimestamp(controller.salesDate),
                          icon: Icons.calendar_today_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
                // Preview Receipt Button
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final receiptForm = context.read<ReceiptFormController>();
                      if (!receiptForm.validateAndBuild()) return;
                      final receipt = receiptForm.draftReceipt;
                      if (receipt == null) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VerifyReceiptScreen(receipt: receipt),
                        ),
                      );
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                    label: const Text(
                      'Preview Receipt',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: const BorderSide(color: primaryColor, width: 1.5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

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

  String _formatTimestamp(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)} ${_months[dt.month - 1]} ${dt.year} '
        '${two(dt.hour)}:${two(dt.minute)}';
  }

  InputDecoration _inputDecoration({
    String? hintText,
    BorderRadius? borderRadius,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF3F5F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF0F57A6), width: 1.5),
      ),
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: icon != null
                      ? const Color(0xFF0F57A6)
                      : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          if (icon != null)
            Icon(icon, size: 20, color: const Color(0xFF0F57A6)),
        ],
      ),
    );
  }
}
