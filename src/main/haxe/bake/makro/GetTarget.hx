package bake.makro;

class GetTarget{
  static public function apply(build:Baking){
    var enm                   = (bake.TargetId:Enum<Dynamic>);
    var types                 = Type.getEnumConstructs(enm);
    var target                = None;
    for(t in types){
      var idx = build.args.index_of(
        (x:String) -> {
          //trace('$t');
          final short = (x == '-$t');
          final long  = (x == '--$t');
          //trace('"$x" == "-${t}" $short "$x" == "--${t}" $long');
          return short || long;
        }
      );
      if(idx!=-1){
        target = Some(t);
        break;
      }
    }
    return target;
  }
}