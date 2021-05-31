import 'dart:convert';

const kLoginSucessResponseMap = {
  "objectId": "WWxADcHG2i",
  "username": "usuario_teste@gmail.com",
  "email": "usuario_teste@gmail.com",
  "firstName": "Usuario",
  "lastName": "Teste",
  "createdAt": "2021-04-24T19:25:58.814Z",
  "updatedAt": "2021-04-24T19:25:58.814Z",
  "ACL": {
    "ySHIHT13xA": {"read": true, "write": true}
  },
  "sessionToken": "r:acc24187bc16109398c5a2fad2f06d0a"
};

const kSignUpSucessResponseMap = {
  "objectId": "WWxADcHG2i",
  "createdAt": "2018-11-08T13:08:42.914Z",
  "sessionToken": "r:acc24187bc16109398c5a2fad2f06d0a"
};

String get kLoginSucessResponseJSON => json.encode(kLoginSucessResponseMap);

String get kSignUpSucessResponseJSON => json.encode(kSignUpSucessResponseMap);
