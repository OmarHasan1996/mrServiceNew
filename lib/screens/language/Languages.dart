import 'package:closer/MyWidget.dart';
import 'package:closer/api/api_service.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/const.dart';
import 'package:closer/constant/apiUrl.dart';
import 'package:closer/constant/app_size.dart';
import 'package:closer/constant/font_size.dart';
import 'package:closer/constant/functions.dart';
import 'package:closer/localization_service.dart';
import 'package:closer/localizations.dart';
import 'package:closer/screens/signin.dart';
import 'package:flutter/material.dart';
class Languages extends StatefulWidget {
  int selectedLang = 0, selectedCountry = 0, selectedCity = 0;
  bool main = false;
  Languages({Key? key, required this.main, required this.selectedLang, required this.selectedCity, required this.selectedCountry}) : super(key: key);

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  int _selectedLang = 0, _selectedCountry = 0, _selectedCity = 0;

  var _color1 = AppColors.mainColor;
  var _color2 = AppColors.white;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!widget.main){
      _color1 = AppColors.white;
      _color2 = AppColors.black;
    }
    _countryList.clear();
    for(var e in country){
      _countryList.add(e['Name']);
    }
    _cityList.clear();
    for(var e in city){
      _cityList.add(e['Name']);
    }
    _selectedLang = widget.selectedLang;
    _selectedCountry = widget.selectedCountry;
    _selectedCity = widget.selectedCity;
  }
  _read() async{
    await APIService.getCityData(country[_selectedCountry]['Id']);
    if(city.isNotEmpty) {
      _cityList.clear();
      _selectedCity = 0;
    }
    for(var e in city){
      _cityList.add(e['Name']);
    }
  setState(() {

  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.main?_color1:AppColors.selverBack,
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !widget.main? MyWidget.appBar(title: AppLocalizations.of(context)!.translate('Language')):
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppHeight.h10),
            child: Center(
              child: MyWidget(context).textHead10(AppLocalizations.of(context)!.translate('Language')),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.p20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppHeight.h2,),
                Padding(
                  padding: EdgeInsets.all(AppHeight.h1),
                  child: MyWidget(context).textTitle15(AppLocalizations.of(context)!.translate('Select your country'), color: _color2),
                ),
                _dropDownContry(),
                SizedBox(height: AppHeight.h1,),
                Padding(
                  padding: EdgeInsets.all(AppHeight.h1),
                  child: MyWidget(context).textTitle15(AppLocalizations.of(context)!.translate('Select your city'), color: _color2),
                ),
                _dropDownCity(),
                SizedBox(height: AppHeight.h2,),
                Padding(
                  padding: EdgeInsets.all(AppHeight.h1),
                  child: MyWidget(context).textTitle15(AppLocalizations.of(context)!.translate('Select your Language'), color: _color2),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: _color2),
                    borderRadius: BorderRadius.all(Radius.circular(AppWidth.w4)),
                  ),
                  padding: EdgeInsets.all(AppWidth.w4),
                  child: Column(
                    children: [
                      _laguageSelect(headText: 'English', titleText: AppLocalizations.of(context)!.translate('English'), select: 0),
                      Divider(color: _color2,),
                      _laguageSelect(headText: 'العربية', titleText: AppLocalizations.of(context)!.translate('Arabic'), select: 1),
                     // Divider(color: _color2,),
                    //  _laguageSelect(headText: 'Frânsk', titleText: AppLocalizations.of(context)!.translate('French'), select: 2),
                    ],
                  ),
                ),
                SizedBox(height: AppHeight.h4,),
                MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('Save'), ()=>_save(), AppWidth.w80, chLogIn)
              ],
            ),
          )
        ],
      ),
    );
  }
  List<String> _countryList = ['sudi', 'qatar', 'uae'];
  List<String> _cityList = ['Select Country first'];

  _dropDownContry() {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20,),
      decoration: BoxDecoration(
        border: Border.all(color: _color2),
        borderRadius: BorderRadius.all(Radius.circular(AppWidth.w4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: AppColors.mainColor1,
          // Initial Value
          value: _countryList[_selectedCountry],
          // Down Arrow Icon
          style: TextStyle(
        fontFamily: 'comfortaa',color: _color2, fontSize: FontSize.s20),
          icon: Icon(Icons.arrow_forward_ios, color: _color2,),
          // Array list of items
          items: _countryList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items,),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) async{
              if(newValue!=null){
                await APIService.getCityData(country[_countryList.indexOf(newValue)]['Id']);
                _selectedCountry = _countryList.indexOf(newValue);
                if(city.isNotEmpty) {
                _cityList.clear();
                _selectedCity = 0;
              }
              for(var e in city){
                  _cityList.add(e['Name']);
                }}
              setState(() {

              });
          },
        ),
      ),
    );
  }

  _dropDownCity() {

    return  Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20,),
      decoration: BoxDecoration(
        border: Border.all(color: _color2),
        borderRadius: BorderRadius.all(Radius.circular(AppWidth.w4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: AppColors.mainColor1,
          // Initial Value
          value: _cityList[_selectedCity],
          // Down Arrow Icon
          style: TextStyle(
        fontFamily: 'comfortaa',color: _color2, fontSize: FontSize.s20),
          icon: Icon(Icons.arrow_forward_ios, color: _color2,),
          // Array list of items
          items: _cityList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items,),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              if(newValue!=null) _selectedCity = _cityList.indexOf(newValue);
            });
          },
        ),
      ),
    );
  }

  _laguageSelect({required headText, required titleText, required select}){
    var isSelected = select==_selectedLang;
    return GestureDetector(
      onTap: ()=> setState(() {
        _selectedLang = select;
      }),
      child: Padding(
        padding: EdgeInsets.all(AppWidth.w2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyWidget(context).textHead10(headText, scale: 0.5, color: _color2),
                MyWidget(context).textTitle15(titleText, color: _color2),
              ],
            ),
            Container(
              width: AppWidth.w8,
              height: AppWidth.w8,
              decoration: BoxDecoration(
                color: isSelected? AppColors.mainColor1:!widget.main? AppColors.Whitegray:AppColors.purple1,
                borderRadius: BorderRadius.all(Radius.circular(AppWidth.w2)),
                //border: Border.all(color: AppColors.blackGray),
              ),
              child: isSelected ? Icon(Icons.check, color: _color1,):SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  _save() async{
    var lang = AppLocalizations.of(context)!.translate('english');
    if(_selectedLang == 0){
      lang = AppLocalizations.of(context)!.translate('english');
    }else if(_selectedLang == 1){
      lang = AppLocalizations.of(context)!.translate('arabic');
    }else if(_selectedLang == 2){
      lang = AppLocalizations.of(context)!.translate('france');
    }
    setState(() {
      chLogIn = true;
    });
    myCountry = _countryList[_selectedCountry];
    myCity = _cityList[_selectedCity];
    myCurrency = country[_selectedCountry]['Currency'];
    cityId = city[_selectedCity]['Id'].toString();
    await LocalizationService().changeLocale(lang, context);
    Navigator.of(context).pop();
    //MyApplication.navigateTorePlaceUntil(context, SignIn());
    setState(() {
      chLogIn = false;
    });
  }
}
