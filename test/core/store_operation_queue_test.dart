import 'dart:async';
import 'package:copiqpolice/core/services/store_operation_queue.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('account switch waits until pending purchase finishes', () async {
    final queue = StoreOperationQueue();
    final receipt = Completer<void>();
    final started = Completer<void>();
    final actions = <String>[];
    final purchase = queue.run(() async {
      actions.add('purchase started');
      started.complete();
      await receipt.future;
      actions.add('purchase finished');
    });
    await started.future;
    final accountSwitch = queue.run(() async => actions.add('account switched'));
    await Future<void>.delayed(Duration.zero);
    expect(actions, ['purchase started']);
    receipt.complete();
    await Future.wait([purchase, accountSwitch]);
    expect(actions, ['purchase started', 'purchase finished', 'account switched']);
  });

  test('failed purchase does not block later identity work', () async {
    final queue = StoreOperationQueue();
    final failed = queue.run<void>(() async => throw StateError('store failed'));
    final next = queue.run(() async => 'new account');
    await expectLater(failed, throwsStateError);
    expect(await next, 'new account');
  });
}
