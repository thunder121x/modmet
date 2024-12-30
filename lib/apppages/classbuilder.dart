import 'homepage.dart';
typedef T Constructor<T>();
final Map<String,Constructor<Object>> _constructors = <String, Constructor<Object>>{};
void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor as Constructor<Object>;
}
class ClassBuilder{
  static void registerClasses(){
    register<Homepage>(() => Homepage());
  }
  static dynamic fromString(String type){
    return _constructors[type]!();
  }
}