import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<Uint8List?> compressImage(String imagePath) async {
  try {
    // Baca file gambar
    final File imageFile = File(imagePath);
    Uint8List imageBytes = await imageFile.readAsBytes();
    
    // Decode gambar
    final img.Image? originalImage = img.decodeImage(imageBytes);
    
    if (originalImage == null) return null;
    
    // Hitung dimensi baru dengan mempertahankan aspect ratio
    int maxWidth = 800; // Maximum width yang diinginkan
    int maxHeight = 800; // Maximum height yang diinginkan
    
    int newWidth = originalImage.width;
    int newHeight = originalImage.height;
    
    if (originalImage.width > maxWidth || originalImage.height > maxHeight) {
      double ratioX = maxWidth / originalImage.width;
      double ratioY = maxHeight / originalImage.height;
      double ratio = ratioX < ratioY ? ratioX : ratioY;
      
      newWidth = (originalImage.width * ratio).round();
      newHeight = (originalImage.height * ratio).round();
    }
    
    // Resize gambar
    final img.Image resizedImage = img.copyResize(
      originalImage,
      width: newWidth,
      height: newHeight,
      interpolation: img.Interpolation.linear
    );
    
    // Kompres gambar dengan kualitas 85%
    final compressedBytes = img.encodeJpg(resizedImage, quality: 85);
    
    return Uint8List.fromList(compressedBytes);
  } catch (e) {
    print('Error compressing image: $e');
    return null;
  }
}