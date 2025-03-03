import 'package:animated_login/animated_login.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

/// Example login screen
class LoginScreen extends StatefulWidget {
  /// Simulates the multilanguage, you will implement your own logic.
  /// According to the current language, you can display a text message
  /// with the help of [LoginTexts] class.
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Example selected language, default is English.
  // LanguageOption language = _languageOptions[1];

  /// Current auth mode, default is [AuthMode.login].
  AuthMode currentMode = AuthMode.login;

  CancelableOperation? _operation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedLogin(
          onForgotPassword: _onForgotPassword,
          logo: Image.asset('assets/logo.png'),
          signUpMode: SignUpModes.both,
          loginDesktopTheme: _desktopTheme,
          loginMobileTheme: _mobileTheme,
          loginTexts: _loginTexts,
          emailValidator: ValidatorModel(
            validatorCallback: (String? email) => 'What an email! $email',
          ),
          changeLangDefaultOnPressed: () async => _operation?.cancel(),
          initialMode: currentMode,
          onAuthModeChange: (AuthMode newMode) async {
            currentMode = newMode;
            await _operation?.cancel();
          },
        ),
        Positioned(
          top: 20,
          left: 20, // Adjust as needed
          child: Material(
            elevation: 10, // Adds shadow effect
            shape: CircleBorder(),
            color: Colors
                .transparent, // Ensures background color applies only to button
            child: InkWell(
              borderRadius:
                  BorderRadius.circular(50), // Makes sure it's circular
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(15), // Adds spacing inside button
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // Background color
                ),
                child: Icon(
                  Icons.arrow_back, // Backward icon
                  color: Colors.black, // Change color if needed
                  size: 40,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<String?> _authOperation(Future<String?> func) async {
    await _operation?.cancel();
    _operation = CancelableOperation.fromFuture(func);
    final String? res = await _operation?.valueOrCancellation();
    if (_operation?.isCompleted == true) {
      // DialogBuilder(context).showResultDialog(res ?? 'Successful.');
    }
    return res;
  }

  Future<String?> _onForgotPassword(String email) async {
    await _operation?.cancel();
    // return await LoginFunctions(context).onForgotPassword(email);
  }

  // static List<LanguageOption> get _languageOptions => const <LanguageOption>[
  //       LanguageOption(
  //         value: 'Turkish',
  //         code: 'TR',
  //         iconPath: 'assets/images/tr.png',
  //       ),
  //       LanguageOption(
  //         value: 'English',
  //         code: 'EN',
  //         iconPath: 'assets/images/en.png',
  //       ),
  //     ];

  /// You can adjust the colors, text styles, button styles, borders
  /// according to your design preferences for *DESKTOP* view.
  /// You can also set some additional display options such as [showLabelTexts].
  LoginViewTheme get _desktopTheme => _mobileTheme.copyWith(
        // To set the color of button text, use foreground color.
        actionButtonStyle: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        dialogTheme: const AnimatedDialogTheme(
          languageDialogTheme: LanguageDialogTheme(
              optionMargin: EdgeInsets.symmetric(horizontal: 80)),
        ),
        loadingSocialButtonColor: Colors.blue,
        loadingButtonColor: Colors.white,
        privacyPolicyStyle: const TextStyle(color: Colors.black87),
        privacyPolicyLinkStyle: const TextStyle(
            color: Colors.blue, decoration: TextDecoration.underline),
      );

  /// You can adjust the colors, text styles, button styles, borders
  /// according to your design preferences for *MOBILE* view.
  /// You can also set some additional display options such as [showLabelTexts].
  LoginViewTheme get _mobileTheme => LoginViewTheme(
        // showLabelTexts: false,
        backgroundColor: Colors.blue, // const Color(0xFF6666FF),
        formFieldBackgroundColor: Colors.white,
        formWidthRatio: 60,
        actionButtonStyle: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        animatedComponentOrder: const <AnimatedComponent>[
          AnimatedComponent(
            component: LoginComponents.logo,
            animationType: AnimationType.right,
          ),
          AnimatedComponent(component: LoginComponents.title),
          AnimatedComponent(component: LoginComponents.description),
          AnimatedComponent(component: LoginComponents.formTitle),
          AnimatedComponent(component: LoginComponents.socialLogins),
          AnimatedComponent(component: LoginComponents.useEmail),
          AnimatedComponent(component: LoginComponents.form),
          AnimatedComponent(component: LoginComponents.notHaveAnAccount),
          AnimatedComponent(component: LoginComponents.forgotPassword),
          AnimatedComponent(component: LoginComponents.policyCheckbox),
          AnimatedComponent(component: LoginComponents.changeActionButton),
          AnimatedComponent(component: LoginComponents.actionButton),
        ],
        privacyPolicyStyle: const TextStyle(color: Colors.white70),
        privacyPolicyLinkStyle: const TextStyle(
            color: Colors.white, decoration: TextDecoration.underline),
      );

  LoginTexts get _loginTexts => LoginTexts(
        nameHint: 'Username',
        login: 'Login',
        signUp: 'Signup',
        // signupEmailHint: 'Signup Email',
        // loginEmailHint: 'Login Email',
        // signupPasswordHint: 'Signup Password',
        // loginPasswordHint: 'Login Password',
      );

  /// You can adjust the texts in the screen according to the current language
  /// With the help of [LoginTexts], you can 'create' a multilanguage scren.
  // String get _username => language.code == 'TR' ? 'Kullanıcı Adı' : 'Username';

  // String get _login => language.code == 'TR' ? 'Giriş Yap' : 'Login';

  // String get _signup => language.code == 'TR' ? 'Kayıt Ol' : 'Sign Up';

  /// Social login options, you should provide callback function and icon path.
  /// Icon paths should be the full path in the assets
  /// Don't forget to also add the icon folder to the "pubspec.yaml" file.
  // List<SocialLogin> _socialLogins(BuildContext context) => <SocialLogin>[
  //       SocialLogin(
  //           callback: () async => _socialCallback('Google'),
  //           iconPath: 'assets/images/google.png'),
  //       SocialLogin(
  //           callback: () async => _socialCallback('Facebook'),
  //           iconPath: 'assets/images/facebook.png'),
  //       SocialLogin(
  //           callback: () async => _socialCallback('LinkedIn'),
  //           iconPath: 'assets/images/linkedin.png'),
  //     ];

  // Future<String?> _socialCallback(String type) async {
  //   await _operation?.cancel();
  //   // _operation = CancelableOperation.fromFuture(
  //   //     LoginFunctions(context).socialLogin(type));
  //   final String? res = await _operation?.valueOrCancellation();
  //   if (_operation?.isCompleted == true && res == null) {
  //     // DialogBuilder(context)
  //     //     .showResultDialog('Successfully logged in with $type.');
  //   }
  //   return res;
  // }
}

/// Example forgot password screen
class ForgotPasswordScreen extends StatelessWidget {
  /// Example forgot password screen that user is navigated to
  /// after clicked on "Forgot Password?" text.
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('FORGOT PASSWORD'),
      ),
    );
  }
}
