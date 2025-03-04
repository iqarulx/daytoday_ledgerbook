import 'package:in_app_update/in_app_update.dart';

void checkForUpdate() async {
  AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
  if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
    InAppUpdate.startFlexibleUpdate();
  }
}
