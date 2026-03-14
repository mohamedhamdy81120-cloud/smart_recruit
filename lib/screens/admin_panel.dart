import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});
  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';

  // قائمة المستخدمين محليًا
  List<Map<String, dynamic>> _localUsers = [
    {
      'id': '1',
      'name': 'Ali',
      'email': 'ali@example.com',
      'status': 'approved'
    },
    {
      'id': '2',
      'name': 'Sara',
      'email': 'sara@example.com',
      'status': 'pending'
    },
    {
      'id': '3',
      'name': 'Omar',
      'email': 'omar@example.com',
      'status': 'rejected'
    },
  ];

  Map<String, double> _computePieData(List<Map<String, dynamic>> users) {
    double approved =
        users.where((u) => u['status'] == 'approved').length.toDouble();
    double pending =
        users.where((u) => u['status'] == 'pending').length.toDouble();
    double rejected =
        users.where((u) => u['status'] == 'rejected').length.toDouble();
    return {'approved': approved, 'pending': pending, 'rejected': rejected};
  }

  void _updateStatus(String id, String status) {
    setState(() {
      final index = _localUsers.indexWhere((u) => u['id'] == id);
      if (index != -1) _localUsers[index]['status'] = status;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("تم تحديث الحالة إلى $status")),
    );
  }

  void _deleteUser(String id) {
    setState(() {
      _localUsers.removeWhere((u) => u['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تم حذف المستخدم")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;

    final users = _searchController.text.isEmpty
        ? _localUsers
        : _localUsers
            .where((u) => u['name']
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();

    final pieData = _computePieData(_localUsers);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1AAFB4),
        title: const Text("Admin Panel"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            /// Search Bar
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => searchText = val),
                decoration: InputDecoration(
                  hintText: "Search users...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.height * 0.015),
                ),
              ),
            ),
            const SizedBox(height: 8),

            /// Pie Chart
            Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: PieChart(
                  PieChartData(
                    sections: pieData.entries.map((entry) {
                      final color = entry.key == 'approved'
                          ? Colors.green
                          : entry.key == 'pending'
                              ? Colors.orange
                              : Colors.red;
                      return PieChartSectionData(
                        value: entry.value,
                        color: color,
                        title: "${entry.key}\n${entry.value.toInt()}",
                        radius: isSmall ? size.width * 0.14 : size.width * 0.18,
                        titleStyle: TextStyle(
                          fontSize: isSmall ? 12 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                    centerSpaceRadius:
                        isSmall ? size.width * 0.08 : size.width * 0.1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// Users List
            Expanded(
              flex: 5,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, idx) {
                  final user = users[idx];
                  final name = user['name'] ?? '';
                  final email = user['email'] ?? '';
                  final status = user['status'] ?? 'pending';

                  return Dismissible(
                    key: Key(user['id']),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _deleteUser(user['id']),
                    background: Container(
                      padding: EdgeInsets.only(right: size.width * 0.04),
                      alignment: Alignment.centerRight,
                      color: Colors.redAccent,
                      child: Icon(Icons.delete,
                          color: Colors.white, size: isSmall ? 20 : 24),
                    ),
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: isSmall ? 18 : 22,
                          backgroundColor: const Color(0xFF1AAFB4),
                          child: Text(
                            name.isNotEmpty ? name[0] : '',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmall ? 14 : 16),
                          ),
                        ),
                        title: Text(name,
                            style: TextStyle(fontSize: isSmall ? 14 : 16)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(email,
                                style: TextStyle(fontSize: isSmall ? 12 : 14)),
                            const SizedBox(height: 4),
                            Text(
                              "Status: $status",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: status == 'approved'
                                    ? Colors.green
                                    : status == 'pending'
                                        ? Colors.orange
                                        : Colors.red,
                                fontSize: isSmall ? 12 : 14,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check,
                                  color: Colors.green, size: isSmall ? 18 : 22),
                              onPressed: status == 'approved'
                                  ? null
                                  : () => _updateStatus(user['id'], 'approved'),
                            ),
                            IconButton(
                              icon: Icon(Icons.close,
                                  color: Colors.red, size: isSmall ? 18 : 22),
                              onPressed: status == 'rejected'
                                  ? null
                                  : () => _updateStatus(user['id'], 'rejected'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
