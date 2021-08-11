abstract class StatefulValue<S extends Object, V extends Object> {
  S get state;

  V get value;
}

class PredicativeValue<V extends Object> implements StatefulValue<bool, V> {
  const PredicativeValue({
    required this.value,
    this.state = false,
  });

  @override
  final bool state;

  @override
  final V value;

  PredicativeValue<V> copyWith({
    bool? state,
    V? value,
  }) {
    return PredicativeValue<V>(
      state: state ?? this.state,
      value: value ?? this.value,
    );
  }

  @override
  String toString() => 'PredicativeValue(state: $state, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    if (other is V && other == value) return true;

    if (other is PredicativeValue<V> && other.state == state && other.value == value) {
      return true;
    }
    
    return false;
  }

  @override
  int get hashCode => state.hashCode ^ value.hashCode;
}
