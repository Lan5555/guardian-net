// lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:guardian_net/providers/app_state_provider.dart';
import 'package:provider/provider.dart';


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SectionTitle(icon: Icons.history, title: 'Activity Timeline'),
          const SizedBox(height: 8),
          Consumer<AppStateProvider>(
            builder: (context, provider, child) {
              return Row(
                children: [
                  _StatCard(
                    title: 'Total Reports',
                    value: provider.userReports.length.toString(),
                    color: const Color(0xFFF1F5F9),
                    textColor: const Color(0xFF0F172A),
                  ),
                  const SizedBox(width: 8),
                  _StatCard(
                    title: 'Verified',
                    value: provider.userReports.where((r) => r.verified).length.toString(),
                    color: const Color(0xFFF0FDF4),
                    textColor: const Color(0xFF16A34A),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Consumer<AppStateProvider>(
            builder: (context, provider, child) {
              if (provider.userReports.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F9FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text('No reports yet. Send an alert to build history.'),
                  ),
                );
              }
              return Column(
                children: provider.userReports.map((report) => _HistoryCard(report: report)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final Color textColor;
  const _StatCard({required this.title, required this.value, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textColor)),
            Text(title.toUpperCase(), style: TextStyle(fontSize: 10, color: textColor)),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final dynamic report;
  const _HistoryCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final isVerified = report.verified;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(report.type.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF2563EB))),
              ),
              Text(report.timestamp, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
            ],
          ),
          const SizedBox(height: 8),
          Text(report.description, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isVerified ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isVerified ? Icons.check_circle : Icons.hourglass_empty, size: 12, color: isVerified ? const Color(0xFF16A34A) : const Color(0xFFB45309)),
                const SizedBox(width: 4),
                Text(isVerified ? 'Community Verified' : 'Awaiting Verification', style: TextStyle(fontSize: 10, color: isVerified ? const Color(0xFF16A34A) : const Color(0xFFB45309))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const SectionTitle({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2563EB)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
      ],
    );
  }
}