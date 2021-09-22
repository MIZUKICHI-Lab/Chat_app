import 'package:chat_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  final UserModel? users;
  final String? userId;
  final String? currentUserId;
  static final String id = 'login_screen';

  SignupScreen({
    this.userId,
    this.users,
    this.currentUserId,
  });

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool logined = false;
  bool visibility1 = true;
  bool visibility2 = true;
  String _errorText = '';
  String _titleText = '';

  void login() {
    setState(() {
      logined = true;
    });
  }

  void logout() {
    setState(() {
      logined = false;
      _auth.signOut();
    });
  }

////////////////////////////メールサインイン//////////////////////////////
  String? _email, _password1, _password2, _name;

  bool validate() {
    final form = _formKey.currentState;
    form!.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    super.dispose();
  }

//////////////////////////////認証処理////////////////////////////////////////////
  _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Logging in the user w/ Firebase
      if (_password1 != _password2) {
        _titleText = 'パスワード入力エラー';
        _errorText = '入力されたパスワードが違います。もう一度入力し直してください。';
      } else {
        try {
          UserCredential authResult =
              await _auth.createUserWithEmailAndPassword(
            email: _email!,
            password: _password1!,
          );

          User signedInUser = authResult.user!;
          var user = _auth.currentUser;
          // if (signedInUser != null) {
          //   setState(() {});
          //   print('メールで登路して下さい1');
          //   _titleText = 'メールを送信しました';
          //   _errorText = 'メールで認証を完了させてもう一度ログインして下さい';

          //   showFloatingFlushbar(context);
          // }
          print('メールで登路して下さい1');
          _titleText = 'メールを送信しました';
          _errorText = 'メールで認証を完了させてもう一度ログインして下さい';

          // Navigator.pop(context);
          user!.sendEmailVerification();
          if (signedInUser != null) {
            //String token = await _messaging.getToken();

            // _firestore.collection('/users').doc(signedInUser.uid).set(
            await FirebaseFirestore.instance
                .collection('users')
                .doc(signedInUser.uid)
                .set(
              {
                'name': _name,
                'uid': 0,
                'email': _email,
                'profileImageUrl': null,
                'bio': '',
                'point': 100,
                'key': false,
                'notify': false,
                'token': '',
                'status': false,
                'warring': 0
              },
            );
            logout();
          } //

          Future.delayed(Duration(seconds: 3)).then((_) async {
            _formKey.currentState!.save();
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(
                      // email: _email,
                      // signIn: true,
                      ),
                ),
              );
            }
          });
        } catch (e) {
          print('そのメールアドレスはすでに使用されています');
          _titleText = '登録エラー';
          _errorText = 'そのメールアドレスは有効ではありません';

          logout();
          print(e);
        }
      }
    } else {
      logout();
      _titleText = '登録エラー';
      _errorText = 'そのメールアドレスは有効ではありません';
    }
  }

  //////エラー表示バー////////////////////////////////////////

  //////////////////////////////////////////////////////////

  final kLabelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    //fontFamily: 'OpenSans',
  );
  final kHintTextStyle = TextStyle(
    color: Colors.white54,
    //fontFamily: 'OpenSans',
  );
  final kBoxDecorationStyle = BoxDecoration(
    color: Color(0xFF6CA8F1),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  //メール欄
  Widget _buildEmailTF() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Email',
            style: kLabelStyle,
          ),
          SizedBox(height: height * 0.01),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(height * 0.01),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: height * 0.07,
            child: TextFormField(
              validator: (input) =>
                  !input!.contains('@') ? '       メールアドレスを正しく入力して下さい' : null,
              onSaved: (input) => _email = input,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: width * 0.04),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: height * 0.016),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                hintText: 'メールアドレスを入力',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

//パスワード欄
  Widget _buildPasswordTF() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Password',
            style: kLabelStyle,
          ),
          SizedBox(height: height * 0.01),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(height * 0.01),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: height * 0.07,
            child: TextFormField(
              validator: (input) =>
                  input!.length < 6 ? '       パスワードが短すぎます' : null,
              onSaved: (input) => _password1 = input,
              obscureText: visibility1,
              keyboardType: TextInputType.visiblePassword,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: width * 0.04),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: height * 0.016),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                      visibility1 = !visibility1;
                    });
                  },
                  child: visibility1 == false
                      ? Icon(
                          Icons.visibility,
                          color: Colors.black45,
                        )
                      : Icon(
                          Icons.visibility_off,
                          color: Colors.black45,
                        ),
                ),
                hintText: 'パスワードを入力',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
          SizedBox(height: height * 0.01),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(height * 0.01),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: height * 0.07,
            child: TextFormField(
              validator: (input) =>
                  input!.length < 6 ? '       パスワードが短すぎます' : null,
              onSaved: (input) => _password2 = input,
              obscureText: visibility1,
              keyboardType: TextInputType.visiblePassword,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: width * 0.04),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: height * 0.016),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                      visibility1 = !visibility1;
                    });
                  },
                  child: visibility1 == false
                      ? Icon(
                          Icons.visibility,
                          color: Colors.black45,
                        )
                      : Icon(
                          Icons.visibility_off,
                          color: Colors.black45,
                        ),
                ),
                hintText: 'パスワードを入力(確認用)',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.1,
        vertical: height * 0.030,
      ),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _submit(context);
        },
        padding: EdgeInsets.all(height * 0.02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height * 0.04),
        ),
        color: Colors.white,
        child: Text(
          'SIGNUP',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: width * 0.03,
            fontSize: height * 0.030,
            fontWeight: FontWeight.bold,
            //fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return TextButton(
        onPressed: () {
          _formKey.currentState!.save();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LoginScreen(
                  // email: _email,
                  // signIn: true,
                  ),
            ),
          );
        },
        child: Text('- Back -',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white)));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //
    //return FutureBuilder(
    //future: usersRef.document(widget.userId).get(),
    //builder: (BuildContext context, AsyncSnapshot snapshot) {
    return Scaffold(
      body: GestureDetector(
        //キーボー���をしまうコード
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          //背景グラデーション
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.2, 0.5, 0.7, 0.95],
              colors: [
                Color(0xFF73AEF5),
                Color(0xFF61A4F1),
                Color(0xFF478DE0),
                Color(0xFF398AE5),
              ],
            ),
          ),
          //大きさ調整
          height: height,
          width: width,
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: width * 0,
                vertical: height * 0.07,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                    height: height * 0.17,
                    child: Image.asset(
                      //vizのタイトル写真
                      'assets/images/wiLL_White.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: height * 0.03,
                        ),
                        // _buildNameTF(),
                        // SizedBox(
                        //   height: height * 0.03,
                        // ),
                        _buildEmailTF(),
                        SizedBox(
                          height: height * 0.025,
                        ),
                        _buildPasswordTF(),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        _buildLoginBtn(),
                        SizedBox(
                          height: height * 0.06,
                        ),
                        _buildSignupBtn(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
