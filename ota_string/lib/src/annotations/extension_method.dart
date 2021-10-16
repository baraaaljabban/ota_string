class OtaStringClass {
  final String translationServer;

  ///If null then will take translationServer as the translation
  final String? translationServerStg;

  ///Language Key order need to in order with your json response of your translation
  final List<String> languageKey;

  const OtaStringClass({
    required this.translationServer,
    this.translationServerStg,
    required this.languageKey
  });
}