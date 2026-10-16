/// Serialize and deserialize common Flutter UI data classes to and from JSON.
///
/// Serialization is done with `toJson()` extension methods, for example
/// `color.toJson()`, deserialization with `parseXxx()` functions, for example
/// `parseColor(json)`.
library;

export 'src/parse_json.dart';
export 'src/to_json.dart';
