import 'package:easy_localization/easy_localization.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';

import '../../config/res/config_imports.dart';
import '../../core/helpers/cache_service.dart';
import '../../core/widgets/default_bottom_sheet.dart';
import 'widgets/whats_new_sheet.dart';

class WhatsNewService {
  static const Duration _storeLookupTimeout = Duration(seconds: 5);

  // Upper bound so a malformed/missing translation can never loop forever.
  static const int _maxChangelogItems = 20;

  // Bundled changelog fallback. Notes live in `lang.json` under the
  // `whatsNewV<version>ItemN` convention (e.g. `whatsNewV107Item1`), which the
  // generator turns into the runtime key `whats_new_v_1_0_7_item_1`. We rebuild
  // that key from the version and read items until one is missing, so adding
  // notes for a new release needs only translation entries — no code change.
  static List<String> _itemsFor(String version) {
    final String prefix = 'whats_new_v_${version.replaceAll('.', '_')}_item_';
    final List<String> items = [];
    for (int i = 1; i <= _maxChangelogItems; i++) {
      final String key = '$prefix$i';
      final String value = key.tr();
      // easy_localization returns the key unchanged when it has no translation.
      if (value == key) break;
      items.add(value);
    }
    return items;
  }

  static Future<void> showIfNeeded({required Upgrader upgrader}) async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    final String currentVersion = info.version;
    final String? lastSeen =
        CacheStorage.read(CacheConstant.lastSeenWhatsNewVersion) as String?;

    // Fresh install: nothing recorded yet → record silently, never show on the
    // first launch.
    if (lastSeen == null) {
      await CacheStorage.write(
        CacheConstant.lastSeenWhatsNewVersion,
        currentVersion,
      );
      return;
    }

    // Already shown for this version → nothing to do.
    if (lastSeen == currentVersion) return;

    // The user updated. Record now so we don't re-check every launch...
    await CacheStorage.write(
      CacheConstant.lastSeenWhatsNewVersion,
      currentVersion,
    );

    // ...then resolve content: store notes first, bundled changelog as fallback.
    final List<String> items = await _resolveItems(upgrader, currentVersion);
    if (items.isEmpty) return;

    await showDefaultBottomSheet(child: WhatsNewSheet(items: items));
  }

  static Future<List<String>> _resolveItems(
    Upgrader upgrader,
    String currentVersion,
  ) async {
    final List<String> storeNotes = await _storeReleaseNotes(upgrader);
    if (storeNotes.isNotEmpty) return storeNotes;
    return _itemsFor(currentVersion);
  }

  static Future<List<String>> _storeReleaseNotes(Upgrader upgrader) async {
    try {
      await upgrader.initialize().timeout(_storeLookupTimeout);

      // Only trust the notes when the latest store version is the one
      // installed; otherwise they describe a version not yet installed.
      final bool onLatest =
          upgrader.currentAppStoreVersion == upgrader.currentInstalledVersion;
      return _splitNotes(onLatest ? upgrader.releaseNotes : null);
    } catch (_) {
      return const [];
    }
  }

  static List<String> _splitNotes(String? notes) {
    if (notes == null || notes.trim().isEmpty) return const [];
    return notes
        .split('\n')
        .map((line) => line.trim().replaceFirst(RegExp(r'^[-•*]\s*'), '').trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }
}
