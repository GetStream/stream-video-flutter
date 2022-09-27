// set sensible defaults to avoid polluting the grammar with boring details
import 'grammar.dart';

Grammar processGrammar(Grammar grammar) {
  grammar.keys.forEach((key) {
    var objs = grammar[key];
    objs!.forEach((obj) {
      if (obj["reg"] == null) {
        obj["reg"] = "/(.*)/";
      }
      if (obj["format"] == null) {
        obj["format"] = '%s';
      }
    });
  });
  return grammar;
}
