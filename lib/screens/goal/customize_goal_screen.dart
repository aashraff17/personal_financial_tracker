import 'dart:io'; // Needed for File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // The new package
import 'goal_model.dart';

class CustomizeGoalScreen extends StatefulWidget {
  final Goal goal;
  const CustomizeGoalScreen({super.key, required this.goal});

  @override
  State<CustomizeGoalScreen> createState() => _CustomizeGoalScreenState();
}

class _CustomizeGoalScreenState extends State<CustomizeGoalScreen> {
  late TextEditingController _nameController;

  // Variable to store the picked image locally
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.goal.title);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // FUNCTION TO OPEN GALLERY
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logic: Decide which image to show
    ImageProvider currentImage;
    if (_selectedImage != null) {
      // If user picked a new photo, show it
      currentImage = FileImage(_selectedImage!);
    } else {
      // Otherwise, show the original URL
      currentImage = NetworkImage(widget.goal.imageUrl);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Customize your goal", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE SECTION
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: currentImage, // Use the variable we defined above
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _pickImage, // Call the function here
                    child: const Text("Customize image"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // TEXT FIELD SECTION
            const Text("Name your goal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // In a real app, you would save the new name and image path to your database here
                  Navigator.pop(context);
                },
                child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}