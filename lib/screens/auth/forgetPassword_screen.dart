import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  final User? users;
  final String? userId;
  final String? currentUserId;
  static final String id = 'login_screen';

  ForgetPasswordScreen({
    this.userId,
    this.users,
    this.currentUserId,
  });

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool logined = false;

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

////////////////////////////メールサインイン//////////////////////////////
  String? _email;

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
      await _auth.sendPasswordResetEmail(email: _email!);
      //Navigator.of(context).pop();
    } else {}
  }

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

  Widget _buildLoginBtn() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.1,
        vertical: height * 0.030,
      ),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: EdgeInsets.all(height * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height * 0.04),
          ),
          primary: Colors.white,
        ),

        //color: Colors.white,
        child: Text(
          'メールを送信',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: width * 0.03,
            fontSize: width * 0.050,
            fontWeight: FontWeight.bold,
            //fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'ログイン画面にもどる',
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.04,
                fontWeight: FontWeight.w400,
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
        //キーボードをしまうコード
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
                      'assets/images/wiLL_White.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // SizedBox(
                        //   height: height * 0.03,
                        // ),
                        //_buildNameTF(),

                        SizedBox(
                          height: height * 0.025,
                        ),
                        _buildEmailTF(),
                        SizedBox(
                          height: height * 0.025,
                        ),
                        //_buildPasswordTF(),
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
