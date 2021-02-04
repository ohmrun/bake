package stx.bake;

class Env extends Clazz{
  public function is_windows(){
    var sys_name = Sys.systemName();
    return sys_name == "Windows";
  }
  public function home():Option<String>{
    var home = null;
    return is_windows().if_else(
      () -> {
        home = Sys.getEnv("USERPROFILE");
        if (home == null) {
          var drive = Sys.getEnv("HOMEDRIVE");
          var path  = Sys.getEnv("HOMEPATH");
          if (drive != null && path != null){
            home = drive + path;
          }
        }
        __.option(home);
      },
      () -> {
        __.option(Sys.getEnv("HOME"));
      }
    );
  }
}