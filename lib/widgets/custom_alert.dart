import 'package:flutter/material.dart';
import 'package:guardian_net/providers/alert_provider.dart';
import 'package:guardian_net/providers/session_provider.dart';
import 'package:provider/provider.dart';
import 'package:guardian_net/helpers/helpers.dart';

class CustomAlertInput extends StatefulWidget {
  const CustomAlertInput({super.key});

  @override
  State<CustomAlertInput> createState() => _CustomAlertInputState();
}

class _CustomAlertInputState extends State<CustomAlertInput> {
  final TextEditingController _messageController = TextEditingController();
  String _selectedType = 'General';
  final List<String> _alertTypes = ['General', 'Suspicious', 'Medical', 'Utility'];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitAlert() async {
    if (_messageController.text.trim().isEmpty) {
      showToast(context, "Please describe the emergency", isError: true);
      return;
    }

    final user = context.read<SessionProvider>().user;
    if (user == null || user.communityId == null) {
      showToast(context, "User session invalid", isError: true);
      return;
    }

    final alertProvider = context.read<AlertProvider>();
    
    await alertProvider.sendNewUserAlert(
      _selectedType.toUpperCase(),
      communityId: user.communityId!,
      userId: user.id,
      userName: user.name,
      context: context,
      message: _messageController.text,
    );

    if (mounted) {
      _messageController.clear();
      showToast(context, "Custom alert broadcasted to community");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _alertTypes.map((type) {
                final isSelected = _selectedType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedType = type),
                    selectedColor: const Color(0xFF0F172A),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(
                      color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _messageController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Describe the situation...',
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Consumer<AlertProvider>(
            builder: (context, provider, child) {
              return SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _submitAlert,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 9, 9, 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: provider.isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text(
                          'Broadcast Alert',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}