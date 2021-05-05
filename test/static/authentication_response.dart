import 'dart:convert';

const kLoginSucessResponseMap = {
  "objectId": "ySHIHT13xA",
  "username": "michelhanzenscheeren@gmail.com",
  "email": "michelhanzenscheeren@gmail.com",
  "firstName": "Michel",
  "lastName": "Hanzen Scheeren",
  "createdAt": "2021-04-24T19:25:58.814Z",
  "updatedAt": "2021-04-24T19:25:58.814Z",
  "ACL": {
    "ySHIHT13xA": {"read": true, "write": true}
  },
  "sessionToken": "r:acc24187bc16109398c5a2fad2f06d0a"
};

const kSignUpSucessResponseMap = {
  "objectId": "ySHIHT13xA",
  "createdAt": "2018-11-08T13:08:42.914Z",
  "sessionToken": "r:acc24187bc16109398c5a2fad2f06d0a"
};

String get kLoginSucessResponseJSON => json.encode(kLoginSucessResponseMap);

String get kSignUpSucessResponseJSON => json.encode(kSignUpSucessResponseMap);
