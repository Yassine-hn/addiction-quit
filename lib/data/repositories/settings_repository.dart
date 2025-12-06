
import '../models/addiction_model.dart'; // Will need to ensure this model exists or use Map/dynamic if not
import '../../modules/Addiction_Form_module/data/shared_preferences_helper.dart';

class SettingsRepository {
  /// Save current addiction ID
  Future<void> saveCurrentAddictionId(int id) async {
    await SharedPreferencesHelper.saveAddictionId(id);
  }

  /// Get current addiction ID
  Future<int?> getCurrentAddictionId() async {
    return await SharedPreferencesHelper.getAddictionId();
  }
}
