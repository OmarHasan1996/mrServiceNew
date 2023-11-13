import 'package:closer/MyWidget.dart';
import 'package:closer/color/MyColors.dart';
import 'package:closer/constant/app_size.dart';
import 'package:closer/constant/font_size.dart';
import 'package:closer/helper/shareWidgetpdf.dart';
import 'package:closer/localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderRecipt extends StatefulWidget {
  var order;
  OrderRecipt({Key? key, required this.order}) : super(key: key);
  @override
  State<OrderRecipt> createState() => _OrderReciptState();
}

class _OrderReciptState extends State<OrderRecipt> {

  String _num = '57898';
  String _numDelivery = '57898';
  String _date = 'July 12 , 2021';
  String _addressTitleBilling = '----';
  String _addressPhoneBilling = '----';
  String _addressNoteBilling = '----';
  String _addressTitle = 'ttt';
  String _addressPhone = '999';
  String _addressNote = '999';
  List _orderItems = [1,2];
  double _tax = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _num = widget.order['Serial'].toString();
    _numDelivery = widget.order['Serial'].toString();
    _date = widget.order['EndDate']??'';
    _addressTitle = widget.order['Address']['Title'];
    _addressPhone = "${widget.order['Address']['building']??''} - ${widget.order['Address']['appartment']}";
    _addressNote = widget.order['Address']['notes'];
    _orderItems = widget.order['Servicess'];
    _addressTitleBilling = widget.order['User']['Email'];
    _addressPhoneBilling = widget.order['User']['Mobile'];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidget.appBar(title: AppLocalizations.of(context)!.translate('INVOICE')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: _recipt(),
            ),
          ),
          MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('Download Receipt'), ()=> _download(), AppWidth.w90, false),
          SizedBox(height: AppPadding.p20,)
        ],
      ),
    );
  }

  Widget _recipt(){
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: AppWidth.w2, color: AppColors.Whitegray.withOpacity(0.4))
      ),
      margin: EdgeInsets.symmetric(horizontal: AppPadding.p20, vertical: AppPadding.p10),
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p10, vertical: AppPadding.p10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate('INVOICE')),
              MyWidget(context).textBlack20(_date, scale: 0.8),
            ],
          ),
          MyWidget(context).textHead10(AppLocalizations.of(context)!.translate('INVOICE')  + '#  $_num', color: AppColors.red, scale: 0.4),
          MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate('Delivery No') + ': $_numDelivery', scale: 0.8),
          Divider(color: AppColors.black, thickness: 1,),
          MyWidget(context).textHead10(AppLocalizations.of(context)!.translate('Billing Address'), color: AppColors.black, scale: 0.4),
          MyWidget(context).textBlack20(_addressTitleBilling, scale: 0.7, color: AppColors.gray),
          MyWidget(context).textBlack20(_addressPhoneBilling, scale: 0.7, color: AppColors.gray),
          //MyWidget(context).textBlack20(_addressNoteBilling, scale: 0.7, color: AppColors.gray),
          Divider(color: AppColors.gray, thickness: 1,),
          MyWidget(context).textHead10(AppLocalizations.of(context)!.translate('Shipping Address'), color: AppColors.black, scale: 0.4),
          MyWidget(context).textBlack20(_addressTitle, scale: 0.7, color: AppColors.gray),
          MyWidget(context).textBlack20(_addressPhone, scale: 0.7, color: AppColors.gray),
          MyWidget(context).textBlack20(_addressNote, scale: 0.7, color: AppColors.gray),
          Divider(color: AppColors.gray, thickness: 1,),
          _tableRow(color: AppColors.black, scale: 0.4,
              text1: AppLocalizations.of(context)!.translate('Item Description'),
              text2: AppLocalizations.of(context)!.translate('Price'),
              text3: AppLocalizations.of(context)!.translate('QTY'),
              text4: AppLocalizations.of(context)!.translate('Total')
          ),
          Divider(color: AppColors.black, thickness: 1,),
          Column(
            children: _orderItems.map((e) =>
                _tableRow1(color: AppColors.gray, scale: 0.35,
                  text1: e['Service']['Name'],
                  text2: e['Service']['Price']??0.0,
                  text3: e['Quantity'],
                ),).toList(),
          ),
          SizedBox(height: AppHeight.h1,),
          Row(
            children: [
              Expanded(
                flex: 5,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*    MyWidget(context).textHead10(AppLocalizations.of(context)!.translate('Payment Method'), color: AppColors.black, scale: 0.4),
                          MyWidget(context).textHead10('Payment Method', color: AppColors.gray, scale: 0.35),
                      */  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.all(AppPadding.p10),
                  child: Column(
                    children: [
                      /*Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MyWidget(context).textHead10(AppLocalizations.of(context)!.translate('SubTotal:'), color: AppColors.gray, scale: 0.32),
                                  MyWidget(context).textHead10(_sumPrice().toString(), color: AppColors.black, scale: 0.4),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MyWidget(context).textHead10('Tax:', color: AppColors.gray, scale: 0.32),
                                  MyWidget(context).textHead10('$_tax', color: AppColors.black, scale: 0.4),
                                ],
                              ),
                              Divider(thickness: 1, color: AppColors.gray,),*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyWidget(context).textHead10('Total:', color: AppColors.gray, scale: 0.4),
                          MyWidget(context).textHead10('${_sumPrice() + _tax}', color: AppColors.black, scale: 0.4),
                          SizedBox(width: AppWidth.w1,)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(color: AppColors.black, thickness: 1,),
          MyWidget(context).textHead10(AppLocalizations.of(context)!.translate('Terms & Condition'), color: AppColors.black, scale: 0.4),
          MyWidget(context).textBlack20(AppLocalizations.of(context)!.translate('Terms & Condition desc'), scale: 0.7, color: AppColors.gray),
        ],
      ),
    );
  }

  _tableRow({required color, required scale, required text1, required text2, required text3, required text4}){
    return  Row(
      children: [
        Expanded(
          flex: 5,
          child: MyWidget(context).textHead10(text1, color: color, scale: scale),
        ),
        Expanded(
          flex: 2,
          child: MyWidget(context).textHead10(text2, color: color, scale: scale, textAlign: TextAlign.center),
        ),
        Expanded(
          flex: 1,
          child: MyWidget(context).textHead10(text3, color: color, scale: scale*0.9, textAlign: TextAlign.center),
        ),
        Expanded(
          flex: 2,
          child: MyWidget(context).textHead10(text4, color: color, scale: scale, textAlign: TextAlign.center),
        )
      ],
    );

  }

  _sumPrice(){
    var p = 0.0;
    for(var e in _orderItems){
      p += e['Service']['Price']??0.0;
    }
    return p;
  }
  Widget _tableRow1({required color, required scale, required text1, required text2, required text3}){
    var text4 = text2 * text3;
    return  Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: MyWidget(context).textHead10('$text1', color: color, scale: scale),
            ),
            Container(color: AppColors.black, height: FontSize.s16*2, width: 1,),
            Expanded(
              flex: 2,
              child: MyWidget(context).textHead10('$text2', color: color, scale: scale, textAlign: TextAlign.center),
            ),
            Container(color: AppColors.black, height: FontSize.s16*2, width: 1,),
            Expanded(
              flex: 1,
              child: MyWidget(context).textHead10('$text3', color: color, scale: scale, textAlign: TextAlign.center),
            ),
            Container(color: AppColors.black, height: FontSize.s16*2, width: 1,),
            Expanded(
              flex: 2,
              child: MyWidget(context).textHead10('$text4', color: color, scale: scale, textAlign: TextAlign.center),
            )
          ],
        ),
        Divider(height: 1, color: AppColors.black,)
      ],
    );
  }

  _download() {
    ShareWiggetAsPdf(widget: _recipt(), name: _num.toString()).sharePdf();
  }

}
