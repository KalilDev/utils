import 'package:utils/injector.dart';
import 'package:utils/maybe.dart';
import 'package:utils/curry.dart';
import 'package:meta/meta.dart';

import '../graph.dart';

/// An interface for classes that may transport an [Injector] down an dependency
/// tree automatically.
///
/// # Must not be implemented by outside packages.
/// This interface is exposed because it can be used by external libraries on
/// [InjectorScopeBuilder.addBoundFactory].
abstract class IScopeProxy implements IDebugAnScope {
  /// Does the necessary validation and set the [InjectorScope] for use in
  /// [this] object subtree.
  @mustCallSuper
  void _setScope(InjectorScopeImpl scope);

  bool _didInject(InjectorScopeImpl scope);
}

/// An mixin for values that are injected and may have [Consumer] or other
/// [InjectableProxy] children which are not injected directly.
///
/// For example, an repository collection which contains many [Consumer]
/// repositories, but does not depend directly on anything.
mixin InjectableProxy implements IAmAnDependencyTreeNode, IScopeProxy {
  @override
  List<DependencyTreeNode> childNodes() =>
      children.map((c) => DependencyTreeNode(c)).toList();

  /// The children which will have the injector automatically added if needed.
  /// In case they aren't an [IScopeProxy], they will just show up in the
  /// dependency tree.
  List<Object> get children;

  InjectorScopeImpl _scope;

  @override
  void _setScope(InjectorScopeImpl scope) {
    if (_scope == null) {
      _scope = scope;
      children
          .whereType<IScopeProxy>()
          .forEach(_propagateScopeToProxy.curry(scope));
      return;
    }
    if (!_didInject(scope)) {
      throw StateError('The scope is not the same');
    }
  }

  @override
  bool _didInject(InjectorScopeImpl scope) =>
      _scope == scope ||
      (this is ICreateAnScope && _scope.just == scope._parent);

  @override
  void debugOverrideScope(
    InjectorScope newScope, {
    ScopeOverridingMode mode = ScopeOverridingMode.replace,
  }) {
    final newImpl = newScope as InjectorScopeImpl;
    _scope = _overrideScopeForDebug(
      _scope,
      newImpl,
      mode: mode,
    );
  }
}

/// An mixin for values that can be accessed only via Dependency Injection with
/// [Injector] and have other dependencies.
///
/// It gets the correct [InjectorScope] automatically when being injected, and
/// takes care of passing it down automatically to it's dependencies if needed.
mixin Consumer implements IInjectDependencies, IScopeProxy {
  InjectorScopeImpl _scope;

  @override
  List<DependencyTreeNode> childNodes() => dependencies
      .map((t) => DependencyTreeNode(getUntyped(t), t.just))
      .toList();

  void _validate(Type t) {
    if (_scope == null) {
      throw StateError(
          'Accessing the injector is only valid after [this] being injected!\n'
          'If you want to perform some operation which does need');
    }
    if (!dependencies.contains(t)) {
      throw StateError(
          'Every dependency must be added to dependencies, but $t was not.');
    }
  }

  @override
  T get<T>() {
    _validate(T);
    return _scope.get<T>();
  }

  @override
  Object getUntyped(Type t) {
    _validate(t);
    return _scope.getUntyped(t);
  }

  @override
  List<Object> getAll() => dependencies.map(getUntyped).toList();

  @override
  void _setScope(InjectorScopeImpl scope) {
    if (_scope == null) {
      scope.checkContainsAll(dependencies);
      _scope = scope;
      return;
    }

    if (_didInject(scope)) {
      _scope.checkContainsAll(dependencies);
      return;
    }
    throw StateError('The scope is not valid!');
  }

  @override
  bool _didInject(InjectorScopeImpl scope) =>
      _scope == scope ||
      (this is ICreateAnScope && _scope.just == scope._parent);

  @override
  void debugOverrideScope(
    InjectorScope newScope, {
    ScopeOverridingMode mode = ScopeOverridingMode.replace,
  }) {
    final newImpl = newScope as InjectorScopeImpl;
    _scope = _overrideScopeForDebug(
      _scope,
      newImpl,
      mode: mode,
    );
  }
}

/// An mixin for values that can be accessed without Dependency Injection, but
/// need to use Dependencies from an [Injector]. Use it with the [Injector.root]
/// scope.
///
/// The [InjectorScope] is passed down automatically to it's dependencies if
/// needed.
mixin DetachedConsumer implements IInjectDependencies, IDebugAnScope {
  @override
  void debugOverrideScope(
    InjectorScope newScope, {
    ScopeOverridingMode mode = ScopeOverridingMode.replace,
  }) {
    final newImpl = newScope as InjectorScopeImpl;
    final currImpl = _scope ?? (scope as InjectorScopeImpl);
    _scope = _overrideScopeForDebug(
      currImpl,
      newImpl,
      mode: mode,
    );
    _ready = true;
  }

  /// The base scope that will be used to get the [dependencies]. If [this] is
  /// an [ICreateAnScope], it will be used as the parent scope for the new
  /// created scope.
  InjectorScope get scope;

  InjectorScopeImpl _scope;

  @override
  List<DependencyTreeNode> childNodes() => dependencies
      .map((t) => DependencyTreeNode(getUntyped(t), t.just))
      .toList();

  bool _ready = false;

  void _check(Type t) {
    _initScope();
    if (!dependencies.contains(t)) {
      throw StateError('Every dependency must be added to '
          'the dependencies in order to be used, but $t was not.');
    }
  }

  /// Build the Scope tree from the current [scope].
  ScopeTreeNode scopeTree() => ScopeTreeNode(scope);

  /// Dump the [String] representation of the [scopeTree] to the console
  /// output.
  ///
  /// This is not meant to be used in production, but instead on the
  /// Debug Console evaluator.
  void dumpScopeTree() =>
      // ignore: avoid_print
      print(treeToString<ScopeTreeNode>(scopeTree(), (n) => n.description));

  /// Build the Dependency tree from [this].
  DependencyTreeNode toDependencyTree() => DependencyTreeNode(this);
  @Deprecated('Use toDependencyTree')
  DependencyTreeNode dependencyTree() => toDependencyTree();

  /// Dump the [String] representation of the [toDependencyTree] to the console
  /// output.
  ///
  /// This is not meant to be used in production, but instead on the
  /// Debug Console evaluator.
  void dumpDependencyTree() =>
      // ignore: avoid_print
      print(treeToString(toDependencyTree()));

  @override
  T get<T>() {
    _check(T);
    return _scope.get<T>();
  }

  @override
  Object getUntyped(Type t) {
    _check(t);
    return _scope.getUntyped(t);
  }

  @override
  List<Object> getAll() {
    _initScope();
    return dependencies.map(_scope.getUntyped).toList();
  }

  void _initScope() {
    if (_ready) {
      return;
    }
    if (this.scope == null) {
      throw StateError('The base scope must not be null');
    }
    final scope = _getOrCreateScopeFor(this, this.scope as InjectorScopeImpl);
    scope.checkContainsAll(dependencies);
    _scope = scope;
    _ready = true;
  }
}

/// An specialized [TreeNode] for working with an [InjectorScope] tree.
class ScopeTreeNode extends TreeNode<InjectorScope> {
  /// Create an [ScopeTreeNode].
  ScopeTreeNode(this.value);

  @override
  final InjectorScope value;

  @override
  Iterable<ScopeTreeNode> get edges => (value as InjectorScopeImpl)
      ._children
      .map((scope) => ScopeTreeNode(scope));

  /// An informative text about this scope, containing the debugLabel and the
  /// types being injected at this level.
  String get description {
    final s = value as InjectorScopeImpl;
    final types = s._thisScopeInjectableTypes;
    final pfx = 'InjectorScope#${s.debugLabel}\n -';
    return pfx + types.join('\n -');
  }
}

// Implementation details

/// The actual implementation for the [Injector] type
class InjectorImpl implements Injector {
  factory InjectorImpl(void Function(InjectorScopeBuilderImpl) updates) =>
      InjectorImpl._(InjectorScopeImpl(
        (b) => b
          ..addDebugLabel('root')
          ..applyUpdates(updates as void Function(InjectorScopeBuilder)),
        const None(),
      ));
  factory InjectorImpl.debug(InjectorScope root) => InjectorImpl._(root);
  const InjectorImpl._(this.root);

  @override
  final InjectorScope root;
}

/// The actual implementation for the [InjectorScope] type
class InjectorScopeImpl implements InjectorScope {
  /// Create an [InjectorScopeImpl] from the changes on a builder, and a parent.
  ///
  /// # It should NOT be used outside of the internal implementation!
  factory InjectorScopeImpl(
    void Function(InjectorScopeBuilder) updates,
    Maybe<InjectorScope> parentScope,
  ) =>
      (InjectorScopeBuilderImpl()..applyUpdates(updates)).build(parentScope)
          as InjectorScopeImpl;

  /// Create an [InjectorScope] which contains the specified [injectedValues]
  /// and an optional parent [InjectorScope]. This will propagate the current
  /// scope to the proxies, so you need to override them AFTER creating the
  /// scope.
  InjectorScopeImpl.debug(
    Map<Type, Object> injectedValues, [
    this._parent = const None(),
  ])  : _injectableTypes = const {},
        _debugLabel = 'debug' {
    _injectedValues.addAll(injectedValues);
    injectedValues.values
        .whereType<IScopeProxy>()
        .forEach(_propagateScopeToProxy.curry(this));
  }

  InjectorScopeImpl._(
    this._injectableTypes,
    this._parent,
    this._debugLabel,
  );

  final Map<Type, _Injectable> _injectableTypes;
  final Map<Type, Object> _injectedValues = {};
  final Set<InjectorScopeImpl> _children = {};
  final String _debugLabel;

  /// Not final so that [IDebugAnScope] can override the parent of an child
  /// node.
  Maybe<InjectorScopeImpl> _parent;

  @override
  T get<T>() => getUntyped(T) as T;

  @override
  Object getUntyped(Type t) {
    if (_injectedValues.containsKey(t)) {
      return _injectedValues[t];
    }
    if (_injectableTypes.containsKey(t)) {
      final injectable = _injectableTypes.remove(t);
      return _injectedValues[t] = injectable.getOrCreate(this);
    }
    return _parent.visit(
        just: (parent) => parent.getUntyped(t),
        none: () => throw StateError(
              'The type $t is not injectable by this injector',
            ));
  }

  @override
  List<Object> getAllInjected() => [
        ..._injectedValues.values,
        ..._parent.fmap((parent) => parent.getAllInjected()).valueOr([])
      ];

  bool _contains(Type t) {
    if (_injectedValues.containsKey(t) || _injectableTypes.containsKey(t)) {
      return true;
    }
    return _parent.visit(
      just: (parent) => parent._contains(t),
      none: () => false,
    );
  }

  @override
  void checkContains(Type type) {
    if (!_contains(type)) {
      throw StateError('Injector does not contain $type');
    }
  }

  @override
  void checkContainsAll(List<Type> types) => types.forEach(checkContains);

  @override
  List<Type> injectableTypes() => [
        ..._thisScopeInjectableTypes,
        ..._parent.fmap((parent) => parent.injectableTypes()).valueOr(<Type>[])
      ];
  List<Type> get _thisScopeInjectableTypes => [
        ..._injectedValues.keys,
        ..._injectableTypes.keys,
      ];

  @override
  String get debugLabel => _debugLabel ?? hashCode.toRadixString(16);

  @override
  Iterable<InjectorScopeImpl> get children => _children;
}

/// Internal impl for an value can be injected but not used before, so it can
/// be lazily initialized.
abstract class _Injectable<T> {
  const _Injectable();

  T setScopeAndValidate(InjectorScopeImpl scope, T value) {
    if (value is DetachedConsumer) {
      throw StateError(
          'An Consumer may NOT be injected! Use an proxy value instead');
    }
    if (value is IScopeProxy) {
      _propagateScopeToProxy(scope, value);
    }
    return value;
  }

  T getOrCreate(InjectorScopeImpl scope);
}

class _ValueInjectable<T> extends _Injectable<T> {
  const _ValueInjectable(this._value);
  final T _value;

  @override
  T getOrCreate(InjectorScopeImpl scope) => setScopeAndValidate(scope, _value);
}

class _FactoryInjectable<T> extends _Injectable<T> {
  const _FactoryInjectable(this._factory);
  final T Function() _factory;

  @override
  T getOrCreate(InjectorScopeImpl scope) {
    T v;
    try {
      v = _factory();
    } catch (e) {
      throw StateError('Factories should not throw!');
    }
    return setScopeAndValidate(scope, v);
  }
}

class _BoundFactoryInjectable<T> extends _Injectable<T> {
  const _BoundFactoryInjectable(this._boundFactory);
  final T Function(T Function(IScopeProxy)) _boundFactory;

  T _bind(InjectorScopeImpl scope, IScopeProxy v) =>
      setScopeAndValidate(scope, v as T);

  @override
  T getOrCreate(InjectorScopeImpl scope) {
    T v;
    try {
      v = _boundFactory(_bind.curry(scope));
    } catch (e) {
      throw StateError('Factories should not throw!');
    }

    if (v is! IScopeProxy) {
      throw StateError('boundFactory should only be used for proxy values!');
    }
    final val = v as IScopeProxy;
    if (!val._didInject(scope)) {
      throw StateError('You must call bind on addBoundFactory! '
          'If you do not need the bind functionality, use addFactory');
    }
    return v;
  }
}

class _InjectedFactoryInjectable<T> extends _Injectable<T> {
  const _InjectedFactoryInjectable(this._injectedFactory);
  final T Function(InjectorScope) _injectedFactory;

  @override
  T getOrCreate(InjectorScopeImpl scope) {
    T v;
    try {
      v = _injectedFactory(scope);
    } catch (e) {
      throw StateError('Factories should not throw!');
    }

    if (v is IScopeProxy) {
      throw StateError('injectedFactory should not be used '
          'for proxies! Use factory or boundFactory');
    }

    /// this will only validate
    return setScopeAndValidate(scope, v);
  }
}

/// The actual implementation for the [InjectorScopeBuilder] type
class InjectorScopeBuilderImpl implements InjectorScopeBuilder {
  final Map<Type, _Injectable> _injectableTypes = {};
  String _debugLabel;

  void _checkType<T>() {
    final duplicates =
        _injectableTypes.keys.where((type) => type == T || T == type);
    if (duplicates.isNotEmpty) {
      throw StateError('Type $T is already being injected with the '
          'runtimeTypes $duplicates');
    }
  }

  @override
  void addValue<T>(T value) {
    _checkType<T>();
    _injectableTypes[T] = _ValueInjectable<T>(value);
  }

  @override
  void addFactory<T>(T Function() factory) {
    _checkType<T>();
    _injectableTypes[T] = _FactoryInjectable<T>(factory);
  }

  @override
  void addBoundFactory<T>(
      T Function(T Function(IScopeProxy) bind) boundFactory) {
    _checkType<T>();
    _injectableTypes[T] = _BoundFactoryInjectable<T>(boundFactory);
  }

  @override
  void addInjectedFactory<T>(T Function(InjectorScope) injectedFactory) {
    _checkType<T>();
    _injectableTypes[T] = _InjectedFactoryInjectable<T>(injectedFactory);
  }

  @override
  InjectorScope build([Maybe<InjectorScope> parent = const None()]) =>
      InjectorScopeImpl._(_injectableTypes, parent.cast(), _debugLabel);

  @override
  void addDebugLabel(String label) => _debugLabel = label;

  @override
  void applyUpdates(void Function(InjectorScopeBuilder) updates) =>
      updates(this);
}

void _propagateScopeToProxy(
  InjectorScopeImpl parentScope,
  IScopeProxy proxy,
) {
  proxy._setScope(_getOrCreateScopeFor(proxy, parentScope));
}

/// Used before calling [IScopeProxy._setScope], so that the scope that gets set
/// is correct, that is, it is the [parentScope] normally, and a new scope if
/// the object is an [ICreateAnScope].
InjectorScopeImpl _getOrCreateScopeFor(
  Object maybeCreatesScope,
  InjectorScopeImpl parentScope,
) {
  if (maybeCreatesScope is ICreateAnScope) {
    final newScope = InjectorScopeImpl(
        (b) => b
          ..addDebugLabel(maybeCreatesScope.runtimeType.toString())
          ..applyUpdates(maybeCreatesScope.createScope),
        parentScope.just);
    parentScope._children.add(newScope);
    return newScope;
  }
  return parentScope;
}

/// Perform the changes required by the [mode] in the [oldScope] and the
/// [newScope] so that the new one can be used as a replacement in
/// [IDebugAnScope.debugOverrideScope].
InjectorScopeImpl _overrideScopeForDebug(
  InjectorScopeImpl oldScope,
  InjectorScopeImpl newScope, {
  ScopeOverridingMode mode,
}) {
  // Move the children from the oldScope to the newScope
  newScope._children //
      .addAll(oldScope._children
        ..forEach(
          (subscope) => subscope._parent = newScope.just,
        ));

  switch (mode) {
    case ScopeOverridingMode.placeBelow:
      // Make the newScope a child of the oldScope
      oldScope._children.add(newScope);
      newScope._parent = oldScope.just;
      return newScope;
    case ScopeOverridingMode.replace:
      // Remove the oldScope from the parent and add the newScope to the
      // children
      oldScope._parent.visit(
        just: (parent) {
          parent._children
            ..remove(oldScope)
            ..add(newScope);
        },
        none: unreachable,
      );
      newScope._parent = oldScope._parent;
      return newScope;
    case ScopeOverridingMode.detach:
      // Remove the oldScope from the parent
      oldScope._parent.visit(
        just: (p) => p._children.remove(oldScope),
        none: unreachable,
      );
      return newScope;
    default:
      throw StateError('Unknown mode: $mode');
  }
}
