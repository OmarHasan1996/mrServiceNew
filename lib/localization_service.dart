import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/localizations.dart';

import 'const.dart';
import 'lang/en_US.dart';
import 'lang/fr_FR.dart';
class LocalizationService extends Translations{
  static final local =Locale('en','US');
  static final fallBackLocale = Locale('en','US');
  //static  List<String> langs =['English','France','Arabic','Turkish','العربية'];
  static  List<String> langs =['English','Arabic','Turkish','العربية'];
  static String MyLang = 'English';
  static final locales = [
  Locale('en','US'),
  //Locale('fr','FR'),
  Locale('ar','AR'),
  Locale('tr','TR'),
  ];
  static final intLang = [
  1,
  //4,
  3,
  2,
  ];

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US' :enUS,
    'fr_FR' :frFR,
  };
  
  changeLocale(String lang, context)async{
    if(lang == 'الإنكليزية' || lang == 'English'|| lang == 'English') {
      AppLocalizations.delegate.load(Locale('en','US'));
      lang = MyLang = 'English';
      //langs =['English','France','Arabic','Turkish'];
      //langs =['English','Arabic','Turkish'];
      langs =['English','Arabic'];
    }else if(lang == 'France' || lang == 'الفرنسية'|| lang == 'France'){
      AppLocalizations.delegate.load(Locale('fr','FR'));
      lang = MyLang = 'France';
      langs =['English','France','Arab','Turkish'];
    }else if(lang == 'العربية' || lang == 'Arabic' ||lang == 'Arab'){
      AppLocalizations.delegate.load(Locale('ar','AR'));
      lang = MyLang = 'العربية';
      //langs =['الإنكليزية','الفرنسية','العربية','التركية'];
      //langs =['الإنكليزية','العربية','التركية'];
      langs =['الإنكليزية','العربية'];
    }else if(lang == 'التركية' || lang == 'Turkish' ||lang == 'Turkish'){
      AppLocalizations.delegate.load(Locale('tr','TR'));
      lang = MyLang = 'Turkish';
      //langs =['English','France','Arabic','Turkish'];
      langs =['English','Arabic','Turkish'];
    }
    else{
      AppLocalizations.delegate.load(Locale('en','US'));
      lang = MyLang = 'English';
      //langs =['English','France','Arabic','Turkish'];
      //langs =['English','Arabic','Turkish'];
      langs =['English','Arabic'];
    }
    //langs =[AppLocalizations.of(context)!.translate('english'),AppLocalizations.of(context)!.translate('france'),AppLocalizations.of(context)!.translate('arabic')];
    try {await APIService(context: context).userLang(getIntFromLanguage(lang), userData!.content!.id);}
    catch(e) {print(e.toString());}
    final locale =getLocaleFromLanguage(lang);
    final box = GetStorage();
    box.write('lng', lang);
    box.write('country', myCountry);
    box.write('city', myCity);
    box.write('currency', myCurrency);
    Get.updateLocale(locale!);
  }

  static Locale? getLocaleFromLanguage(String lang) {
    for(int i =0 ; i< langs.length;i++){
      if(lang == langs[i]) return locales[i];
    }
    return Get.locale;
  }

  static int getIntFromLanguage(String lang) {
    for(int i =0 ; i< langs.length;i++){
      if(lang == langs[i]) return intLang[i];
    }
    return 1;
  }

  static Locale getCurrentLocale(){
    final box = GetStorage();
    Locale defaultLocale;
    if(box.read('lng')!= null){
      final locale = getLocaleFromLanguage(box.read('lng'));
      defaultLocale = locale!;
    }
    else{
      defaultLocale=Locale('en','US');
    }
    return defaultLocale;
  }

  static int getCurrentLangInt(){
    final box = GetStorage();
    int intLangu = 1;
    if(box.read('lng')!= null){
      final locale = getIntFromLanguage(box.read('lng'));
      intLangu = locale;
    }
    return intLangu;
  }


String getCurrentLang(){
    final box = GetStorage();
    myCity = box.read('city')?? myCity;
    myCountry = box.read('country')?? myCountry;
    myCurrency = box.read('currency')?? myCurrency;
    return box.read('lng')!= null?box.read('lng'):'English';
}

}