// lib/widgets/panic_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:guardian_net/providers/alert_provider.dart';
import 'package:provider/provider.dart';

class PanicButton extends StatelessWidget {
  const PanicButton({super.key});

  @override
  Widget build(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context);
    return GestureDetector(
      onTap: alertProvider.isLoading
          ? null
          : () async {
              await alertProvider.triggerPanic(context);
              if (context.mounted) {
                _showToast(
                  context,
                  '🔴 PANIC MODE: Police, fire & neighbors alerted! Live location shared.',
                );
              }
            },
      child:
          Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x4CEF4444),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: alertProvider.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(
                        Icons.warning_rounded,
                        size: 36,
                        color: Colors.white,
                      ),
              )
              .animate(
                onComplete: (controller) {
                  controller.loop();
                },
              )
              .shimmer(
                duration: Duration(milliseconds: 1500),
                delay: Duration(seconds: 1),
              ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
