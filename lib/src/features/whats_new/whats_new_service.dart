import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../core/helpers/cache_service.dart';
import '../../core/widgets/default_bottom_sheet.dart';
import 'widgets/whats_new_sheet.dart';

/// Shows a "What's New" sheet once, the first time the app is opened after
/// updating to a new version — never on a fresh install.
///
/// Detection is version-based: the last version the user saw the sheet for is
/// stored in [CacheStorage] and compared against the installed version from
/// [PackageInfo]. A mismatch means the user just updated.
///
/// Content is sourced from the store's release notes (via [Upgrader]) when the
/// user is on the latest store version, and falls back to the bundled
/// changelog ([_itemsFor]) when the store has nothing (offline, or the Play
/// Store scrape returns null).
class WhatsNewService {
  static const Duration _storeLookupTimeout = Duration(seconds: 5);

  /// Bundled changelog bullets per app version, used as the fallback when the
  /// store release notes are unavailable. Add a `case` each release whose value
  /// matches the `version:` in `pubspec.yaml` (the part before `+`).
  ///
  /// Built at call time (not a `const` map) so the `LocaleKeys` getters resolve
  /// in the current locale.
  static List<String> _itemsFor(String version) {
    switch (version) {
      case '1.0.7':
        return [
          LocaleKeys.whatsNewV107Item1,
          LocaleKeys.whatsNewV107Item2,
        ];
      default:
        return const [];
    }
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

  /// Store release notes are a single free-text blob. Split into bullet lines
  /// and strip any leading bullet marker so the sheet doesn't double-bullet.
  static List<String> _splitNotes(String? notes) {
    if (notes == null || notes.trim().isEmpty) return const [];
    return notes
        .split('\n')
        .map((line) => line.trim().replaceFirst(RegExp(r'^[-•*]\s*'), '').trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }
}
