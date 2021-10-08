package stx.bake;

using stx.Sys;

class Env extends Clazz{
  public function is_windows(){
    var sys_name = std.Sys.systemName();
    return sys_name == "Windows";
  }
  public function home():Option<String>{
    var home = null;
    return is_windows().if_else(
      () -> {
        home = __.sys().env("USERPROFILE");
        if (!home.is_defined()) {
          var drive = __.sys().env("HOMEDRIVE");
          var path  = __.sys().env("HOMEPATH");
          if (!drive.zip(path).is_defined()){
            home = drive.zip(path).map(__.decouple((a:String,b:String) -> a + b));
          }
        }
        home;
      },
      () -> {
        __.sys().env("HOME");
      }
    );
  }
}