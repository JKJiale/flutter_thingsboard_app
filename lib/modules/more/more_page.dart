import 'package:flutter/material.dart';
import 'package:thingsboard_app/core/context/tb_context.dart';
import 'package:thingsboard_app/core/context/tb_context_widget.dart';
import 'package:thingsboard_client/thingsboard_client.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'Pay.dart';

class MorePage extends TbContextWidget {
  MorePage(TbContext tbContext) : super(tbContext);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends TbContextState<MorePage> {
  // int _counter = 0;
  String _text = "西安宏海微码科技有限公司版权所有";
  // String _message = "等待支付中...";
  @override
  void initState() {
    super.initState();
    _initFluwx();
  }

  _initFluwx() async {
    await fluwx.registerWxApi(appId: "wx4e378f3bf58ee3d1");
  }

  // void _incrementCounter() async {
  //   var result = await fluwx.isWeChatInstalled;

  //   await fluwx.shareToWeChat(fluwx.WeChatShareTextModel("source text",
  //       scene: fluwx.WeChatScene.FAVORITE));
  //   setState(() {
  //     _counter++;
  //     if (result) {
  //       _message = "微信安装状态:已安装";
  //     } else {
  //       _message = "微信安装状态:未安装";
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.fromLTRB(16, 40, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.account_circle,
                      size: 48, color: Color(0xFFAFAFAF)),
                  Spacer(),
                  IconButton(
                      icon: Icon(Icons.settings, color: Color(0xFFAFAFAF)),
                      onPressed: () async {
                        await navigateTo('/profile');
                        setState(() {});
                      })
                ],
              ),
              SizedBox(height: 22),
              Text(_getUserDisplayName(),
                  style: TextStyle(
                      color: Color(0xFF282828),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      height: 23 / 20)),
              SizedBox(height: 2),
              Text(_getAuthorityName(),
                  style: TextStyle(
                      color: Color(0xFFAFAFAF),
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      height: 16 / 14)),
              SizedBox(height: 24),
              Divider(color: Color(0xFFEDEDED)),
              SizedBox(height: 8),
              buildMoreMenuItems(context),
              SizedBox(height: 8),
              Divider(color: Color(0xFFEDEDED)),
              // SizedBox(height: 8),
              // GestureDetector(
              //     behavior: HitTestBehavior.opaque,
              //     child: Container(
              //         height: 18,
              //         child: Padding(
              //             padding:
              //                 EdgeInsets.symmetric(vertical: 0, horizontal: 18),
              //             child: Row(mainAxisSize: MainAxisSize.max, children: [
              //               Icon(Icons.add_shopping_cart,
              //                   color: Colors.blueGrey),
              //               SizedBox(width: 34),
              //               Text('缴水费',
              //                   style: TextStyle(
              //                       color: Colors.blueGrey,
              //                       fontStyle: FontStyle.normal,
              //                       fontWeight: FontWeight.w500,
              //                       fontSize: 14,
              //                       height: 20 / 14))
              //             ]))),
              //     onTap: () {
              //       // _incrementCounter();
              //       Navigator.of(context).push(
              //           MaterialPageRoute(builder: (context) => PayPage()));
              //     }),

              SizedBox(height: 8),
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                      height: 48,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 18),
                          child: Row(mainAxisSize: MainAxisSize.max, children: [
                            Icon(Icons.logout, color: Color(0xFFE04B2F)),
                            SizedBox(width: 34),
                            Text('注销',
                                style: TextStyle(
                                    color: Color(0xFFE04B2F),
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    height: 20 / 14))
                          ]))),
                  onTap: () {
                    tbClient.logout(
                        requestConfig: RequestConfig(ignoreErrors: true));
                  }),
              SizedBox(height: 80),
              // GestureDetector(
              //   behavior: HitTestBehavior.opaque,
              //   child: Container(
              //       height: 18,
              //       child: Padding(
              //           padding:
              //               EdgeInsets.symmetric(vertical: 0, horizontal: 18),
              //           child: Row(mainAxisSize: MainAxisSize.max, children: [
              //             Icon(Icons.format_list_numbered, color: Colors.black),
              //             SizedBox(width: 34),
              //             Text('$_counter',
              //                 style: TextStyle(
              //                     color: Colors.black,
              //                     fontStyle: FontStyle.normal,
              //                     fontWeight: FontWeight.w500,
              //                     fontSize: 14,
              //                     height: 20 / 14))
              //           ]))),
              // ),
              // Text('$_counter',
              //     style: TextStyle(
              //         color: Color(0xFF282828),
              //         fontWeight: FontWeight.w500,
              //         fontSize: 20,
              //         height: 23 / 20)),

              SizedBox(height: 100),
              // GestureDetector(
              //   behavior: HitTestBehavior.opaque,
              //   child: Container(
              //       height: 22,
              //       child: Padding(
              //           padding:
              //               EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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

              SizedBox(
                height: 100,
                width: 160,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                    height: 40,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        child: Row(mainAxisSize: MainAxisSize.max, children: [
                          SizedBox(height: 20, width: 100),
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
        ));
  }

  Widget buildMoreMenuItems(BuildContext context) {
    List<Widget> items = MoreMenuItem.getItems(tbContext).map((menuItem) {
      return GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
              height: 48,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 18),
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Icon(menuItem.icon, color: Color(0xFF282828)),
                    SizedBox(width: 34),
                    Text(menuItem.title,
                        style: TextStyle(
                            color: Color(0xFF282828),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            height: 20 / 14))
                  ]))),
          onTap: () {
            navigateTo(menuItem.path);
          });
    }).toList();
    return Column(children: items);
  }

  String _getUserDisplayName() {
    var user = tbContext.userDetails;
    var name = '';
    if (user != null) {
      if ((user.firstName != null && user.firstName!.isNotEmpty) ||
          (user.lastName != null && user.lastName!.isNotEmpty)) {
        if (user.firstName != null) {
          name += user.firstName!;
        }
        if (user.lastName != null) {
          if (name.isNotEmpty) {
            name += ' ';
          }
          name += user.lastName!;
        }
      } else {
        name = user.email;
      }
    }
    return name;
  }

  String _getAuthorityName() {
    var user = tbContext.userDetails;
    var name = '';
    if (user != null) {
      var authority = user.authority;
      switch (authority) {
        case Authority.SYS_ADMIN:
          name = '系统管理员'; //System Administrator
          break;
        case Authority.TENANT_ADMIN:
          name = '物业管理员'; //Tenant Administrator
          break;
        case Authority.CUSTOMER_USER:
          name = '客户'; //Customer
          break;
        case Authority.REFRESH_TOKEN:
          // TODO: Handle this case.
          break;
        case Authority.ANONYMOUS:
          // TODO: Handle this case.
          break;
      }
    }
    return name;
  }
}

class MoreMenuItem {
  final String title;
  final IconData icon;
  final String path;

  MoreMenuItem({required this.title, required this.icon, required this.path});

  static List<MoreMenuItem> getItems(TbContext tbContext) {
    if (tbContext.isAuthenticated) {
      List<MoreMenuItem> items = [];
      switch (tbContext.tbClient.getAuthUser()!.authority) {
        case Authority.SYS_ADMIN:
          break;
        case Authority.TENANT_ADMIN:
          items.addAll([
            MoreMenuItem(
                title: '客户', //Customers
                icon: Icons.supervisor_account,
                path: '/customers'),
            MoreMenuItem(
                title: '资产', //Assets
                icon: Icons.domain,
                path: '/assets'),
            MoreMenuItem(
                title: '审计日志', //Audit Logs
                icon: Icons.track_changes,
                path: '/auditLogs')
          ]);
          break;
        case Authority.CUSTOMER_USER:
          items.addAll([
            MoreMenuItem(title: 'Assets', icon: Icons.domain, path: '/assets')
          ]);
          break;
        case Authority.REFRESH_TOKEN:
          break;
        case Authority.ANONYMOUS:
          break;
      }
      return items;
    } else {
      return [];
    }
  }
}
