import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

List payStatusList = [
  {"title": "订单号:", "text": "HAIHONG-"},
  {"title": "订单状态:", "text": "SUCCESS"},
  {"title": "订单状态描述:", "text": "支付成功"},
];

class payResult extends StatefulWidget {
  const payResult({Key? key}) : super(key: key);

  @override
  State<payResult> createState() => _payResultState();
}

class _payResultState extends State<payResult> {
  static const String _text = "西安宏海微码科技有限公司版权所有";
  String _closetext = "";

  @override
  void initState() {
    super.initState();
    getRequestFunction();
  }

  void getRequestFunction() async {
    ///创建Dio
    Dio dio = new Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) {
    //     return true;
    //   };
    // };
    // var jsonData = json.encode(data);
    String url =
        "https://www.haihongwm.com:8443/rest/services/weixinQueryByOutTradeNo";

    ///发起 get 请求
    Map<String, dynamic> map = {
      "payType": "app",
      "orderId": payStatusList[0]["text"]
    };

    Response response = await dio.post(url, data: map);
    var result = response.data;
    print(result);
    setState(() {
      payStatusList[0]["text"] = result["data"]["orderId"];
      payStatusList[1]["text"] = result["data"]["tradeState"];
      payStatusList[2]["text"] = result["data"]["tradeStateDesc"];
    });
    print(payStatusList);
    // getSign(orderInfo);
  }

  void putRequestFunction() async {
    ///创建Dio
    Dio dio = new Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) {
    //     return true;
    //   };
    // };
    // var jsonData = json.encode(data);
    String url =
        "https://www.haihongwm.com:8443/rest/services/weixinCloseOrderByOutTradeNo";

    ///发起 put 请求
    Map<String, dynamic> map = {
      "payType": "app",
      "orderId": payStatusList[0]["text"]
    };

    Response response = await dio.put(url, data: map);
    var result = response.data;
    print(result);
    setState(() {
      getRequestFunction();
    });
    print(payStatusList);

    // getSign(orderInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("订单支付状态"),
      ),
      body: Column(
        children: <Widget>[
          Container(
              height: 250,
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: payStatusList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.add_shopping_cart_rounded),
                        title: Text("${payStatusList[index]["title"]}"),
                        trailing: Text("${payStatusList[index]["text"]}"),
                      ),
                      Divider(),
                    ],
                  );
                },
              )),
          SizedBox(height: 25),
          // GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   child: Container(
          //       height: 22,
          //       child: Padding(
          //           padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          //           child: Row(mainAxisSize: MainAxisSize.max, children: [
          //             SizedBox(width: 180),
          //             Text(_closetext,
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                     color: Colors.red,
          //                     fontStyle: FontStyle.normal,
          //                     fontWeight: FontWeight.w500,
          //                     fontSize: 16,
          //                     height: 20 / 14))
          //           ]))),
          //   onTap: () {
          //     putRequestFunction();
          //   },
          // ),
          SizedBox(height: 122),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
                height: 22,
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                      SizedBox(width: 18),
                      // Text("",
                      //     style: TextStyle(
                      //         color: Color(0xFF282828),
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 20,
                      //         height: 23 / 20)),
                    ]))),
          ),
          SizedBox(
            height: 255,
            width: 160,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
                height: 40,
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                      SizedBox(height: 20, width: 120),
                      Text(_text,
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                          ))
                    ]))),
          ),
        ],
      ),
    );
  }
}
