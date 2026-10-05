import 'package:flutter_test/flutter_test.dart';

import 'package:prooflens/app/app.dart';

void main() {
  testWidgets('ProofLens app starts successfully', (tester) async {
    await tester.pumpWidget(const ProofLensApp());

    expect(find.text('ProofLens'), findsOneWidget);
    expect(find.text('Capture • Locate • Verify'), findsOneWidget);
  });
}