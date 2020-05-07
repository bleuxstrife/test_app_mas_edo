import 'package:logger/logger.dart';

class _CustomPrinter extends LogPrinter {
  @override
  void log(LogEvent event) {
    println("${event.level.toString().replaceAll("Level.", "")}: ${event.message}");
  }
}

final Logger logger = Logger(printer: _CustomPrinter());