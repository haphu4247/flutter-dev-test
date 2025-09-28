// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Test Dev';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageVietnamese => 'Vietnamese';

  @override
  String get loginTitle => 'Login';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeWelcome => 'Welcome Home!';

  @override
  String get language => 'Language';

  @override
  String get tabHome => 'Home';

  @override
  String get tabSearch => 'Search';

  @override
  String get tabSettings => 'Settings';

  @override
  String get tab2 => 'Tab 2';

  @override
  String get tab3 => 'Tab 3';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileError => 'Profile Error';

  @override
  String get profileErrorUnknown => 'Unknown error';

  @override
  String get profileNoDataAvailable => 'No profile data available';

  @override
  String get profileRetry => 'Retry';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileEditComingSoon => 'Edit profile feature coming soon';

  @override
  String get profileRefreshing => 'Refreshing profile...';

  @override
  String get profileSignOut => 'Sign Out';

  @override
  String get profileSignOutConfirm => 'Are you sure you want to sign out?';

  @override
  String profileSignOutFailed(String error) {
    return 'Failed to sign out: $error';
  }

  @override
  String get profileInformation => 'Profile Information';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileFullName => 'Full Name';

  @override
  String get profileUsername => 'Username';

  @override
  String get profileGender => 'Gender';

  @override
  String get profileUserId => 'User ID';

  @override
  String loginFailed(String error) {
    return 'Login failed: $error';
  }

  @override
  String get loginFailedUnknown => 'Login failed: Unknown error';

  @override
  String get networkError => 'Network Error';

  @override
  String get networkErrorDescription =>
      'Please check your internet connection.';

  @override
  String get networkErrorOk => 'OK';

  @override
  String get postsPullUpLoad => 'pull up load';

  @override
  String get postsLoadFailed => 'Load Failed!Click retry!';

  @override
  String get postsReleaseToLoad => 'release to load more';

  @override
  String get postsNoMoreData => 'No more Data';

  @override
  String postsId(int id, String title) {
    return 'id:$id. $title';
  }

  @override
  String get settingsDone => 'Done';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeUniversal => 'Universal (System)';

  @override
  String get themeOrange => 'Orange';

  @override
  String get theme => 'Theme';

  @override
  String get profileDataNotAvailable => 'Profile data not available';

  @override
  String get splashScreen => 'Splash Screen';
}
