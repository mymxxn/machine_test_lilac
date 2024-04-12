import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class HomeController extends GetxController {
  var downloading = false.obs;
  var progressString = "".obs;
  var isDownloaded = false.obs;
  var isLoading = false.obs;

  var controller = Rx<VideoPlayerController?>(null);

  @override
  void onInit() {
    super.onInit();
    loadVideo();
  }

  Future<void> downloadAndDecryptFile() async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      String filePath = "${dir.path}/demo.mp4";

      await dio.download(
        'https://drive.google.com/uc?export=download&id=1QFsgGDbxz_N_4Z4OsWJkAzLsP0f6wdyP',
        filePath,
        onReceiveProgress: (rec, total) {
          print("Rec: $rec , Total: $total");
          downloading.value = true;
          progressString.value = ((rec / total) * 100).toStringAsFixed(0) + "%";
          update();
        },
      );

      // Encrypt the downloaded file
      await encryptFile(filePath);

      // Decrypt the encrypted file
      await decryptFile(
          "${dir.path}/demo_encrypted.mp4", "${dir.path}/demo_decrypted.mp4");

      // Delete the original downloaded file and the encrypted file
      File(filePath).delete();
      File("${dir.path}/demo_encrypted.mp4").delete();

      // Load the decrypted video
      await loadVideo();
    } catch (e) {
      print(e);
    }

    downloading.value = false;
    progressString.value = "Completed";
    update();
    print("Download completed");
  }

  Future<void> encryptFile(String filePath) async {
    final file = File(filePath);
    final key = encrypt.Key.fromUtf8('my32byteencryptionkey');
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // Read the file content
    List<int> fileContent = await file.readAsBytes();

    // Convert List<int> to Uint8List
    Uint8List uint8FileContent = Uint8List.fromList(fileContent);

    // Encrypt the content
    final encryptedBytes = encrypter.encryptBytes(uint8FileContent, iv: iv);

    // Write encrypted content back to the file
    await file.writeAsBytes(encryptedBytes.bytes);
  }

  Future<File?> getDecryptedFile() async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      String decryptedFilePath = "${dir.path}/demo_decrypted.mp4";

      if (await File(decryptedFilePath).exists()) {
        return File(decryptedFilePath);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> decryptFile(
      String encryptedFilePath, String decryptedFilePath) async {
    final file = File(encryptedFilePath);
    final key = encrypt.Key.fromUtf8('my32byteencryptionkey');
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // Read the encrypted file content
    List<int> encryptedFileContent = await file.readAsBytes();

    // Convert List<int> to Uint8List
    Uint8List uint8EncryptedFileContent =
        Uint8List.fromList(encryptedFileContent);

    // Decrypt the content
    final decryptedBytes = encrypter.decryptBytes(
      encrypt.Encrypted(uint8EncryptedFileContent),
      iv: iv,
    );

    // Write decrypted content to a new file
    await File(decryptedFilePath).writeAsBytes(decryptedBytes);
  }

  Future<void> loadVideo() async {
    try {
      isLoading.value = true;
      update();
      final decryptedFile = await getDecryptedFile();
      if (decryptedFile != null) {
        controller.value = await VideoPlayerController.file(decryptedFile)
          ..initialize();
        controller.value?.play(); // Start playing the video
      } else {
        controller.value = VideoPlayerController.networkUrl(Uri.parse(
          'https://drive.google.com/uc?export=download&id=1QFsgGDbxz_N_4Z4OsWJkAzLsP0f6wdyP',
        ))
          ..initialize();
        update();
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
