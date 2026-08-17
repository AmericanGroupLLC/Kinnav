// Driver for integration_test/app_test.dart.
//
// Its only job is to write the screenshots the test takes to disk — the test
// itself runs on the device and cannot reach the host filesystem.
//
//   flutter drive --driver=test_driver/integration_test.dart \
//     --target=integration_test/app_test.dart -d <device>
import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot: (String name, List<int> bytes, [Map<String, Object?>? _]) async {
      final file = File('build/screenshots/$name.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes);
      stdout.writeln('screenshot: ${file.path}');
      return true;
    },
  );
}
