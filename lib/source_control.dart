

class SourceControl {
  ///是否为主工程启动
  static const flag = true ;

  ///获取资源文件地址
  static String getPath(String relativePath) {
    return SourceControl.flag ? "packages/squikit/$relativePath":relativePath ;
  }
}