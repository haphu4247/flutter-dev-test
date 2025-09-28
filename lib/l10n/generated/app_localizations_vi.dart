// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Flutter Test Dev';

  @override
  String get helloWorld => 'Xin chào thế giới!';

  @override
  String get languageEnglish => 'Tiếng Anh';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get loginTitle => 'Đăng nhập';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get homeTitle => 'Trang chủ';

  @override
  String get homeWelcome => 'Chào mừng về trang chủ!';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get tabHome => 'Trang chủ';

  @override
  String get tabSearch => 'Tìm kiếm';

  @override
  String get tabSettings => 'Cài đặt';

  @override
  String get tab2 => 'Tab 2';

  @override
  String get tab3 => 'Tab 3';

  @override
  String get profileTitle => 'Hồ sơ';

  @override
  String get profileError => 'Lỗi hồ sơ';

  @override
  String get profileErrorUnknown => 'Lỗi không xác định';

  @override
  String get profileNoDataAvailable => 'Không có dữ liệu hồ sơ';

  @override
  String get profileRetry => 'Thử lại';

  @override
  String get profileCancel => 'Hủy';

  @override
  String get profileEdit => 'Chỉnh sửa hồ sơ';

  @override
  String get profileEditComingSoon => 'Tính năng chỉnh sửa hồ sơ sắp ra mắt';

  @override
  String get profileRefreshing => 'Đang làm mới hồ sơ...';

  @override
  String get profileSignOut => 'Đăng xuất';

  @override
  String get profileSignOutConfirm => 'Bạn có chắc chắn muốn đăng xuất?';

  @override
  String profileSignOutFailed(String error) {
    return 'Đăng xuất thất bại: $error';
  }

  @override
  String get profileInformation => 'Thông tin hồ sơ';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileFullName => 'Họ và tên';

  @override
  String get profileUsername => 'Tên đăng nhập';

  @override
  String get profileGender => 'Giới tính';

  @override
  String get profileUserId => 'ID người dùng';

  @override
  String loginFailed(String error) {
    return 'Đăng nhập thất bại: $error';
  }

  @override
  String get loginFailedUnknown => 'Đăng nhập thất bại: Lỗi không xác định';

  @override
  String get networkError => 'Lỗi mạng';

  @override
  String get networkErrorDescription => 'Vui lòng kiểm tra kết nối internet.';

  @override
  String get networkErrorOk => 'OK';

  @override
  String get postsPullUpLoad => 'kéo lên để tải';

  @override
  String get postsLoadFailed => 'Tải thất bại! Nhấn để thử lại!';

  @override
  String get postsReleaseToLoad => 'thả để tải thêm';

  @override
  String get postsNoMoreData => 'Không còn dữ liệu';

  @override
  String postsId(int id, String title) {
    return 'id:$id. $title';
  }

  @override
  String get settingsDone => 'Xong';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get themeUniversal => 'Tự động (Hệ thống)';

  @override
  String get themeOrange => 'Cam';

  @override
  String get theme => 'Chủ đề';

  @override
  String get profileDataNotAvailable => 'Dữ liệu hồ sơ không có sẵn';

  @override
  String get splashScreen => 'Màn hình khởi động';
}
