import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  // 构建应用
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '扫描条形码',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '扫描条形码'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  // 创建状态
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 扫描到的 ISBN-13
  String _isbn = '';

  @override
  // 构建 UI
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => scanISBN(),
              child: const Text('扫描条形码'),
            ),
            const SizedBox(height: 20),
            // 显示 Amazon 产品页面
            _isbn.isNotEmpty
                ? Expanded(
                    child: WebView(
                      initialUrl:
                          'https://www.amazon.co.jp/dp/${convertISBN13toISBN10(_isbn)}',
                      javascriptMode: JavascriptMode.unrestricted,
                    ),
                  )
                : const Text('请扫描一本书的条形码以显示其 Amazon 产品页面。')
          ],
        ),
      ),
    );
  }

  // 扫描 ISBN-13
  Future<void> scanISBN() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    if (!mounted) return;

    setState(() {
      _isbn = barcodeScanRes;
    });
  }

  // 转换 ISBN-13 为 ISBN-10
  String convertISBN13toISBN10(String isbn13) {
    if (isbn13.length == 13 && isbn13.startsWith('978')) {
      String isbn10 = isbn13.substring(3, 12);
      int sum = 0;
      for (int i = 0; i < 9; i++) {
        sum += int.parse(isbn10[i]) * (10 - i);
      }
      int check = 11 - (sum % 11);
      isbn10 += check == 10 ? 'X' : (check == 11 ? '0' : check.toString());
      return isbn10;
    }
    return isbn13; // 不可转换，返回原值
  }
}
