import 'package:auth_use_bloc/auth/auth_repository.dart';
import 'package:auth_use_bloc/auth/form_submission_status.dart';
import 'package:auth_use_bloc/auth/login/login_event.dart';
import 'package:auth_use_bloc/auth/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;
  LoginBloc({this.authRepo}) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    //Username updated
    if (event is LoginUsernameChanged) {
      yield state.copyWith(username: event.username);

      //Password updated
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);

      //Form submitted
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        await authRepo.login();
        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}
