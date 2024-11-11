import 'package:flutter/material.dart';
import 'database_helper.dart';

class ViewStudentsPage extends StatefulWidget {
  const ViewStudentsPage({super.key});

  @override
  _ViewStudentsPageState createState() => _ViewStudentsPageState();
}

class _ViewStudentsPageState extends State<ViewStudentsPage> {
  Future<List<Map<String, dynamic>>> fetchStudents() async {
    return await DatabaseHelper.instance.getAllStudents();
  }

  void deleteStudent(int id) async {
    await DatabaseHelper.instance.deleteStudent(id);
    setState(() {}); // Refresh the page after deletion
  }

  // Open dialog to edit student
  void editStudentDialog(Map<String, dynamic> student) {
    final nameController = TextEditingController(text: student['name']);
    final phoneController = TextEditingController(text: student['phone']);
    final locationController = TextEditingController(text: student['location']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Name', nameController),
              _buildTextField('Phone', phoneController, TextInputType.phone),
              _buildTextField('Location', locationController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Prepare updated student data
                final updatedStudent = {
                  'id': student['id'],
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'location': locationController.text,
                };

                // Update student in database
                await DatabaseHelper.instance.updateStudent(updatedStudent);

                Navigator.pop(context); // Close the dialog
                setState(() {}); // Refresh the page
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper to build input fields
  Widget _buildTextField(String label, TextEditingController controller, [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Students',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchStudents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No students found.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.length,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            itemBuilder: (context, index) {
              final student = snapshot.data?[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.deepPurple.shade200,
                    child: Text(
                      student?['name'][0] ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    student?['name'] ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  subtitle: Text(
                    'ID: ${student?['id']} - Phone: ${student?['phone']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => editStudentDialog(student!),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Show a confirmation dialog before deleting
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Student'),
                              content: const Text(
                                  'Are you sure you want to delete this student?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteStudent(student?['id']);
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
