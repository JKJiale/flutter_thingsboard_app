import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:dio/dio.dart';
import 'payResult.dart';

class PayPage extends StatefulWidget {
  PayPage({Key? key}) : super(key: key);

  _PayPageState createState() => _PayPageState();
}

class Toast {
  // 自定义Toast
  static void show({
    required BuildContext context,
    required String message,
  }) {
    // 创建一个OverlayEntry对象
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      // 外层使用Position进行定位，控制在Overlay中的位置
      return Positioned(
        top: MediaQuery.of(context).size.height * 0.5,
        child: Material(
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Center(
              child: Card(
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(message,
                        style: TextStyle(
                          color: Colors.red,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ))),
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
    // 往Overlay中插入OverlayEntry
    Overlay.of(context)?.insert(overlayEntry);
    // 两秒后，移除Toast
    Future.delayed(Duration(seconds: 2)).then((value) => overlayEntry.remove());
  }
}

class _PayPageState extends State<PayPage> {
  static const String _text = "西安宏海微码科技有限公司版权所有";
  String _message = "等待支付中...";
  String _result = "";
  String _payment = "0.01";
  Map<String, dynamic> orderid = {"orderId": "TEST_ORDER_001"};
  Map<String, dynamic> orderdata = {
    "createdBy": "admin",
    "grandTotal": " 419.73",
    "orderDate": "2022-06-23T14:19:04.889+00:00",
    "orderId": "TEST_ORDER_001",
    "orderTypeId": "DEVCONSUMPTION_ORDER",
    "statusId": "ORDER_CREATED"
  };
  Map<String, dynamic> data = {
    "mode": "pro", // 支付模式，"dev"为测试1分，"pro"为实际金额
    "payType": "WEIXIN_APP", // 支付方式, 填"WEIXIN_APP"
    "createdBy": "admin", // 填订单头中的createdBy
    "orderId": "TEST_ORDER_001" // 订单号
  };

  Map<String, dynamic> orderInfo = {
    'appId': 'wx4e378f3bf58ee3d1',
    'partnerId': '00000000000',
    'prepayId': 'wx11133939895500b26f47dbbfd7d87a0000',
    'packageValue': 'Sign=WXPay',
    'nonceStr': 'noncestr',
    'timeStamp': "0000000000",
    "orderId": "orderid",
    'responseMessage': "responseMessage"
    // 'sign'
  };
  List orderList = [
    {"title": "createdBy:", "text": "admin"},
    {"title": "grandTotal:", "text": "419.73"},
    {"title": "orderDate:", "text": "2022-06-23T14:19:04.889+00:00"},
    {"title": "orderId:", "text": "TEST_ORDER_001"},
    {"title": "orderTypeId:", "text": "DEVCONSUMPTION_ORDER"},
    {"title": "statusId:", "text": "ORDER_CREATED"},
  ];
  @override
  void initState() {
    super.initState();
    _initFluwx();
    postRequestFunction2();
  }

  _initFluwx() async {
    await fluwx.registerWxApi(appId: "wx4e378f3bf58ee3d1");
    postRequestFunction1();
  }

  void postRequestFunction1() async {
    ///创建Dio
    Dio dio = new Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) {
    //     // if (cert.pem == PEM) {
    //     //   // Verify the certificate
    //     //   return true;
    //     // }
    //     return true;
    //   };
    // };
    // var jsonData = json.encode(data);
    String url =
        // "https://www.haihongwm.com:8443/rest/services/weixinCreateOrderV3ByAPP";
        "https://www.haihongwm.com:8443/rest/services/getDeviceConsumptionOrderHeaderByOrderId";

    ///发起 post 请求
    Response response = await dio.post(url, data: orderid);
    var result = response.data;
    print(result);
    setState(() {
      orderdata["createdBy"] = result["data"]["createdBy"];
      orderdata["grandTotal"] = result["data"]["grandTotal"];
      orderdata["orderDate"] = result["data"]["orderDate"];
      orderdata["orderId"] = result["data"]["orderId"];
      orderdata["orderTypeId"] = result["data"]["orderTypeId"];
      orderdata["statusId"] = result["data"]["statusId"];
      data["orderId"] = result["data"]["orderId"];
      data["createdBy"] = result["data"]["createdBy"];
      _payment = result["data"]["grandTotal"];
    });
    print(orderdata);
    print(data);
  }

  void postRequestFunction2() async {
    Dio dio = new Dio();

    String url =
        // "https://www.haihongwm.com:8443/rest/services/weixinCreateOrderV3ByAPP";
        "https://www.haihongwm.com:8443/rest/services/getDeviceConsumptionOrderPayLinkByOrderId";

    ///发起 post 请求
    Response response = await dio.post(url, data: data);
    var result = response.data;
    print(result);
    setState(() {
      orderInfo["prepayId"] = result["data"]["payLink"]["prepayid"];
      orderInfo["timeStamp"] = result["data"]["payLink"]["timestamp"];
      orderInfo["paySign"] = result["data"]["payLink"]["sign"];
      orderInfo["nonceStr"] = result["data"]["payLink"]["noncestr"];
      orderInfo["orderId"] = result["data"]["payLink"]["orderId"];
      orderInfo["responseMessage"] =
          result["data"]["payLink"]["responseMessage"];

      payStatusList[0]["text"] = result["data"]["payLink"]["orderId"];
    });
    print(orderInfo);
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
      "orderId": orderInfo["orderId"]
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

  /// 微信支付
  void paymentWechat(orderInfo) async {
    // / 判断手机上是否安装微信
    await fluwx.payWithWeChat(
      appId: orderInfo['appId'],
      partnerId: orderInfo['partnerId'],
      prepayId: orderInfo['prepayId'],
      packageValue: orderInfo['packageValue'],
      nonceStr: orderInfo['nonceStr'],
      timeStamp: int.parse(orderInfo['timeStamp']),
      sign: orderInfo['paySign'],
    );
    fluwx.weChatResponseEventHandler.distinct().listen((event) {
      if (event.errCode == 0) {
        print("支付成功");
        // Get.back(result: true);

        setState(() {
          _message = "支付成功";
          _result = "订单查询";
          getRequestFunction();
          setState(() {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => payResult()));
          });
        });
      } else if (event.errCode == -2) {
        print("用户取消");

        setState(() {
          _message = "用户取消";
          _result = "订单查询";
          Toast.show(context: context, message: '提示：支付失败!');
        });
      } else {
        print("支付失败,发生错误");

        setState(() {
          _message = "支付失败";
          _result = "订单查询";
          Toast.show(context: context, message: '提示：支付失败!');
        });
      }
    });
  }

  List payList = [
    {
      "title": "微信支付",
      "chekced": true,
      "image": "https://www.itying.com/themes/itying/images/weixinpay.png"
    },
    {
      "title": "支付宝支付",
      "chekced": false,
      "image": "https://www.itying.com/themes/itying/images/alipay.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("订单支付"),
      ),
      body: Column(
        children: <Widget>[
          // SizedBox(height: 40),
          // GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   child: Container(
          //       height: 22,
          //       child: Padding(
          //           padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          //           child: Row(mainAxisSize: MainAxisSize.max, children: [
          //             SizedBox(width: 18),
          //             Text("当前用户水费欠费金额为:$_payment元",
          //                 style: TextStyle(
          //                     color: Color(0xFF282828),
          //                     fontWeight: FontWeight.w500,
          //                     fontSize: 20,
          //                     height: 23 / 20)),
          //           ]))),
          // ),
          // SizedBox(height: 50),
          // GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   child: Container(
          //       height: 22,
          //       child: Padding(
          //           padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          //           child: Row(mainAxisSize: MainAxisSize.max, children: [
          //             SizedBox(width: 18),
          //             Text(_message,
          //                 style: TextStyle(
          //                     color: Colors.blueGrey,
          //                     fontStyle: FontStyle.normal,
          //                     fontWeight: FontWeight.w500,
          //                     fontSize: 16,
          //                     height: 20 / 14))
          //           ]))),
          // ),
          // SizedBox(height: 50),
          // GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   child: Container(
          //       height: 22,
          //       child: Padding(
          //           padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          //           child: Row(mainAxisSize: MainAxisSize.max, children: [
          //             SizedBox(width: 18),
          //             Text(_result,
          //                 style: TextStyle(
          //                     color: Colors.red,
          //                     fontStyle: FontStyle.normal,
          //                     fontWeight: FontWeight.w500,
          //                     fontSize: 16,
          //                     height: 20 / 14))
          //           ]))),
          //   onTap: () {
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (context) => payResult()));
          //   },
          // ),
          Container(
              height: 440,
              padding: EdgeInsets.all(5),
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        // leading: Icon(Icons.add_shopping_cart_rounded),
                        title: Text("${orderList[index]["title"]}"),
                        trailing: Text("${orderList[index]["text"]}"),
                      ),
                      Divider(),
                    ],
                  );
                },
              )),

          Text("订单详情"),
          Container(
              height: 175,
              padding: EdgeInsets.all(5),
              child: ListView.builder(
                itemCount: this.payList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading:
                            Image.network("${this.payList[index]["image"]}"),
                        title: Text("${this.payList[index]["title"]}"),
                        trailing: this.payList[index]["chekced"]
                            ? Icon(Icons.check)
                            : Text(""),
                        onTap: () {
                          //让payList里面的checked都等于false
                          setState(() {
                            for (var i = 0; i < this.payList.length; i++) {
                              this.payList[i]['chekced'] = false;
                            }
                            this.payList[index]["chekced"] = true;
                          });
                        },
                      ),
                      Divider(),
                    ],
                  );
                },
              )),
          Text("请选择支付方式"),
          SizedBox(
            height: 20,
            width: 160,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
                height: 20,
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
      bottomSheet: Container(
        height: 70,
        width: 430,
        color: Colors.red,
        child: TextButton(
            child: Text(
              "微信支付$_payment元",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              // print(orderInfo);
              // postRequestFunction();

              paymentWechat(orderInfo);
            }),
      ),
      // floatingActionButton: FloatingActionButton(
      //   //   _incrementCounter
      //   child: const Text("调用"),
      //   onPressed: () {
      //     setState(() {
      //       Toast.show(context: context, message: '提示：支付失败!');
      //     });
      //   },
      //   tooltip: 'Increment',
      // ),
    );
  }
}
