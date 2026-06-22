// lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:guardian_net/models/alert_model.dart';
import 'package:guardian_net/modules/history/controller/history_controller.dart';
import 'package:guardian_net/providers/alert_provider.dart';
import 'package:guardian_net/providers/session_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late HistoryController controller;
  @override
  void initState() {
    super.initState();
    controller = HistoryController(context: context);
    controller.addListener(() {
      setState(() {});
    });
    controller.fetchHistory();
    context.read<SessionProvider>().startTracking();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchHistory();
      },
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SectionTitle(
              icon: Icons.auto_graph_rounded,
              title: 'Activity Timeline',
            ),
            const SizedBox(height: 16),
            Consumer<SessionProvider>(
              builder: (context, sessionProvider, child) {
                // final userReports = controller.history
                //     .where((a) => a.reportedId == sessionProvider.user?.id)
                //     .toList();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatCard(
                      title: 'All Reports',
                      value: controller.history.length.toString(),
                      icon: Icons.campaign_outlined,
                      color: const Color(0xFF0F172A),
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      title: 'Community ID',
                      value:
                          sessionProvider.user?.communityId?.toString() ??
                          'Loading...',
                      icon: Icons.public_outlined,
                      color: const Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 8),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Consumer<SessionProvider>(
              builder: (context, sessionProvider, child) {
                if (controller.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                // final userReports = controller.history
                //     .where((a) => a.reportedId == sessionProvider.user?.id)
                //     .toList();

                if (controller.history.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 60,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.history_toggle_off_rounded,
                          size: 48,
                          color: Color(0xFFCBD5E1),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No reports yet',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Send an alert to build your safety history.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: controller.history
                      .map((report) => _HistoryCard(report: report))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color == const Color(0xFF0F172A)
              ? const Color(0xFF0F172A)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color == const Color(0xFF0F172A)
                ? Colors.transparent
                : const Color(0xFFF1F5F9),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 20,
              color: color == const Color(0xFF0F172A) ? Colors.white : color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color == const Color(0xFF0F172A)
                    ? Colors.white
                    : const Color(0xFF0F172A),
              ),
            ),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: color == const Color(0xFF0F172A)
                    ? Colors.white70
                    : const Color(0xFF64748B),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatefulWidget {
  final AlertModel report;
  const _HistoryCard({required this.report});
  @override
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<_HistoryCard> {
  bool isLoading = false;
  late HistoryController controller;
  String _formatDate(DateTime? date) {
    if (date == null) return 'Just now';
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes == 0 ? 1 : difference.inMinutes}m ago';
    }
    return DateFormat('MMM d, h:mm a').format(date);
  }

  @override
  void initState() {
    super.initState();
    controller = HistoryController(context: context);
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, modalState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.history_edu,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.report.subject?.toUpperCase() ?? 'ALERT',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF64748B),
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            widget.report.title ?? 'Emergency Alert',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Incident Description',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                widget.report.subject == 'LOCATION_SHARE' &&
                        widget.report.message != null &&
                        widget.report.message!.contains('http')
                    ? InkWell(
                        onTap: () async {
                          final url = RegExp(
                            r'(https?://[^\s]+)',
                          ).stringMatch(widget.report.message!);
                          if (url != null) {
                            final uri = Uri.parse(url);
                            if (await canLaunchUrl(uri) || true) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          }
                        },
                        child: Text(
                          widget.report.message!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF2563EB),
                            decoration: TextDecoration.underline,
                            height: 1.5,
                          ),
                        ),
                      )
                    : Text(
                        widget.report.message ??
                            'No additional details provided for this alert.',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF334155),
                          height: 1.5,
                        ),
                      ),
                const SizedBox(height: 24),
                _detailItem(
                  Icons.location_on_outlined,
                  'Location',
                  widget.report.location ?? 'Unknown Location',
                  false,
                ),
                _detailItem(
                  Icons.calendar_today_outlined,
                  'Date Reported',
                  widget.report.createdAt?.toString().split('.')[0] ??
                      'Just now',
                  false,
                ),
                _detailItem(
                  Icons.badge,
                  'Status',
                  widget.report.isVerified ? 'Verified' : 'Not Verified',
                  !widget.report.isVerified,
                  isLoading: context.read<AlertProvider>().isLoading,
                  action: () async {
                    final callback = context.read<AlertProvider>();
                    final user = context.read<SessionProvider>().user;

                    await callback.verifyCommunityAlert(
                      user!.id,
                      widget.report.id!,
                      context,
                      setModalState: modalState,
                      callback: () {
                        controller.fetchHistory();
                      },
                    );
                  },
                  actionName: 'Verify',
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Close Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetails(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: ShapeDecoration(
                    color:
                        (widget.report.subject ?? '').toUpperCase().contains(
                          'PANIC',
                        )
                        ? const Color(0xFFFEF2F2)
                        : const Color(0xFFF1F5F9),
                    shape: StadiumBorder(),
                  ),
                  child: Text(
                    (widget.report.subject ?? 'ALERT').toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color:
                          (widget.report.subject ?? '')
                              .toString()
                              .toUpperCase()
                              .contains('PANIC')
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF2563EB),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 12,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(widget.report.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              widget.report.title ?? 'Emergency Alert',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            if (widget.report.message != null &&
                widget.report.message!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                widget.report.message!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  height: 1.3,
                ),
              ),
            ],
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 12,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.report.location ?? 'Unknown Location',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.report.isVerified
                        ? const Color(0xFFF0FDF4)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user_rounded,
                        size: 12,
                        color: widget.report.isVerified
                            ? Color(0xFF16A34A)
                            : Color.fromARGB(255, 191, 23, 23),
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.report.isVerified ? 'Verified' : 'Not Verified',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: widget.report.isVerified
                              ? Color(0xFF16A34A)
                              : Colors.red.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Color(0xFFCBD5E1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _detailItem(
  IconData icon,
  String label,
  String value,
  bool hasAction, {
  Function()? action,
  String? actionName,
  bool? isLoading,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            if (hasAction)
              ElevatedButton(
                onPressed: () => action!(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
                child: isLoading!
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(actionName!),
              ),
          ],
        ),
      ],
    ),
  );
}

class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const SectionTitle({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF0F172A)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
