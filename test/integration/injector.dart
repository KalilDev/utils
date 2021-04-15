import 'package:utils/injector.dart';
import 'package:utils/src/injector.dart';
import 'package:utils/graph.dart';

class AnInjectedEndpoint implements IEndpoint {
  @override
  String get endpoint => _kEndpoint;

  static const _kEndpoint = 'example.com';
}

class AnInjectedClient implements IClient {
  @override
  Future<String> get(String url) async {
    if (url == AnInjectedEndpoint._kEndpoint) {
      return 'contents';
    }
    throw Exception('Unexpected endpoint!');
  }
}

class AnInjectableRepository
    with Consumer
    implements IRepository, ICreateAnScope {
  @override
  List<Type> get dependencies => [IEndpoint, IClient];

  @override
  void createScope(InjectorScopeBuilder builder) =>
      builder.addValue<IEndpoint>(AnInjectedEndpoint());

  IEndpoint get _endpoint => get();
  IClient get _client => get();

  @override
  Future<String> download() => _client.get(_endpoint.endpoint);
}

class AnInjectableService with Consumer implements IService {
  @override
  List<Type> get dependencies => [IRepository];

  IRepository get _repository => get();

  String cache;

  @override
  Future<String> cachedDownload() async {
    if (cache != null) {
      return cache;
    }
    return cache = await _repository.download();
  }

  @override
  void clearCache() => cache = null;
}

class ServiceConsumer with DetachedConsumer {
  ServiceConsumer(this.scope);

  @override
  final InjectorScope scope;

  IService get _service => get();

  Future<void> printTwice() async {
    print(await _service.cachedDownload());
    print(await _service.cachedDownload());
  }

  @override
  List<Type> get dependencies => [IService];
}

abstract class IEndpoint {
  String get endpoint;
}

abstract class IClient {
  Future<String> get(String url);
}

abstract class IRepository {
  Future<String> download();
}

abstract class IService {
  Future<String> cachedDownload();
  void clearCache();
}

void main() async {
  final i = Injector((b) => b
    ..addValue<IClient>(AnInjectedClient())
    ..addValue<IRepository>(AnInjectableRepository())
    ..addValue<IService>(AnInjectableService()));
  final consumer = ServiceConsumer(i.root);
  await consumer.printTwice();
  print(treeToString(DependencyTreeNode(consumer)));
  print(treeToString(
    ScopeTreeNode(i.root),
    (scope) => (scope as ScopeTreeNode).description,
  ));
  final scoped = i.root.get<IRepository>() as IDebugAnScope;
  scoped.debugOverrideScope(
    InjectorScope.debug({IEndpoint: OverridenEndpoint()}),
    mode: ScopeOverridingMode.replace,
  );
  await consumer.printTwice();
  i.root.get<IService>().clearCache();

  try {
    await consumer.printTwice();
    throw StateError('printTwice shouldve thrown!');
  } on Exception catch (e) {
    if (!e.toString().contains('endpoint')) {
      throw StateError('Unexpected exception $e');
    }
  }
  print(treeToString(DependencyTreeNode(consumer)));
  print(treeToString(
    ScopeTreeNode(i.root),
    (scope) => (scope as ScopeTreeNode).description,
  ));
}

class OverridenEndpoint extends IEndpoint {
  @override
  String get endpoint => 'NotTheEndpoint';
}
