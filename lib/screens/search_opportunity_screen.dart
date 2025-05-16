// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get/get_core/src/get_main.dart';
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
            return opportunity.values.any(
              (value) =>
                  value != null &&
                  value.toString().toLowerCase().contains(query.toLowerCase()),
            );
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
    return Scaffold(
      appBar: AppBar(title: Text('Search Opportunity')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Search Field
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            _filterOpportunities(_searchController.text);
                          },
                        ),
                      ),
                      onChanged: (value) {
                        _filterOpportunities(value);
                      },
                    ),
                    SizedBox(height: 16),

                    // List of Opportunities
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredOpportunities.length,
                        itemBuilder: (context, index) {
                          final opportunity = _filteredOpportunities[index];
                          return Card(
                            child: ListTile(
                              title: Text(opportunity['title'] ?? ''),
                              subtitle: Text(
                                opportunity['organization_name'] ?? '',
                              ),
                              onTap: () => _showOpportunityDetails(opportunity),
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
    final bool isFull =
        (opportunity['currentVolunteers'] ?? 0) >=
        (opportunity['volunteers_required'] ?? 0);

    return Scaffold(
      appBar: AppBar(title: Text(opportunity['title'] ?? '')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              opportunity['title'] ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Organization: ${opportunity['organization_name'] ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Description: ${opportunity['description'] ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Location: ${opportunity['location'] ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Volunteers Needed: ${opportunity['volunteers_required'] ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${isFull ? 'Full' : 'Open'}',
              style: TextStyle(
                fontSize: 16,
                color: isFull ? Colors.red : Colors.green,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Required Skills: ${opportunity['skills_required'] ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${opportunity['email'] ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Phone: ${opportunity['phone'] ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            if (!isFull)
              ElevatedButton(
                onPressed: () async {
                  final user = Get.find<UserController>().user.value;
                  final userId = user?.id;

                  if (userId == null) {
                    // ignore: avoid_print
                    print('⚠️ User ID is null');
                    return;
                  }

                  final success = await OpportunityService().applyToOpportunity(
                    opportunity['id'],
                    userId,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('✅ Application submitted')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('❌ Already applied or failed')),
                    );
                  }
                },

                child: Text('Apply'),
              )
            else
              Text('Opportunity is full.'),
          ],
        ),
      ),
    );
  }
}
