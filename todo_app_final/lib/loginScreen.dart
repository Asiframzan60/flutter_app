
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mad_final/mainPage.dart';


void main() => runApp(loginScreen());

class loginScreen extends StatelessWidget {

  loginScreen(){
    BuildContext context;
  }


  Color primaryColor = Colors.black87;
  Color secondaryColor = Colors.white;
  Color logoColor  =   Colors.redAccent;

  String email, password;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Text('Login & SignUP Screen' , style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 100,
                  ),
                  Container(

                    child: SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('Enter E-Mail'),
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    focusColor: Colors.blue,

                                  ),
                                  cursorColor: Colors.red,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text('Enter Password'),
                                TextField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    focusColor: Colors.blue,

                                  ),
                                  cursorColor: Colors.red,
                                  obscureText: true,
                                ),
                                SizedBox(
                                  height: 100,
                                ),
                                MaterialButton(
                                  elevation: 0,
                                  minWidth: double.maxFinite,
                                  height: 50,
                                  onPressed: () => logIn(context),
                                  color: logoColor,
                                  child: Text('Login',
                                      style: TextStyle(color: Colors.white, fontSize: 16)),
                                  textColor: Colors.white,
                                ),
                                SizedBox(height: 20),
                                MaterialButton(
                                  elevation: 0,
                                  minWidth: double.maxFinite,
                                  height: 50,
                                  onPressed: () => registerUser(context),
                                  color: Colors.blue,
                                  child: Text('Register',
                                      style: TextStyle(color: Colors.white, fontSize: 16)),
                                  textColor: Colors.white,
                                ),
                                SizedBox(height: 20),
                                SizedBox(height: 100),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],

              ),
            )
          )),
    );
  }
  /*_buildFooterLogo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Image.asset(
            'images/logo.png',
            height: 40,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }*/
  /*_buildTextField(TextEditingController controller, IconData icon, String labelText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: secondaryColor, borderRadius: BorderRadius.circular(20),border: Border.all(color: Colors.blue)),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.black87),
            icon: Icon(
              icon,
              color: Colors.black87,
            ),
            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    );


  }*/
  void _getEmail(){
    email = nameController.text.toString();
  }
  void _getPassword(){
    password = passwordController.text.toString();
  }
  Future<void> signOutGoogle() async {

    Firebase.initializeApp();

    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    print("User Signed Out");
  }
  Future<void> registerUser(context) async{

    Firebase.initializeApp();
    _getEmail();
    _getPassword();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if(result!=null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
      }
    }
    catch(e){
      print(e.toString());
    }
    return null;

  }
  Future<void> signInWithGoogle() async {

    BuildContext context;

    await Firebase.initializeApp();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    //await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');
    }

    return null;
  }
  Future<void> logIn(context) async{
    try{
      Firebase.initializeApp();
      _getEmail();
      _getPassword();
      UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if(user!=null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
        Fluttertoast.showToast(msg: "Logged In Succesfuly");
      }

    }
    catch(error){
      Fluttertoast.showToast(
        msg: error.toString(),
        timeInSecForIosWeb: 3,
      );
    }


  }

  Future admin(BuildContext context) async {
    _getPassword();
    _getEmail();
    if(email=='admin' && password =='admin') {

      Fluttertoast.showToast(msg: 'Logged In as Admin');
    }
    else{
      Fluttertoast.showToast(msg: 'Please Enter Admin Email and Password');
    }
  }
}


