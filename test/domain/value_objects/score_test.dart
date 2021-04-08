import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/domain/value_objects/score.dart';

main() {
  test('Should be invalid when value is null', () {
    Score score = Score(null);
    expect(score.isValid, isFalse);
    expect(score.value, 0);
  });

  test('Should be invalid when value is negative', () {
    Score score = Score(-1);
    expect(score.isValid, isFalse);
    expect(score.value, 0);
  });

  test('Should be valid when value is a valid int', () {
    Score score = Score(0);
    expect(score.isValid, isTrue);
    expect(score.value, 0);
  });

  test('Should be invalid when try set with invalid int', () {
    Score score = Score(2);
    score.setValue(null);
    expect(score.isValid, isFalse);
    expect(score.value, 2);
  });

  test('Should be valid when try set with valid int', () {
    Score score = Score(2);
    score.setValue(5);
    expect(score.isValid, isTrue);
    expect(score.value, 5);
  });
}
