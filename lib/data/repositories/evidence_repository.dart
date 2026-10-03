import '../models/evidence.dart';

class EvidenceRepository {
  EvidenceRepository._();

  static final EvidenceRepository instance = EvidenceRepository._();

  final List<Evidence> _evidence = [];

  List<Evidence> get all => List.unmodifiable(_evidence.reversed.toList());

  Evidence? get latest => _evidence.isEmpty ? null : _evidence.last;

  void save(Evidence evidence) {
    _evidence.removeWhere((item) => item.id == evidence.id);

    _evidence.add(evidence);
  }

  void delete(String id) {
    _evidence.removeWhere((item) => item.id == id);
  }

  Evidence? findById(String id) {
    for (final evidence in _evidence) {
      if (evidence.id == id) {
        return evidence;
      }
    }

    return null;
  }

  void clear() {
    _evidence.clear();
  }
}
