import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uberapp1/providers/user_management.dart';
import 'package:uberapp1/theme/app_theme.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  var _currentPage = AuthMode.Signup;
  var _isLogin = false;
  var _isLoading = false;
  final _emailFocusNode = FocusNode();
  final _confirmpassFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  var _authenticationProvider;
  Map<String, String> _userinfo = {'username': '', 'email': '', 'password': ''};

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmpassFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _authenticationProvider = Provider.of<UserManagement>(context);
  }

  OutlineInputBorder _userInputField() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
          color: AppTheme.primaryColor,
          width: 2,
          style: BorderStyle.solid),
    );
  }

  Future<void> _savingForm() async {

    setState(() {
      _isLoading = true;
    });

    final validation = _formkey.currentState.validate();
    if (!validation) {
      return;
    }
    _formkey.currentState.save();

    if (_currentPage == AuthMode.Login) {
      _isLogin = true;
    } else {
      _isLogin = false;
    }

    _authenticationProvider.authenticate(context,
        username: _userinfo['username'].trim(),
        email: _userinfo['email'].trim(),
        password: _userinfo['password'].trim(),
        isLogin: _isLogin);
    
  }

  @override
  Widget build(BuildContext context) {
    print('Its being called');
    return Scaffold(
      backgroundColor: AppTheme.appBackgroundColor,
      body: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Uber',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor),
            ),
            SizedBox(height: 20),
            if(_currentPage == AuthMode.Signup)
            Container(
              height: 45,
              width: double.infinity,
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                cursorColor: AppTheme.primaryColor,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                      fontSize: 22, color: AppTheme.primaryColor),
                  labelText: "Username",
                  border: _userInputField(),
                  enabledBorder: _userInputField(),
                  focusedBorder: _userInputField(),
                  contentPadding: EdgeInsets.only(bottom: 5, left: 8),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_emailFocusNode),
                onSaved: (val) => _userinfo['username'] = val,
                validator: (val) {
                  if (val.isEmpty || val.length < 3) {
                    return 'Enter a valid Username';
                  }
                  return null;
                },
              ),
            ),
              Container(
                height: 45,
                width: double.infinity,
                color: Colors.white,
                margin:
                    EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 10),
                child: TextFormField(
                  cursorColor: AppTheme.primaryColor,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                        fontSize: 22, color: AppTheme.primaryColor),
                    labelText: "Email",
                    border: _userInputField(),
                    enabledBorder: _userInputField(),
                    focusedBorder: _userInputField(),
                    contentPadding: EdgeInsets.only(bottom: 5, left: 8),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocusNode),
                  onSaved: (val) => _userinfo['email'] = val,
                  validator: (val) {
                    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                        "\\@" +
                        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                        "(" +
                        "\\." +
                        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                        ")+";
                    RegExp regExp = new RegExp(p);

                    if (val.isEmpty || val.length < 6) {
                      return 'Enter a valid email';
                    } else if (regExp.hasMatch(val)) {
                      return null;
                    } else {
                      return 'Enter a valid email';
                    }
                  },
                ),
              ),
            Container(
              height: 45,
              width: double.infinity,
              color: Colors.white,
              margin: EdgeInsets.only(
                  left: 50,
                  right: 50,
                  top: _currentPage == AuthMode.Signup ? 10 : 20,
                  bottom: 10),
              child: TextFormField(
                obscureText: true,
                cursorColor: AppTheme.primaryColor,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                      fontSize: 22, color: AppTheme.primaryColor),
                  labelText: "Password",
                  border: _userInputField(),
                  enabledBorder: _userInputField(),
                  focusedBorder: _userInputField(),
                  contentPadding: EdgeInsets.only(bottom: 5, left: 8),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_emailFocusNode),
                onSaved: (val) => _userinfo['password'] = val,
                controller: _passwordController,
                validator: (val) {
                  if (val.isEmpty || val.length <= 6) {
                    return 'Enter a strong password';
                  }

                  return null;
                },
              ),
            ),
            if (_currentPage == AuthMode.Signup)
              Container(
                height: 45,
                width: double.infinity,
                color: Colors.white,
                margin:
                    EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 20),
                child: TextFormField(
                  obscureText: true,
                  cursorColor: AppTheme.primaryColor,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                        fontSize: 22, color: AppTheme.primaryColor),
                    labelText: "Confirm Password",
                    border: _userInputField(),
                    enabledBorder: _userInputField(),
                    focusedBorder: _userInputField(),
                    contentPadding: EdgeInsets.only(bottom: 5, left: 8),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  validator: (val) {
                    if (val.isEmpty || val != _passwordController.text) {
                      return 'Password\'s doesnot match';
                    }
                    return null;
                  },
                ),
              ), _isLoading == true ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor)) :
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: 45,
                width: 150,
                child: Text(
                  _currentPage == AuthMode.Login ? 'Login' : 'Sign Up',
                  style: TextStyle(
                      color: AppTheme.appBackgroundColor, fontSize: 20),
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onTap: () {
                _savingForm();
              },
            ),
            SizedBox(height: 20),
            if (_isLoading == false)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentPage == AuthMode.Login
                      ? 'Dont have an account?'
                      : 'Already have an account?',
                  style: TextStyle(
                      fontSize: 18, color: AppTheme.primaryColor),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  child: Text(
                    _currentPage == AuthMode.Login ? 'Sign Up' : 'Login',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                  onTap: () {
                    if (_currentPage == AuthMode.Login) {
                      setState(() {
                        _currentPage = AuthMode.Signup;
                      });
                    } else {
                      setState(() {
                        _currentPage = AuthMode.Login;
                      });
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
