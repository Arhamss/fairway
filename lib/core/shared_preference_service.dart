import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  // Future<void> saveStudentForStream(StudentModel studentModel) async {
  //   final pref = await SharedPreferences.getInstance();
  //   await pref.setString('student_uid', studentModel.uid);
  //   await pref.setString('student_name', studentModel.name ?? 'Anonymous');
  //   await pref.setString('student_email', studentModel.email ?? '');
  //   await pref.setString(
  //     'student_photo',
  //     studentModel.photoUrl ?? AppConstants.userPlaceholderImageUrl,
  //   );
  // }
  //
  // Future<User> getStudentForStream() async {
  //   final pref = await SharedPreferences.getInstance();
  //   return User(
  //     id: pref.getString('student_uid') ?? '',
  //     extraData: {
  //       'name': pref.getString('student_name') ?? 'Anonymous',
  //       'email': pref.getString('student_email'),
  //       'image': pref.getString('student_photo') ?? AppConstants.userPlaceholderImageUrl,
  //     },
  //   );
  // }
  //
  // Future<void> saveTutorForStream(TutorModel tutorModel) async {
  //   final pref = await SharedPreferences.getInstance();
  //   await pref.setString('tutor_uid', tutorModel.uid);
  //   await pref.setString('tutor_name', tutorModel.name ?? 'Anonymous');
  //   await pref.setString('tutor_email', tutorModel.email ?? '');
  //   await pref.setString(
  //     'tutor_photo',
  //     tutorModel.photoUrl ?? AppConstants.userPlaceholderImageUrl,
  //   );
  // }
  //
  // Future<User> getTutorForStream() async {
  //   final pref = await SharedPreferences.getInstance();
  //   return User(
  //     id: pref.getString('tutor_uid') ?? '',
  //     extraData: {
  //       'name': pref.getString('tutor_name') ?? 'Anonymous',
  //       'email': pref.getString('tutor_email'),
  //       'image': pref.getString('tutor_photo') ?? AppConstants.userPlaceholderImageUrl,
  //     },
  //   );
  // }

  Future<void> clearData() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
