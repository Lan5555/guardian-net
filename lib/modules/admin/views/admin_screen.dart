// lib/modules/admin/views/admin_dashboard.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:guardian_net/models/community_model.dart';
import 'package:guardian_net/models/user_model.dart';
import 'package:guardian_net/modules/admin/controller/admin_controller.dart';
import 'package:guardian_net/modules/auth/views/login.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late AdminController _adminController;
  @override
  void initState() {
    super.initState();
    _adminController = AdminController(context: context);
    _adminController.addListener(() {
      setState(() {});
    });
    _adminController.fetchData();
    _adminController.fetchAlerts();
    _adminController.fetchUsers();
  }

  @override
  void dispose() {
    _adminController.dispose();
    super.dispose();
  }

  void _showCommunityDialog({CommunityModel? community}) {
    _adminController.nameController.text = community?.name ?? '';
    _adminController.locationController.text = community?.location ?? '';
    _adminController.longController.text = community?.longitude ?? '';
    _adminController.latController.text = community?.latitude ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          community == null
                              ? "Add New Community"
                              : "Edit Community",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF64748B),
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFF1F5F9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInput(
                      "Community Name",
                      _adminController.nameController,
                      Icons.business,
                    ),
                    _buildInput(
                      "Location Address",
                      _adminController.locationController,
                      Icons.map,
                      setModalState: setModalState,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInput(
                            "Longitude",
                            _adminController.longController,
                            Icons.explore,
                            isNumber: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInput(
                            "Latitude",
                            _adminController.latController,
                            Icons.explore,
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _adminController.isLocalStateLoading
                            ? null
                            : () => _adminController.submitCommunity(
                                id: community?.id,
                                setModalState: setModalState,
                              ),
                        child: _adminController.isLocalStateLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                community == null
                                    ? "Create Community"
                                    : "Update Community",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditUserDialog(UserModel user) {
    _adminController.nameController.text = user.name ?? '';
    _adminController.phoneController.text = user.phone ?? '';
    int? selectedCommunityId = user.communityId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Edit User Profile",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFF1F5F9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInput(
                      "Full Name",
                      _adminController.nameController,
                      Icons.person_outline,
                    ),
                    _buildInput(
                      "phone Number",
                      _adminController.phoneController,
                      Icons.dialer_sip,
                    ),
                    const Text(
                      "Assign Community",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: selectedCommunityId,
                          isExpanded: true,
                          items: _adminController.communities.map((c) {
                            return DropdownMenuItem(
                              value: c.id,
                              child: Text(c.name),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setModalState(() => selectedCommunityId = val),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _adminController.isLocalStateLoading
                            ? null
                            : () async {
                                final payload = <String, dynamic>{
                                  "name": _adminController.nameController.text,
                                  "phone":
                                      _adminController.phoneController.text,
                                  "community_id": selectedCommunityId,
                                };
                                await _adminController.updateUser(
                                  user.id,
                                  payload,
                                  context,
                                  setModalState,
                                );
                              },
                        child: _adminController.isLocalStateLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Save Changes",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
    StateSetter? setModalState,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        readOnly: label == "Longitude" || label == "Latitude",
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon, size: 20, color: const Color(0xFF94A3B8)),
          suffixIcon:
              _adminController.isLocalStateLoading &&
                  label == "Location Address"
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
        onChanged: (val) async {
          if (_adminController.locationController.text.isNotEmpty &&
              setModalState != null) {
            await _adminController.getLatLngFromOSM(val, setModalState);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Admin Console',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2563EB)),
            onPressed: () => _adminController.activeTab == 1
                ? _adminController.fetchUsers()
                : _adminController.fetchData(),
          ),
        ],
        bottom: _adminController.isLoading
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      _buildTab(0, "Communities", Icons.location_city),
                      const SizedBox(width: 8),
                      _buildTab(1, "Users", Icons.people),
                      const SizedBox(width: 8),
                      _buildTab(2, "Alerts", Icons.notification_important),
                    ],
                  ),
                ),
              ),
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Exit Admin Portal?'),
                  content: const Text(
                    'Are you sure you want to log out of the admin console?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Logout'),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _adminController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _adminController.activeTab,
              children: [
                RefreshIndicator(
                  onRefresh: _adminController.fetchData,
                  child: _buildCommunitiesTab(),
                ),
                _buildUsersTab(),
                _buildAlertsTab(),
              ],
            ),
      floatingActionButton: _adminController.activeTab == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showCommunityDialog(),
              backgroundColor: const Color(0xFF0F172A),
              elevation: 4,
              label: const Text(
                "Add Community",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(
                Icons.add_location_alt_rounded,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  Widget _buildTab(int index, String label, IconData icon) {
    final isSelected = _adminController.activeTab == index;
    return GestureDetector(
      onTap: () {
        setState(() => _adminController.activeTab = index);
        if (index == 2 && _adminController.alerts.isEmpty) {
          _adminController.fetchAlerts();
        }
        if (index == 1 && _adminController.users.isEmpty) {
          _adminController.fetchUsers();
        }
        if (index == 0 && _adminController.communities.isEmpty) {
          _adminController.fetchData();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunitiesTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildStatCards(_adminController),
        const SizedBox(height: 32),
        const Text(
          "Managed Communities",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        _adminController.communities.isEmpty
            ? _buildPlaceholderTab(
                "No Communities",
                "Start by adding your first community.",
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _adminController.communities.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final community = _adminController.communities[index];
                  return Dismissible(
                    key: Key(community.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) =>
                        _adminController.deleteCommunity(community.id),
                    child: GestureDetector(
                      onTap: () => _showCommunityDialog(community: community),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.location_city,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    community.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    community.location,
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.edit_note_rounded,
                              color: Color(0xFF94A3B8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildUsersTab() {
    return _adminController.users.isEmpty
        ? _buildPlaceholderTab(
            "No Users Found",
            "Registered users will appear here.",
          )
        : ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: _adminController.users.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final user = _adminController.users[index];
              return Dismissible(
                key: Key('user_${user.id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                onDismissed: (direction) =>
                    _adminController.deleteUser(user.id),
                child: InkWell(
                  onLongPress: () => _showEditUserDialog(user),
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _showUserDetails(user),

                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFF1F5F9),
                          child: Text(
                            (user.name?.isNotEmpty ?? false)
                                ? user.name![0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name ?? 'Unknown User',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user.email,
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Active",
                            style: TextStyle(
                              color: Color(0xFF16A34A),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  void _showUserDetails(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    (user.name?.isNotEmpty ?? false)
                        ? user.name![0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.name ?? 'Unknown User',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Text(
                "Verified Guardian",
                style: TextStyle(
                  color: Color(0xFF16A34A),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _detailRow(
                      Icons.email_outlined,
                      "Email Address",
                      user.email,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                    ),
                    _detailRow(
                      Icons.phone_outlined,
                      "Phone Number",
                      user.phone ?? 'Not Provided',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                    ),
                    _detailRow(Icons.fingerprint, "System ID", "#${user.id}"),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                    ),
                    _detailRow(
                      Icons.home_work_outlined,
                      "Community Link",
                      user.communityId?.toString() ?? 'Unassigned',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Close Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2563EB)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Emergency Logs",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          _adminController.alerts.isEmpty
              ? _buildPlaceholderTab(
                  "No Recent Logs",
                  "Emergency history is currently empty.",
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _adminController.alerts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final alert = _adminController.alerts[index];
                    return InkWell(
                      onTap: () => _showAlertDetails(alert),
                      borderRadius: BorderRadius.circular(16),
                      child: _buildAlertItem(
                        alert.title ?? alert.subject ?? "Alert",
                        alert.location ?? "Unknown",
                        alert.createdAt?.toString().split('.')[0] ?? "Recently",
                        true,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  void _showAlertDetails(dynamic alert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    alert.title ?? "Emergency Alert",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _adminController.deleteAlert(alert.id);
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFEF4444),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Color(0xFFFEF2F2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _detailRow(Icons.info_outline, "Subject", alert.subject ?? "N/A"),
            const SizedBox(height: 12),
            _detailRow(
              Icons.person_outline,
              "Reporter",
              alert.reporter ?? "Anonymous",
            ),
            const SizedBox(height: 12),
            _detailRow(
              Icons.location_on_outlined,
              "Location",
              alert.location ?? "Unknown",
            ),
            const SizedBox(height: 12),
            _detailRow(
              Icons.access_time,
              "Timestamp",
              alert.createdAt?.toString() ?? "N/A",
            ),
            const SizedBox(height: 24),
            const Text(
              "Message Details",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                alert.message ?? "No additional details provided.",
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF334155),
                  height: 1.5,
                ),
              ),
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
                ),
                child: const Text(
                  "Close Log",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(String type, String loc, String time, bool verified) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_rounded,
            color: verified ? const Color(0xFF16A34A) : const Color(0xFFEF4444),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  "$loc • $time",
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (verified)
            const Icon(Icons.verified_user, color: Color(0xFF2563EB), size: 20),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.construction_rounded,
            size: 64,
            color: Color(0xFFE2E8F0),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildStatCards(AdminController controller) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: "Total Communities",
            value: _adminController.communities.length.toString(),
            icon: Icons.groups,
            color: const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: "Active Alerts",
            value: controller.alerts.length.toString(),
            icon: Icons.warning_amber_rounded,
            color: Color(0xFFEF4444),
          ),
        ),
      ],
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
