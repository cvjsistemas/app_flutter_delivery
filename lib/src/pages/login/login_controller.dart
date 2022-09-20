import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:udemy_flutter_delivery/src/models/response_api.dart';
import 'package:udemy_flutter_delivery/src/providers/users_provider.dart';

class LoginController extends GetxController {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  void goToRegisterPage(){
    Get.toNamed('/register');
  }

  void login() async{
    String email = emailController.text.trim();
    String password =passwordController.text.trim();


    print('Email ${email}');
    print('Password ${password}');

   // Get.snackbar('Email', email);
   // Get.snackbar('Password', password);
    if (isValidForm(email,password)){
      //Get.snackbar('Formulario valido', 'Estas listo para enviar la peticion Http');
      ResponseApi responseApi = await usersProvider.login(email, password);
      print('Response API : ${responseApi.toJson()}');

      if(responseApi.success ==true){
        GetStorage().write('user', responseApi.data);// DATOS DEL USUARIO EN SESION

        Get.snackbar('Login exitoso', responseApi.message ?? '');
        goToHomePage();
      } else{
        Get.snackbar('Login fallido', responseApi.message ?? '');
      }

    }
  }

  void goToHomePage(){
   // Get.toNamed('/home');
    Get.offNamedUntil('/home', (route) => false);
  }

bool isValidForm(String email, String password){



    if(email.isEmpty){
      Get.snackbar('Formulario no valido', 'Debes ingresar el email');
      return false;
    }

    if(!GetUtils.isEmail(email)){
      Get.snackbar('Formulario no valido', 'El email no es valido');
      return false;
    }

    if(password.isEmpty){
      Get.snackbar('Formulario no valido', 'Debes ingresar el password');
      return false;
    }

    return true;
}

}