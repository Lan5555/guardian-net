// lib/widgets/community_alerts_list.dart
import 'package:flutter/material.dart';
import 'package:guardian_net/providers/alert_provider.dart';
import 'package:provider/provider.dart';
import '../models/alert_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityAlertsList extends StatelessWidget {
  const CommunityAlertsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AlertProvider>(
      builder: (context, provider, child) {
        if (provider.alerts.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0FDF4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shield_outlined, size: 32, color: Color(0xFF16A34A)),
                ),
                const SizedBox(height: 16),
                const Text('All Clear', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                const Text('No active alerts in your community right now.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          );
        }
        final alerts = provider.alerts.take(3).toList();
        return Column(
          children: alerts.map((alert) => _AlertItem(alert: alert)).toList(),
        );
      },
    );
  }
}

class _AlertItem extends StatefulWidget {
  final AlertModel alert;
  const _AlertItem({required this.alert});

  @override
  State<_AlertItem> createState() => _AlertItemState();
}

class _AlertItemState extends State<_AlertItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _expanded ? const Color(0xFF2563EB).withValues(alpha:0.3) : const Color(0xFFF1F5F9)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: (widget.alert.subject ?? '').toUpperCase().contains('PANIC') ? const Color(0xFFFEF2F2) : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text((widget.alert.subject ?? 'ALERT').toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: (widget.alert.subject ?? '').toUpperCase().contains('PANIC') ? const Color(0xFFEF4444) : const Color(0xFF2563EB))),
                  ),
                  if (!_expanded)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          widget.alert.title ?? 'No Title',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      Text(_expanded ? 'Hide' : 'View', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                      const SizedBox(width: 4),
                      Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16, color: const Color(0xFF64748B)),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity, height: 0),
              secondChild: Column(
                children: [
              const SizedBox(height: 10),
              Align(alignment: Alignment.centerLeft, child: Text(widget.alert.title ?? 'Emergency Alert', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800))),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: widget.alert.subject == 'LOCATION_SHARE' && widget.alert.message != null && widget.alert.message!.contains('http')
                    ? InkWell(
                        onTap: () async {
                          final url = RegExp(r'(https?://[^\s]+)').stringMatch(widget.alert.message!);
                          if (url != null) {
                            final uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          }
                        },
                        child: Text(widget.alert.message!,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF2563EB), decoration: TextDecoration.underline)),
                      )
                    : Text(widget.alert.message ?? '', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _MetaChip(icon: Icons.location_on_outlined, text: widget.alert.location ?? 'Unknown Location'),
                ],
              ),
              Row(
                children: [
                  _MetaChip(icon: Icons.person, text: 'Reporter: ${widget.alert.reporter}'),
                ],
              ),
              const SizedBox(height: 8),
              if ((widget.alert.subject ?? '').toUpperCase().contains('PANIC'))
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.verified, size: 14, color: Color(0xFF16A34A)),
                      SizedBox(width: 8),
                      Expanded(child: Text('SECURED: Responders dispatched via SMS/RFID', style: TextStyle(fontSize: 11, color: Color(0xFF15803D), fontWeight: FontWeight.w700))),
                    ],
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: 'Confirm',
                        icon: Icons.check_circle,
                        color: const Color(0xFF16A34A),
                        backgroundColor: const Color(0xFFF0FDF4),
                        onTap: () {
                          Provider.of<AlertProvider>(context, listen: false).verifyCommunityAlert(widget.alert.reportedId.toString());
                          _showToast(context, '✅ Alert verified! Responders notified.');
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ActionButton(
                        label: 'False',
                        icon: Icons.cancel,
                        color: const Color(0xFFEF4444),
                        backgroundColor: const Color(0xFFFEE2E2),
                        onTap: () {
                          Provider.of<AlertProvider>(context, listen: false).flagAlertAsFalse(widget.alert.reportedId.toString());
                          _showToast(context, '⚠️ Alert flagged as false. Trust penalty applied.');
                        },
                      ),
                    ),
                  ],
                ),
                ],
              ),
              crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 10, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;
  const _ActionButton({required this.label, required this.icon, required this.color, required this.backgroundColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}