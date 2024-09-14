import 'package:flutter/material.dart';
import 'package:newapp/models/vacancy.dart';

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
                        color: const Color.fromARGB(255, 250, 198, 218),
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
                    // Title with a more refined design
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            vacancy.title ?? 'No Title',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.star,
                          color: const Color.fromARGB(255, 238, 87, 150),
                          size: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    // Company name with more refined design
                    Text(
                      vacancy.company ?? 'Unknown Company',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 238, 87, 150),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Description with an ellipsis for overflow
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
