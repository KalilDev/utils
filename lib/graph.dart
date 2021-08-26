import 'maybe.dart';

/// An node in a graph. The edges may be interlinked or not. This interface is
/// used for generalized algorithms which may work for [TreeNode]s or
/// [GraphNode]s.
abstract class Node<T> {
  /// The value this [Node] represents.
  T get value;

  /// The edges of this [Node]. They may be interlinked.
  Iterable<Node<T>> get edges;
}

/// An node in a tree. The edges are NOT interlinked, and two nodes must be
/// connected by exactly ONE edge.
abstract class TreeNode<T> extends Node<T> {
  @override
  Iterable<TreeNode<T>> get edges;
}

/// Map every node in a tree to an new node type. It may be used for
/// converting from one specialized [TreeNode] implementation to another, or for
/// converting each [TreeNode] value from type [T] to type `NewT` for example.
T1 mapTree<T, T1 extends TreeNode<Object>>(
  TreeNode<T> root,
  T1 Function(T value, Iterable<T1> children) createNode,
) {
  final newEdges = root.edges.map((edge) => mapTree(edge, createNode));
  return createNode(root.value, newEdges);
}

/// Visit every node in a tree, call the [fn] for each and collect the results
/// in an [Iterable].
Iterable<T1> walkTree<T, T1>(
  TreeNode<T> root,
  T1 Function(T node, Maybe<T> parent) fn, {
  Maybe<T> parent = const None(),
}) sync* {
  yield fn(root.value, parent);
  for (final edge in root.edges) {
    yield* walkTree<T, T1>(
      edge,
      fn,
      parent: Just<T>(root.value),
    );
  }
}

/// An node in a graph in which the edges may be interlinked or not. This
/// interface is used for algorithms which may work only for [GraphNode]s.
///
/// [edges] is an [Set] because having duplicate edges would break algorithms
/// for [GraphNode]s.
///
/// It has an [addEdge] operation because some algos need them and it is
/// impossible to create an immutable graph with interlinked edges, so this
/// model assumes that every usable graph may be interlinked, and therefore may
/// be mutable.
abstract class GraphNode<T> extends Node<T> {
  @override
  Set<GraphNode<T>> get edges;

  /// Add an new edge to this [GraphNode].
  void addEdge(covariant GraphNode<T> edge);
}

abstract class Graph<T, Node extends GraphNode<T>> {
  /// Get an iterable of every [Node] in the graph. Every node will be emitted
  /// exactly once.
  Iterable<Node> nodes();

  /// Map every node in the graph to an new node type. It may be used for
  /// converting from one specialized [GraphNode] implementation to another, or
  /// for converting each [GraphNode] value from type [T] to type `NewT` for
  /// example.
  Graph<T1, NewNode> map<T1 extends Object, NewNode extends GraphNode<T1>>(
    NewNode Function(T) createNode,
  );
}

NewGraph _createOrGetMappedNode<T, NewGraph extends GraphNode<Object>>(
  GraphNode<T> root,
  NewGraph Function(T) createNode,
  Map<GraphNode<T>, NewGraph> context,
) {
  if (context.containsKey(root)) {
    return context[root]!;
  }
  final newNode = ArgumentError.checkNotNull(createNode(root.value));
  // we need to add the new node before traversing it's edges otherwise we will
  // stack overflow trying to traverse it ethernally on context.putIfAbsent
  context[root] = newNode;

  for (final e in root.edges) {
    final newEdge = _createOrGetMappedNode(e, createNode, context);
    newNode.addEdge(newEdge);
  }
  return newNode;
}

class NodesGraph<T, Node extends GraphNode<T>> extends Graph<T, Node> {
  NodesGraph(this._nodes);
  final List<Node> _nodes;

  @override
  Iterable<Node> nodes() => _nodes;

  @override
  Graph<T1, NewNode> map<T1 extends Object, NewNode extends GraphNode<T1>>(
    NewNode Function(T) createNode,
  ) {
    ArgumentError.checkNotNull(createNode);
    final visited = <Node, NewNode>{};
    final newNodes = _nodes
        .map((node) => _createOrGetMappedNode(node, createNode, visited))
        .toList();
    return NodesGraph<T1, NewNode>(newNodes);
  }
}

class RootGraph<T, Node extends GraphNode<T>> extends Graph<T, Node> {
  RootGraph(this._root);
  final Node _root;

  Iterable<Node> _graphNodes(
    Node root, {
    Set<Node>? visited,
  }) sync* {
    visited ??= {};
    if (!visited.contains(root)) {
      visited.add(root);
      yield root;
      for (final edge in root.edges) {
        yield* _graphNodes(edge as Node, visited: visited);
      }
    }
  }

  @override
  Iterable<Node> nodes() => _graphNodes(_root);

  @override
  Graph<T1, NewNode> map<T1 extends Object, NewNode extends GraphNode<T1>>(
    NewNode Function(T) createNode,
  ) {
    final visited = <Node, NewNode>{};
    final NewNode newRootNode =
        _createOrGetMappedNode(_root!, createNode, visited);
    return RootGraph<T1, NewNode>(newRootNode);
  }
}

/// An enum of ways to convert an parent-child relation on a tree to edges on a
/// graph.
enum TreeToGraphLinkType {
  /// Add an edge on the parent linking to the child
  direct,

  /// Add an edge on the child linking to the parent
  reverse,

  /// Add an edge on the parent linking to the child and an edge on the child
  /// linking to the parent
  interlinked
}
T? nothing<T>([Object? o]) => null;

/// Convert an tree, which may have more than one [TreeNode] representing the
/// same value into an [Graph], which may be interlinked or not.
Graph<T, Node> treeToGraph<T, Node extends GraphNode<T>>(
  TreeNode<T> root,
  Node Function(T value) createNode, {
  TreeToGraphLinkType linkType = TreeToGraphLinkType.direct,
}) {
  final valueNodeMap = <T, Node>{
    root.value: createNode(root.value),
  };
  final it = walkTree<T, void>(root, (value, parent) {
    final currNode = valueNodeMap.putIfAbsent(value, () => createNode(value));
    final parNode = parent.fmap((parentVal) => valueNodeMap.putIfAbsent(
          parentVal,
          () => createNode(parentVal),
        ));
    parNode.visit<void>(
        just: (parent) {
          switch (linkType) {
            case TreeToGraphLinkType.direct:
              parent.addEdge(currNode);
              break;
            case TreeToGraphLinkType.reverse:
              currNode.addEdge(parent);
              break;
            case TreeToGraphLinkType.interlinked:
              parent.addEdge(currNode);
              currNode.addEdge(parent);
              break;
          }
        },
        none: nothing);
  }).iterator;

  while (it.moveNext()) {}

  if (linkType == TreeToGraphLinkType.reverse) {
    return NodesGraph(valueNodeMap.values.toList());
  }
  return RootGraph(valueNodeMap[root.value]!);
}

/// An edge from 2 [GraphNode]s in a graph.
class GraphEdge<Node extends GraphNode<Object>> {
  /// Create an [GraphEdge].
  const GraphEdge(this.from, this.to);

  /// The [Node] this edge originates from.
  final Node from;

  /// The [Node] this edge links to.
  final Node to;

  @override
  int get hashCode {
    var hash = 7;
    hash = 31 * hash + from.hashCode;
    hash = 31 * hash + to.hashCode;
    return hash;
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is GraphEdge<Node>) {
      return from == other.from && to == other.to;
    }
    return false;
  }
}

/// Get an iterable of every [GraphEdge] in a graph. Every edge will be emitted
/// exactly once. If an edge is interlinked, it will be emitted once for the
/// first node linking to the second and once for the second node linking to the
/// first.
Iterable<GraphEdge<Node>> graphEdges<Node extends GraphNode<Object>>(
  Node root, {
  Set<Node>? visited,
}) sync* {
  ArgumentError.checkNotNull(root);
  visited ??= {};
  if (!visited.contains(root)) {
    visited.add(root);
    for (final edge in root.edges) {
      yield GraphEdge<Node>(root, edge as Node);
      yield* graphEdges(edge, visited: visited);
    }
  }
}

/// Converts an tree to an textual representation in a manner similar to the
/// `tree` command.
String treeToString<Node extends TreeNode<Object>>(
  Node root, [
  String Function(Node)? describeNode,
]) {
  ArgumentError.checkNotNull(root);
  final buff = StringBuffer()
    ..writeln(describeNode?.call(root) ?? root.value.toString());

  final children = root.edges.toList();
  for (var i = 0; i < children.length; i++) {
    final child = children[i];
    final childStr = treeToString<Node>(child as Node, describeNode).trim();
    final childLns = childStr.split('\n');
    final isLast = i + 1 == children.length;

    if (isLast) {
      var isFirst = true;
      for (final ln in childLns) {
        buff.writeln('${isFirst ? _lastConnector : _indent}$ln');
        isFirst = false;
      }
    } else {
      var isFirst = true;
      for (final ln in childLns) {
        buff.writeln('${isFirst ? _connector : _continuation}$ln');
        isFirst = false;
      }
    }
  }

  return buff.toString();
}

const _lastConnector = '└── ';
const _connector = '├── ';
const _continuation = '│   ';
const _indent = '    ';
