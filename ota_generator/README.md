# Flutter Over The Air String

Source code generator to help create multi-language string translation with update over the air without any charges.  

# Getting Started
##1. Class for String
Create new class for your translation and put default value for every String and put @OtaStringClass annotation to generate the translation. 
```dart
part 'app_localize.g.dart';

@OtaStringClass(
    translationServer: 'your translation json',
    languageKey: ['en', 'zh', 'tlh']
)
class AppLocalize {
  final String _hello = 'DefaultHello';
  final String _name_location = 'Default My Name is {name}, Im from {location}';
}
```

For this first version you only can follow this format of Json to be able to update your String. 

Here's the sample JSON to update String :
```json
{
  "responseCode":200,
  "responseMessage":"Config",
  "response":{
    "token":"c52ce613bdccb7dd23fc08dff74ae5caba4547a3f1e3550a0df083694ee67d4b2e498bb4e8f98fcaacd243f37d9f85",
    "config":[
      {
        "key":"localization_en",
        "name":"localization_en",
        "value":{
          "hello":"Hi...",
          "name_location":"My name is {name} born in {location}"
        }
      },
      {
        "key":"localization_zh",
        "name":"localization_zh",
        "value":{
          "hello":"你好",
          "name_location":"我叫 {name} 出生在 {location}"
        }
      },
      {
        "key":"localization_tlh",
        "name":"localization_tlh",
        "value":{
          "hello":"Tar lIch...",
          "name_location":"'oH pongwIj'e' {name} bogh {location}"
        }
      }
    ]
  }
}
```

##2. Run Build Runner
Run the build runner to generate the code
```shell
flutter packages pub run build_runner build 
```

##3. Stagging VS Production
For Production specify otaStringProdEnv as true variable on when you run your Flutter project
```shell
flutter run --dart-define=otaStringProdEnv=true
```


Check Example project for more detail
