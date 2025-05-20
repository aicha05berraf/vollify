// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vollify/controllers/user_controller.dart';
import 'package:vollify/services/opportunity_service.dart';

class SearchOpportunityScreen extends StatefulWidget {
  const SearchOpportunityScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchOpportunityScreenState createState() =>
      _SearchOpportunityScreenState();
}

class _SearchOpportunityScreenState extends State<SearchOpportunityScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _opportunities = [];
  List<Map<String, dynamic>> _filteredOpportunities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOpportunities();
  }

  Future<void> _loadOpportunities() async {
    final data = await OpportunityService().fetchOpportunities();
    setState(() {
      _opportunities = data;
      _filteredOpportunities = List.from(_opportunities);
      _isLoading = false;
    });
  }

  void _filterOpportunities(String query) {
    setState(() {
      _filteredOpportunities =
          _opportunities.where((opportunity) {
            final title = (opportunity['title'] ?? '').toString().toLowerCase();
            final org =
                (opportunity['organization_name'] ?? '')
                    .toString()
                    .toLowerCase();
            return title.contains(query.toLowerCase()) ||
                org.contains(query.toLowerCase());
          }).toList();
    });
  }

  void _showOpportunityDetails(Map<String, dynamic> opportunity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => OpportunityDetailsScreen(opportunity: opportunity),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color cardBg = Color(0xFFE5EAD2);
    const Color appBarColor = Color(0xFF20331B);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          'Search Opportunity',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            _filterOpportunities(_searchController.text);
                          },
                        ),
                      ),
                      onChanged: (value) {
                        _filterOpportunities(value);
                      },
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredOpportunities.length,
                        itemBuilder: (context, index) {
                          final opportunity = _filteredOpportunities[index];
                          return GestureDetector(
                            onTap: () => _showOpportunityDetails(opportunity),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 20,
                                ),
                                title: Text(
                                  opportunity['title'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFF20331B),
                                  ),
                                ),
                                subtitle: Text(
                                  opportunity['organization_name'] ?? '',
                                  style: const TextStyle(
                                    color: Color(0xFF354C2B),
                                    fontSize: 15,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF697E50),
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

class OpportunityDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> opportunity;

  const OpportunityDetailsScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    const Color iconColor = Color(0xFF697E50);
    const Color appBarColor = Color(0xFF20331B);

    final bool isFull =
        (opportunity['currentVolunteers'] ?? 0) >=
        (opportunity['volunteers_required'] ?? 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          opportunity['title'] ?? '',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Row(
              children: [
                const Icon(Icons.business, color: iconColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Organization: ${opportunity['organization_name'] ?? ''}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.description, color: iconColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Description: ${opportunity['description'] ?? ''}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(Icons.location_on, color: iconColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Location: ${opportunity['location'] ?? ''}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(Icons.people, color: iconColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Volunteers Needed: ${opportunity['volunteers_required'] ?? ''}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Icon(Icons.info, color: isFull ? Colors.red : iconColor),
                const SizedBox(width: 10),
                Text(
                  'Status: ${isFull ? 'Full' : 'Open'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: isFull ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.build, color: iconColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Required Skills: ${opportunity['skills_required'] ?? ''}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(Icons.email, color: iconColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Email: ${opportunity['email'] ?? ''}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(Icons.phone, color: iconColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Phone: ${opportunity['phone'] ?? ''}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (!isFull)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final user = Get.find<UserController>().user.value;
                    final userId = user?.id;

                    if (userId == null) {
                      // ignore: avoid_print
                      print('⚠️ User ID is null');
                      return;
                    }

                    final success = await OpportunityService()
                        .applyToOpportunity(opportunity['id'], userId);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ Application submitted'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('❌ Already applied or failed'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appBarColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            else
              const Text(
                'Opportunity is full.',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
