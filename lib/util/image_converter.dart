import 'dart:io';
import 'dart:typed_data'; // Importez typed_data pour Uint8List
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageConverter {
  static Future<File> convertToPng(File file) async { // Changez le nom de la méthode pour refléter sa fonction
    Uint8List imageBytes = await file.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage != null) {
      // Pas besoin de redimensionner pour l'exemple, mais vous pouvez ajuster si nécessaire
      List<int> pngBytes = img.encodePng(originalImage); // Utilisez encodePng au lieu de encodeJpg

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/temp_image.png'; // Sauvegardez avec l'extension .png
      File tempFile = File(tempPath)..writeAsBytesSync(Uint8List.fromList(pngBytes));

      return tempFile;
    } else {
      throw Exception('Unable to decode image');
    }
  }
}
