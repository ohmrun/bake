package bake;

#if stx_log
using Nano;
using Log;
using Pkg;

class Logging{
  static public function log(wildcard:Wildcard){
    final pkg = __.pkg();
    //trace('$pkg');
    return Log.pkg(pkg);
  }
}
#end