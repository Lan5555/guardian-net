// lib/widgets/panic_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';

class PanicButton extends StatelessWidget {
  const PanicButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<AppStateProvider>(context, listen: false).triggerPanic();
        _showToast(context, '🔴 PANIC MODE: Police, fire & neighbors alerted! Live location shared.');
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Color(0x4CEF4444), blurRadius: 15, spreadRadius: 2)],
        ),
        child: const Icon(Icons.warning_rounded, size: 36, color: Colors.white),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }
}