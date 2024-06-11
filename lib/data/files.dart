import 'package:intl/intl.dart';
import 'package:mad_project/models/file_object.dart';

final DateFormat formatter = DateFormat('dd-MM-yy HH:mm');

final List<Map<String, String>> filesMaps = [
  {
    'fileName': 'Job Application',
    'date': formatter.format(DateTime.now()),
    'fileType': 'Letter'
  },
  {
    'fileName': 'Resume',
    'date': formatter.format(DateTime.now()),
    'fileType': 'Letter'
  },
  {
    'fileName': 'Stacks',
    'date': formatter.format(DateTime.now()),
    'fileType': 'Letter'
  },
  {
    'fileName': 'Random Notes',
    'date': formatter.format(DateTime.now()),
    'fileType': 'Letter'
  },
  // ... other file data
];

var fileBuf = filesMaps.map((element) {
  return FileObject(
      fileName: element['fileName']!,
      fileType: element['fileType']!,
      date: element['date']!);
}).toList();

final files = fileBuf;
