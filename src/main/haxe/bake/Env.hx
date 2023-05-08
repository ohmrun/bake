package bake;

class Env{
  #if (sys || nodejs)
  public function new(){}
  public function is_windows(){
    var sys_name = std.Sys.systemName();
    return sys_name == "Windows";
  }
  public function home():Option<String>{
    var home = null;
    return is_windows().if_else(
      () -> {
        home = Util.env("USERPROFILE");
        if (!home.is_defined()) {
          var drive = Util.env("HOMEDRIVE");
          var path  = Util.env("HOMEPATH");
          if (!drive.zip_with(path,(l,r) -> {l : l,r : r}).is_defined()){
            home = drive.zip_with(
              path,
              (l,r) -> {
                return Path.join([l,r]);
              }
            );
          }
        }
        home;
      },
      () -> {
        return Util.env("HOME");
      }
    );
  }
  #end
}