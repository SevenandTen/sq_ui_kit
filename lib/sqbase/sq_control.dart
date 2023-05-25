

class SQControl {
  List<T> fromList<T> (List<dynamic>? list , T Function(dynamic map) callback ) {
    List<T> subList = [];
    if(list != null && list.isNotEmpty) {
      for(var element in list) {
        if(element != null) {
          T t = callback(element);
          subList.add(t);
        }
      }
    }
    return subList;
  }
}
