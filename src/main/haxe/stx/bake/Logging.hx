package stx.bake;

using stx.Nano;
using stx.Log;
using stx.Pkg;

class Logging{
  static public function log(wildcard:Wildcard){
    final pkg = __.pkg();
    //trace('$pkg');
    return stx.Log.pkg(pkg);
  }
}