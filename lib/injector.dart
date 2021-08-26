import 'package:meta/meta.dart';
import 'package:utils/utils.dart';

import 'graph.dart';
import 'maybe.dart';
import 'src/injector.dart';

export 'src/injector.dart'
    hide InjectorImpl, InjectorScopeImpl, InjectorScopeBuilderImpl;

/// An class used to access instances of an specified type without knowing the
/// concrete type or value.
///
/// Only one should exist per scope, and if more than one is being used in the
/// program, they should NOT mix [InjectableConsumer]s. Doing so is an [Error]!
abstract class Injector {
  /// Create an [Injector] from the changes on a [InjectorScopeBuilder]
  factory Injector(void Function(InjectorScopeBuilder) updates) = InjectorImpl;

  /// Create an [Injector] from an root [InjectorScope]. It must not be used
  /// normally. Useful for debugging purposes.
  factory Injector.debug(InjectorScope root) = InjectorImpl.debug;

  /// The root scope for this [Injector]
  InjectorScope get root;
}

/// An class used to access instances of an specified type without knowing the
/// concrete type or value.
///
/// Only one should exist per scope, and if more than one is being used in the
/// program, they should NOT mix [InjectableConsumer]s. Doing so is an [Error]!
abstract class InjectorScope {
  /// Create an [InjectorScope] which contains the specified [injectedValues]
  factory InjectorScope.debug(Map<Type, dynamic> injectedValues) =
      InjectorScopeImpl.debug;

  /// Get the injected instance of type [T]
  T/*!*/ get<T>();

  /// Get the instance of type [t], without any static type safety.
  dynamic getUntyped(Type t);

  /// Returns every value that was injected at least once. Useful for disposal
  /// of objects.
  List<dynamic> getAllInjected();

  /// Assert that this [InjectorScope] or one of it's parents can inject [type].
  void checkContains(Type type);

  /// Assert that this [InjectorScope] can inject every [Type] in [types].
  void checkContainsAll(List<Type> types);

  /// The [Type]s that this [InjectorScope] can inject.
  List<Type> injectableTypes();

  /// The [debugLabel] for this scope. The root is labeled `root` and other
  /// scopes are labelled with the [hashCode] if no label was specified on the
  /// [InjectorScopeBuilder].
  String get debugLabel;

  /// The child [InjectorScope]s
  Iterable<InjectorScope> get children;
}

/// An object which can create an [InjectorScope] after adding the needed types.
abstract class InjectorScopeBuilder {
  factory InjectorScopeBuilder() = InjectorScopeBuilderImpl;

  /// Bind the [value] to be injected to the type [T] on the [InjectorScope].
  void addValue<T>(T value);

  /// Bind the [factory] to be injected to the type [T] on the [InjectorScope].
  void addFactory<T>(T Function() factory);

  /// Bind the [boundFactory] to be injected to the type [T] on the
  /// [InjectorScope].
  ///
  /// This is used in cases where the factory needs to call something inside the
  /// [T] which will need to use injected values.
  ///
  /// example```
  /// if.addBoundFactory<IInitableValue>((bind)
  ///     => bind(InitableValueWithDeps())..init());
  /// ```
  void addBoundFactory<T>(
      T Function(T Function(IScopeProxy) bind) boundFactory);

  /// Bind the [injectedFactory] to be injected to the type [T] on the
  /// [Injector] and which needs the [InjectorScope] to build the value. Eg, an
  /// [Consumer].
  ///
  /// This should not be used in most cases, as there is an cleaner way to do it
  /// with [IInjectorProxy], but there are cases in which this is not
  /// possible.
  void addInjectedFactory<T>(T Function(InjectorScope) injectedFactory);

  /// Add an debug label to the scope. It is optional.
  void addDebugLabel(String label);

  /// Apply many updates to this [InjectorScopeBuilder]
  void applyUpdates(void Function(InjectorScopeBuilder) updates);

  /// Create the [InjectorScope] with the values and factories specified in
  /// [this].
  InjectorScope build([Maybe<InjectorScope> parent = const None()]);
}

/// An interface for classes that can use an [Injector] to use injected
/// dependencies.
abstract class IInjectDependencies implements IAmAnDependencyTreeNode {
  /// The [Type]s which will be made available to [this] by the [Injector].
  List<Type> get dependencies;

  /// Get an [T] dependency from the [Injector].
  T/*!*/ get<T>();

  /// Get an untyped [t] dependency from the [Injector].
  dynamic getUntyped(Type t);

  /// Get the injected value of every dependency in [dependencies] from the
  /// [Injector].
  List<dynamic> getAll();
}

/// An interface for classes that can create an scope for themselves.
///
/// # Careful!
/// Classes that implement this interface must mix in [Consumer],
/// [DetachedConsumer] or [InjectableProxy].
///
/// Otherwise the new scope would not be passable to a subtree.
///
/// Unfortunately there is no way to express this constraint with dart's
/// typesystem. Be extra careful!
abstract class ICreateAnScope {
  /// The updates to the builder needed to create the wanted scope.
  void createScope(InjectorScopeBuilder builder);
}

/// An interface for objects that can have their [InjectorScope] overriden for
/// debug purposes.
///
/// # Do not implement this class.
/// It is only meant to expose this common interface on [Consumer],
/// [DetachedConsumer] and [InjectableProxy].
abstract class IDebugAnScope {
  @visibleForTesting

  /// Overide the current [InjectorScope] with an [newScope] in the desired
  /// [mode] for debuggind or testing purposes.
  void debugOverrideScope(
    InjectorScope newScope, {
    ScopeOverridingMode mode = ScopeOverridingMode.replace,
  });
}

/// How the old [InjectorScope] will be overriden with an new scope in
/// [IDebugAnScope.debugOverrideScope].
enum ScopeOverridingMode {
  /// Place the new scope below the old one in the tree, so that it can access
  /// objects injected by either the old scope or it's parents.
  placeBelow,

  /// Replace the old scope with the new one in the same place of the tree, so
  /// that it can access the objects from the old scope's parents.
  replace,

  /// Remove the old scope from the tree and place the new scope on the root of
  /// the tree.
  detach,
}

/// An interface for classes that can display child [DependencyTreeNode]s on the
/// dependency tree.
abstract class IAmAnDependencyTreeNode {
  /// Get the list of child nodes in an Dependency Tree
  List<DependencyTreeNode> childNodes();
}

enum ValueKind {
  /// An node which is an [IInjectDependencies]
  node,

  /// An node which is an [IInjectorProxy] but is not an [IInjectDependencies].
  proxyLeaf,

  /// An node which is an [IInjectorProxy] and is an [IInjectDependencies].
  proxyNode,

  /// An node which regular [Object] with no children (is not an
  /// [IInjectDependencies]).
  leaf,
}

Never unreachable([Object _]) => throw StateError('Unreachable!');

/// An value representing the type of an value which is injectable, and it's
/// injected, concrete form.
class Dependency {
  /// Create an [Dependency].
  const Dependency(
    this.type,
    this.dep, {
    this.valueKind = ValueKind.node,
  });

  /// The [Type] that was registered in the [Injector]. It is [None] if the type
  /// was not injected. An [Consumer] for example.
  final Maybe<Type> type;

  /// The injected/regular value.
  final Object dep;

  /// The kind of this value
  final ValueKind valueKind;

  String _decorated(String s) {
    switch (valueKind) {
      case ValueKind.leaf:
        return '($s)';
      case ValueKind.node:
        return '[$s]';
      case ValueKind.proxyNode:
        return '|$s|';
      case ValueKind.proxyLeaf:
        return '{$s}';
      default:
        return unreachable();
    }
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Dependency) {
      return type == other.type &&
          dep == other.dep &&
          valueKind == other.valueKind;
    }
    return false;
  }

  @override
  int get hashCode {
    var hash = 7;
    hash = hash * 31 + type.hashCode;
    hash = hash * 31 + dep.hashCode;
    hash = hash * 31 + valueKind.hashCode;
    return hash;
  }

  @override
  String toString() => type.visit(
        just: (t) => '${_decorated(dep.runtimeType.toString())} <- $t',
        none: () => _decorated(dep.runtimeType.toString()),
      );
}

/// An [GraphNode] for an dependency graph constructed from an
/// [DependencyTreeNode].
class DependencyGraphNode extends GraphNode<Dependency> {
  /// Create an [DependencyGraphNode] with an [Dependency] value.
  DependencyGraphNode(this.value);
  final _edges = <DependencyGraphNode/*!*/>{};

  @override
  void addEdge(DependencyGraphNode/*!*/ edge) => _edges.add(edge);

  @override
  Set<DependencyGraphNode/*!*/> get edges => _edges;

  @override
  final Dependency value;
}

/// An [TreeNode] for an dependency tree constructed from an [Consumer] or an
/// [InjectableConsumer].
class DependencyTreeNode extends TreeNode<Dependency> {
  /// Construct the tree from the [self] root. This may not be cheap, use
  /// carefully.
  DependencyTreeNode(this.self, [this.type = const None()]) {
    ArgumentError.checkNotNull(self);
    if (self is IAmAnDependencyTreeNode) {
      final s = self as IAmAnDependencyTreeNode;
      _children.addAll(s.childNodes());
    }
  }

  /// The value which was injected or the root of this dependency tree. If
  /// [self] has dependencies, they will be added to the tree.
  final Object self;

  /// The [Type] which was retrieved from the [Injector] resulting in [self].
  /// It is [None] at the root.
  final Maybe<Type> type;

  /// Convert this dependency tree to an dependency graph.
  Graph<Dependency, DependencyGraphNode/*!*/> toGraph({
    TreeToGraphLinkType linkType = TreeToGraphLinkType.direct,
  }) =>
      treeToGraph(
        this,
        (dep) => DependencyGraphNode(dep),
        linkType: linkType,
      );

  final List<DependencyTreeNode> _children = [];

  @override
  List<DependencyTreeNode> get edges => _children;

  @override
  Dependency get value {
    ValueKind/*?*/ kind;
    if (self is Consumer) {
      kind ??= ValueKind.proxyNode;
    }
    if (self is InjectableProxy) {
      kind ??= ValueKind.proxyLeaf;
    }
    if (self is DetachedConsumer) {
      kind ??= ValueKind.node;
    }
    return Dependency(
      type,
      self,
      valueKind: kind ?? ValueKind.leaf,
    );
  }
}
