package bake.makro;

class GetTarget{
  static public function apply(build:Baking){
    var enm                   = (bake.TargetId:Enum<Dynamic>);
    var types                 = Type.getEnumConstructs(enm);
    var target                = None;
    for(t in types){
      var idx = build.args.index_of(
        (x) -> (x == '-$t') || (x == '--$t')
      );
      if(idx!=-1){
        target = Some(t);
        break;
      }
    }
    return target;
  }
}