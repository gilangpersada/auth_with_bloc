import 'package:auth_use_bloc/auth/auth_repository.dart';
import 'package:auth_use_bloc/auth/form_submission_status.dart';
import 'package:auth_use_bloc/auth/login/login_bloc.dart';
import 'package:auth_use_bloc/auth/login/login_event.dart';
import 'package:auth_use_bloc/auth/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(
          authRepo: context.read<AuthRepository>(),
        ),
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SubmissionFailed) {
          _showSnackBar(context, formStatus.exception.toString());
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: _loginForm(),
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _textFormFieldUsername(),
          SizedBox(height: 16),
          _textFormFieldPassword(),
          SizedBox(height: 24),
          _loginButton(),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.formStatus is FormSubmitting
            ? CircularProgressIndicator()
            : MaterialButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    context.read<LoginBloc>().add(LoginSubmitted());
                  }
                },
                color: Colors.black,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              );
      },
    );
  }

  Widget _textFormFieldUsername() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          decoration: InputDecoration(
            icon: Icon(Icons.person),
            hintText: 'Username',
          ),
          validator: (value) =>
              state.isUsernameValid ? null : 'Username is too short!',
          onChanged: (value) => context.read<LoginBloc>().add(
                LoginUsernameChanged(username: value),
              ),
        );
      },
    );
  }

  Widget _textFormFieldPassword() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.vpn_key),
            hintText: 'Password',
          ),
          validator: (value) => state.isPasswordValid
              ? null
              : 'Password must be more than 5 characters!',
          onChanged: (value) => context.read<LoginBloc>().add(
                LoginPasswordChanged(password: value),
              ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
