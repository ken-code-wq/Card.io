import 'package:cards/services/definitions.dart';

// void main() async {
//   // final defs = await definitions();
//   // print(defs);
// }

Future<List> definitions({required String query}) async {
  try {
    List<Map> defs = [];
    List definitions = await getDefinition(term: query);
    for (Map info in definitions) {
      List meanings = info["meanings"];
      for (Map partOfSpeech in meanings) {
        Map result = {'partOfSpeech': partOfSpeech['partOfSpeech']};
        List ds = partOfSpeech['definitions'];
        for (Map definition in ds) {
          Map add = {'definition': definition['definition']};
          result.addAll(add);
          //("done $result");
          //("done $add");
          //({'partOfSpeech': partOfSpeech['partOfSpeech'], 'definition': definition['definition']});
          defs.add({
            'partOfSpeech': partOfSpeech['partOfSpeech'],
            'definition': definition['definition'],
          });
        }
      }
    }
    return defs;
  } catch (e) {
    return [e];
  }
}
