import 'package:auth_use_bloc/auth/form_submission_status.dart';

class LoginState {
  final String username;
  bool get isUsernameValid => username.length > 3;
  final String password;
  bool get isPasswordValid => password.length >= 6;
  final FormSubmissionStatus formStatus;

  LoginState({
    this.username = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  LoginState copyWith({
    String username,
    String password,
    FormSubmissionStatus formStatus,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
