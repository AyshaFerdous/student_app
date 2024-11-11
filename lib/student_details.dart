import 'package:flutter/material.dart';


class StudentDetailsPage extends StatelessWidget {
  final Map<String, dynamic> student;

  const StudentDetailsPage({required this.student, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Details',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Navigate to EditStudentPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditStudentPage(student: student),
                ),
              ).then((_) {
                // Refresh the page after editing
                (context as Element).reassemble();
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.pink[50], // Soft pink background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Cute profile avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.pinkAccent,
              child: Text(
                student['name'][0], // Display the first letter of the student's name
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Student's Name with a cute font style
            Text(
              student['name'],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            // Cute icons for student details
            _buildDetailRow(
              icon: Icons.badge,
              label: 'ID',
              value: student['id'].toString(),
            ),
            const SizedBox(height: 10),
            _buildDetailRow(
              icon: Icons.phone,
              label: 'Phone',
              value: student['phone'],
            ),
            const SizedBox(height: 10),
            _buildDetailRow(
              icon: Icons.location_on,
              label: 'Location',
              value: student['location'],
            ),
            const SizedBox(height: 30),
            // Additional cute decoration
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Text(
                'Keep learning and growing!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.pinkAccent,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create cute detail rows
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.pinkAccent, size: 28),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
