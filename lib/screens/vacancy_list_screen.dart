import 'package:flutter/material.dart';
import 'package:newapp/models/vacancy.dart';
import 'package:newapp/services/api_service.dart';

import 'vacancy_details_screen.dart';

class VacancyListScreen extends StatefulWidget {
  @override
  _VacancyListScreenState createState() => _VacancyListScreenState();
}

class _VacancyListScreenState extends State<VacancyListScreen> {
  late Future<List<Vacancy>> _vacanciesFuture;
  List<Vacancy> _vacancies = [];
  List<Vacancy> _filteredVacancies = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vacanciesFuture = fetchVacancies().then((vacancies) {
      setState(() {
        _vacancies = vacancies;
        _filteredVacancies = vacancies;
      });
      return vacancies;
    });

    _searchController.addListener(() {
      _filterVacancies(_searchController.text);
    });
  }

  void _filterVacancies(String query) {
    if (_vacancies.isEmpty) return;

    setState(() {
      if (query.isNotEmpty) {
        _filteredVacancies = _vacancies.where((vacancy) {
          return (vacancy.title?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (vacancy.company?.toLowerCase().contains(query.toLowerCase()) ??
                  false);
        }).toList();
      } else {
        _filteredVacancies = _vacancies;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacancies',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 250, 167, 201),
        elevation: 0, // Remove shadow from AppBar
        bottom: PreferredSize(
          preferredSize: Size.fromRadius(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search vacancies...',
                  prefixIcon: Icon(Icons.search,
                      color: const Color.fromARGB(255, 238, 87, 150)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Vacancy>>(
        future: _vacanciesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No vacancies found.'));
          } else {
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: _filteredVacancies.length,
              itemBuilder: (context, index) {
                final vacancy = _filteredVacancies[index];
                return VacancyCard(
                    vacancy: vacancy,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VacancyDetailsScreen(vacancy: vacancy),
                        ),
                      );
                    });
              },
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class VacancyCard extends StatelessWidget {
  final Vacancy vacancy;
  final VoidCallback onTap;

  VacancyCard({required this.vacancy, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              vacancy.imageUrl != null && vacancy.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        vacancy.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 204, 230),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('No Image',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vacancy.title ?? 'No Title',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      vacancy.company ?? 'Unknown Company',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      vacancy.description ?? 'No Description',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
