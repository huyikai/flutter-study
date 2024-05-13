import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '秒表',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StopwatchPage(title: '秒表'),
    );
  }
}

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key, required this.title});

  final String title;

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  late Stopwatch _stopwatch; // 秒表对象
  late Duration _currentTime; // 当前时间

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _currentTime = Duration.zero;
  }

  // 切换开始停止状态
  void _toggleStopwatch() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
      } else {
        _stopwatch.start();
        _startTimer();
      }
    });
  }

  // 重置
  void _resetStopwatch() {
    setState(() {
      _stopwatch
        ..stop()
        ..reset();
      _currentTime = Duration.zero;
    });
  }

  // 开始一个定时器来更新当前时间
  void _startTimer() {
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (!_stopwatch.isRunning) {
        timer.cancel();
      }
      setState(() {
        _currentTime = _stopwatch.elapsed;
      });
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '计时: ${_currentTime.inMinutes}:'
              '${(_currentTime.inSeconds % 60).toString().padLeft(2, '0')}:'
              '${(_currentTime.inMilliseconds % 1000).toString().padLeft(3, '0')}',
            ),
            const SizedBox(height: 20), //间隔
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _toggleStopwatch,
                  child: Text(_stopwatch.isRunning ? 'Stop' : 'Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetStopwatch,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
