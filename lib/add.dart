import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  late Future<Database> _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'student_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, phone TEXT, email TEXT, location TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> saveOrUpdateStudent() async {
    final db = await _database;
    int id = int.parse(idController.text);
    final data = {
      'id': id,
      'name': nameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'location': locationController.text,
    };

    var existingStudent = await db.query('students', where: 'id = ?', whereArgs: [id]);

    if (existingStudent.isEmpty) {
      // Insert new student
      await db.insert('students', data, conflictAlgorithm: ConflictAlgorithm.replace);
      _showMessage("Saved successfully");
    } else {
      // Update existing student
      await db.update('students', data, where: 'id = ?', whereArgs: [id]);
      _showMessage("Updated successfully");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add/Update Student',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.white  ,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              ' Student Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Name'),
            _buildTextField(nameController, 'student name', Icons.person),
            const SizedBox(height: 16),
            _buildSectionTitle('ID'),
            _buildTextField(idController, ' student ID', Icons.badge, TextInputType.number),
            const SizedBox(height: 16),
            _buildSectionTitle('Phone Number'),
            _buildTextField(phoneController, 'Enter phone number', Icons.phone, TextInputType.phone),
            const SizedBox(height: 16),
            _buildSectionTitle('Email ID'),
            _buildTextField(emailController, 'Enter email ID', Icons.email, TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildSectionTitle('Location'),
            _buildTextField(locationController, 'Enter location', Icons.location_on),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: saveOrUpdateStudent,
                child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: Colors.blueGrey,
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hint,
      IconData icon, [
        TextInputType keyboardType = TextInputType.text,
      ]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}
