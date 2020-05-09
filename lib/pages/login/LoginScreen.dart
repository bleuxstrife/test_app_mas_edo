import 'package:flutter/material.dart';
import 'package:fluttertestapp/boilerplates/view.dart';
import 'package:fluttertestapp/presenter/login_presenter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends View<LoginScreen> {
  LoginPresenter _presenter;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    _presenter = LoginPresenter(context, this);
  }

  @override
  Widget buildView(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
//            Container(
//              child: Image.asset(
//                'images/pertamina-logo.png',
//                width: 200,
//                height: 53,
//                fit: BoxFit.cover,
//              ),
//              margin: const EdgeInsets.all(40.0),
//              alignment: Alignment.centerLeft,
//            ),
            Container(
              child: Text(
                'Hi, \nSelamat Datang!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
              margin: const EdgeInsets.all(40.0),
              alignment: Alignment.centerLeft,
            ),
            Container(
              margin: const EdgeInsets.all(40.0),
              child: TextFormField(
                controller: _presenter.userNameController,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your email'),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(40.0),
              child: TextFormField(
                controller: _presenter.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your password'),
              ),
            ),
            RaisedButton(
              child: Text(
                'SIGN IN',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              onPressed: () {
                _presenter.login();
              },
            ),
          ],
        ),
      ),
    );
  }




}
