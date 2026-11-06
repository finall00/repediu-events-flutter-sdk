import 'package:flutter_test/flutter_test.dart';
import 'package:repediu_events/repediu_events.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('calls made before init completes are replayed once it does', () async {
    SharedPreferences.setMockInitialValues({});

    Repediu.identify(userId: '42');
    Repediu.screen('/menu');
    expect(Repediu.userId, isNull);

    await Repediu.init(writeKey: 'wk_test', endpoint: 'https://collector.test/collect');

    expect(Repediu.userId, '42');
    expect((await SharedPreferences.getInstance()).getString('_rpd_uid'), '42');
  });

  test('init called twice at once starts a single client', () async {
    final first = Repediu.init(writeKey: 'wk_other', endpoint: 'https://collector.test/collect');
    final second = Repediu.init(writeKey: 'wk_other', endpoint: 'https://collector.test/collect');
    expect(identical(first, second), isTrue);
    await first;
  });
}
