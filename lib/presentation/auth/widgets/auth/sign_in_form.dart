import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:noteflow/core/base/app_routes.dart';
import 'package:noteflow/core/constant/app_color.dart';
import 'package:noteflow/core/constant/app_size.dart';
import 'package:noteflow/domain/entities/auth/sign_in_entity.dart';
import 'package:noteflow/presentation/auth/bloc/authentication/auth_bloc.dart';
import 'package:noteflow/presentation/note/ui/widgets/app_button.dart';


import '../../pages/auth/verify_email.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth: 500
                  ),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your E-Mail';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid E-Mail';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20,),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth: 500
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText:isVisible?false : true,
                    decoration:  InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon:  Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ), onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 5) {
                        return 'The password must contains more than five characters.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20,),
                BlocConsumer<AuthBloc,AuthState>(
                  listener: (context , state){
                    if(state is SignedInState){
                      BlocProvider.of<AuthBloc>(context).add(CheckLoggingInEvent());
                    }else if (state is SignedInPageState){
                      context.goNamed(AppRoutes.home.name);
                    }else if (state is VerifyEmailPageState ){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const VerifyEmail()));
                      BlocProvider.of<AuthBloc>(context).add(SendEmailVerificationEvent());
                    }
                  },
                  builder: (context,state) {
                    if(state is LoadingState){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }else if (state is ErrorAuthState){
                      return Column(
                        children: [
                          Center(
                            child: Text(state.message),
                          ),
                          Gap(15),
                          SizedBox(
                          width: double.infinity,
                          child: AppButton(
                          onPressed: (){
                          if(_passwordController.text.isNotEmpty&&_usernameController.text.isNotEmpty){
                          BlocProvider.of<AuthBloc>(context).add(SignInEvent(signInEntity: SignInEntity(password: _passwordController.text , email: _usernameController.text)));
                          }
                          },
                          backGroundColor: AppColor.themeColor,
                          height: AppHeight.s36, label: 'Login',labelColor: AppColor.windowBackgroundColor,),
                          )
                        ],
                      );

                    }
                    return SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        onPressed: (){
                          if(_passwordController.text.isNotEmpty&&_usernameController.text.isNotEmpty){
                            BlocProvider.of<AuthBloc>(context).add(SignInEvent(signInEntity: SignInEntity(password: _passwordController.text , email: _usernameController.text)));
                          }
                          },
                        backGroundColor: AppColor.themeColor,
                        height: AppHeight.s36, label: 'Login',labelColor: AppColor.windowBackgroundColor,),
                    );
                  }
                ),
                Container(
                    margin: const EdgeInsets.all(20),
                    child:  Stack(
                      alignment: Alignment.center,
                      children: [
                        ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxWidth: 500
                            ),
                            child: const Divider(thickness: 2,color: Colors.grey,)),
                        Positioned(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(15)
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 3),
                            child: const Text(
                              'OR',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        )
                      ],
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Need an account?"),
                    TextButton(
                        onPressed: (){
                          context.goNamed(AppRoutes.signup.name);
                        },
                        child: const Text("Signup") )
                  ],
                )
              ],
            ),
          ),
    );
  }

  Widget optionsBox({Color? color , required String? imagePath, required Function? onPressed }){
    return InkWell(
      onTap: (){
        onPressed!();
      },
      child: Container(
          height: 50,
          margin: const EdgeInsets.only(top: 0 , bottom: 20 , left: 10 ,right: 10  ),
          width: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(50),
          ),
          child:  Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(imagePath!, color: color,))
      ),
    );
  }

}
