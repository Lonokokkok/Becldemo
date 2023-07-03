import 'package:bcel/onepay/bcelone.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pubnub/networking.dart';
import 'package:pubnub/pubnub.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Bcel one'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    initQR();
    callback();
    super.initState();
  }

  String mcid = 'mch5c2f0404102fb';
  String uuidd = '';
  String _qrCodeString = '';
  String deepLink = 'onepay://qr/';

  Future initQR() async {
    setState(() {
      uuidd = 'KOKKOK-${DateTime.now().microsecondsSinceEpoch}';
    });
    String qrCodeString;
    try {
      qrCodeString = BceloneQR.bcelQr("mch5c2f0404102fb", uuidd,
          "terminalId123", 1, "invoiceId123", 'KOKKOK.....');
    } on PlatformException {
      qrCodeString = 'Failed to get platform version.';
    }
    setState(() {
      _qrCodeString = qrCodeString;
    });
    print(_qrCodeString);
  }

  Future callback() async {
    print('Ok');
    var pubnub = PubNub(
        defaultKeyset: Keyset(
            subscribeKey: 'sub-c-91489692-fa26-11e9-be22-ea7c5aada356',
            uuid: const UUID('BCELBANK')),
        networking: NetworkingModule(ssl: true));

    // Subscribe to a channel
    var channel = "uuid-$mcid-$uuidd";
    var subscription = pubnub.subscribe(channels: {channel});

    // Print every message
    subscription.messages.listen((message) async {
      print(message.content);
      // setState(() {
      //   uuid = res['uuid'];
      //   ticket = res['ticket'];
      //   fccref = res['fccref'];
      //   iid = res['iid'];
      // });
      // if (message.content != null && message.content != '') {
      //   var res = json.decode(message.content);
      //   print(res.toString());
      // }
      await subscription.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () async {
                await launchUrl(Uri.parse(deepLink + _qrCodeString));
              },
              child: const Text('ຊຳລະເງິນ'))
        ]),
      ),
    );
  }
}
