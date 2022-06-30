

class Resource<T>{
  Resource._();
  factory Resource.success(T data)=>ResourceSuccess<T>(data);
  factory Resource.error(String error)=>ResourceError<T>(error);

}

class ResourceSuccess<T> extends Resource<T>{
  final T data;
  ResourceSuccess(this.data) : super._();
}

class ResourceError<T> extends Resource<T>{
  final String error;
  ResourceError(this.error):super._();
}