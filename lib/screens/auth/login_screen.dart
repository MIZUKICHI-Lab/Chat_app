// import 'package:chat_application/main.dart';
// import 'package:chat_application/screens/home_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   GoogleSignIn googleSignIn = GoogleSignIn();
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   Future signInFunction() async {
//     GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//     if (googleUser == null) {
//       return;
//     }
//     final googleAuth = await googleUser.authentication;
//     final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
//     UserCredential userCredential =
//         await FirebaseAuth.instance.signInWithCredential(credential);

//     DocumentSnapshot userExist =
//         await firestore.collection('users').doc(userCredential.user!.uid).get();

//     if (userExist.exists) {
//       print("User Already Exists in Database");
//     } else {
//       await firestore.collection('users').doc(userCredential.user!.uid).set({
//         'email': userCredential.user!.email,
//         'name': userCredential.user!.displayName,
//         'image': userCredential.user!.photoURL,
//         'uid': userCredential.user!.uid,
//         'date': DateTime.now(),
//       });
//     }

//     Navigator.pushAndRemoveUntil(context,
//         MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image: NetworkImage(
//                             "https://cdn.iconscout.com/icon/free/png-256/chat-2639493-2187526.png"))),
//               ),
//             ),
//             Text(
//               "Flutter Chat App",
//               style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//               child: ElevatedButton(
//                 onPressed: () async {
//                   await signInFunction();
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.network(
//                       'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png',
//                       height: 36,
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       "Sign in With Google",
//                       style: TextStyle(fontSize: 20),
//                     )
//                   ],
//                 ),
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.black),
//                     padding: MaterialStateProperty.all(
//                         EdgeInsets.symmetric(vertical: 12))),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'forgetPassword_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  final User? users;
  final String? userId;
  final String? currentUserId;
  final String? email;
  final bool? signIn;
  static final String id = 'login_screen';

  LoginScreen({
    this.userId,
    this.users,
    this.currentUserId,
    this.email,
    this.signIn,
  });

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool logined = false;
  bool visibility = true;
  String _errorText = '';
  TextEditingController? _controller;

  @override
  void initState() {
    //getEmail();

    if (widget.email != null) {
      _email = widget.email!;
    }

    _controller = TextEditingController(text: widget.email);
    super.initState();
  }

  void login() {
    setState(() {
      logined = true;
    });
  }

  void logout() {
    setState(() {
      logined = false;
    });
  }

//////////////////////////////同意について////////////////////////
  bool _flag = false;

  void _handleCheckbox<bool>(e) {
    setState(() {
      _flag = e;
    });
  }

////////////////////////////メールサインイン/////////////////////////
  String? _email, _password;

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

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Logging in the user w/ Firebase
      try {
        var _authenticatedUser = await _auth.signInWithEmailAndPassword(
            email: _email!, password: _password!);
        print(_authenticatedUser.user!.emailVerified);
        if (_authenticatedUser.user!.emailVerified == false) {
          //Navigator.pushReplacementNamed(context, FeedScreen.id);
          _auth.signOut();
          _errorText = 'このアカウントは認証の確認ができていません';
          _auth.signOut();
        }
        if (!_flag) {
          //Navigator.pushReplacementNamed(context, FeedScreen.id);
          _auth.signOut();
          _errorText = '規約に同意が確認できません';
        }
        if (_authenticatedUser.user!.emailVerified == true && _flag) {
          if (widget.signIn == true) {
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }

          _auth.signInWithEmailAndPassword(
              email: _email!, password: _password!);
        }
      } catch (e) {
        print(e);
        print('メールアドレスかパスワードがちゃいます');
        _errorText = 'メールアドレスかパスワードが違います';
      }
    }
  }

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

///////メール欄/////////////////////////////////////////
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
              controller: _controller,
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
              keyboardType: TextInputType.visiblePassword,
              validator: (input) =>
                  input!.length < 6 ? '       パスワードが短すぎます' : null,
              onSaved: (input) => _password = input,
              obscureText: visibility,
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
                      visibility = !visibility;
                    });
                  },
                  child: visibility == false
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
        ],
      ),
    );
  }

//Forget password
  Widget _buildForgotPasswordBtn() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.1,
        vertical: height * 0,
      ),
      child: TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ForgetPasswordScreen(),
          ),
        ),
        child: Text(
          'パスワード忘れちゃった？',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.035),
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.1,
        vertical: height * 0.00,
      ),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: _submit,
        padding: EdgeInsets.all(height * 0.02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height * 0.04),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        if (widget.signIn == true) {
          Navigator.pop(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SignupScreen(),
            ),
          ).then((value) {
            setState(() {
              _controller = TextEditingController(text: value);
            });
          });
        }
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'アカウントをお持ちでないですか? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.035,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
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
        //キーボ���ドをしまうコード
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 60),
                    child: Container(
                      height: 100,
                      child: Image.asset(
                        //vizのタイトル写真
                        'assets/images/wiLL_White.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: height * 0.00,
                        ),
                        _buildEmailTF(),
                        SizedBox(
                          height: height * 0.025,
                        ),
                        _buildPasswordTF(),
                        _buildForgotPasswordBtn(),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: height * 0.01,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  _buildLoginBtn(),
                  SizedBox(
                    height: height * 0.005,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  //_buildSignInWithText(),
                  // _buildSocialBtnRow(),
                  SizedBox(
                    height: height * 0.025,
                  ),

                  //google
                  //_buildSocialBtn(),

                  _buildSignupBtn(),
                  //showFloatingFlushbar(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
