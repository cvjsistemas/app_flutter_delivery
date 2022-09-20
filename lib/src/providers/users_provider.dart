

import 'dart:convert';
import 'package:path/path.dart';
import 'dart:io';

import 'package:get/get.dart';
import 'package:udemy_flutter_delivery/src/enviroment/enviroment.dart';

import '../models/response_api.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class UsersProvider extends GetConnect {
  String url = Enviroment.API_URL + 'api/users';


  Future<Response> create(User user) async {
    Response response = await post(
        '$url/create',
        user.toJson(),
        headers: {
          'Content-Type' :'application/json'
        }
    );//ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    return response;
  }


  Future<Stream> createUserWithImage(User user, File image) async {
    Uri uri = Uri.http(Enviroment.API_URL_OLD,'/api/users/createwithimage');
    final request=http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile(
      'image',
      http.ByteStream(image.openRead().cast()),
      await image.length(),
      filename : basename(image.path)
    ));
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  /*
  * UTILIZANDO GET X
  * */
  Future<ResponseApi> createUserWithImageGetX(User user, File image) async {
    FormData form = FormData({
      'image':MultipartFile(image, filename: basename(image.path)),
      'user': json.encode(user)
    });


    Response response = await post('$url/createwithimage',form);//ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if (response.body ==null){
      Get.snackbar('Error en la peticion', 'No se pudo crear el usuario');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> login(String email, String password) async {
    Response response = await post(
        '$url/login',
        {
          'email':email,
          'password':password
        },
        headers: {
          'Content-Type' :'application/json'
        }
    );//ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if (response.body ==null){
      Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

}