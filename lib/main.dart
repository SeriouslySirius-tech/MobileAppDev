import 'package:flutter/material.dart';
// import 'package:mad_project/my_home_page.dart';
import 'package:mad_project/tab_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Color.fromARGB(255, 95, 6, 150),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const TabNavigation(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _captureImage() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       // Handle the image capture here
//       print('Captured image path: ${image.path}');
//     }
//   }

//   Future<void> _selectFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       // Handle the file selection here
//       print('Selected file path: ${result.files.single.path}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('FAB Speed Dial Example'),
//       ),
//       body: Center(
//         child: Text('Press the FAB to take action'),
//       ),
//       floatingActionButton: SpeedDial(
//         icon: Icons.add,
//         activeIcon: Icons.close,
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         activeBackgroundColor: Colors.red,
//         activeForegroundColor: Colors.white,
//         children: [
//           SpeedDialChild(
//             child: Icon(FontAwesomeIcons.camera),
//             backgroundColor: Colors.green,
//             foregroundColor: Colors.white,
//             label: 'Capture Image',
//             onTap: _captureImage,
//           ),
//           SpeedDialChild(
//             child: Icon(FontAwesomeIcons.file),
//             backgroundColor: Colors.orange,
//             foregroundColor: Colors.white,
//             label: 'Select File',
//             onTap: _selectFile,
//           ),
//         ],
//       ),
//     );
//   }
// }

// void main() => runApp(MaterialApp(
//       home: MyHomePage(),
//     ));
