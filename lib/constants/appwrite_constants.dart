import 'secret_keys.dart';

class AppwriteConstants {
  static const String projectId = projectIdSecretPass;
  static const String databaseId = '64eb97d48083ea558f2c';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String serverKey = projectFirebaseFCMServerKey;

  static const String usersCollection = '64eb97dcb0f10817a836';

  static const String imagesBucket = '64ebc40f80799b3b8b87';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
