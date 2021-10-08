package stx.bake.makro;

class GetTarget{
  static public function apply(build:Baking){
    var enm                   = new Enum(stx.nano.CompilerTarget.CompilerTargetSum);
    var types                 = enm.constructs().map(Right).map(enm.construct.bind(_,[]));
    var exprs                 = types.map(
      _ -> _.map(CompilerTarget._.toBuildDirective.fn().broach())
    );
    var target                = None;
    for(expr in exprs){
      for(opt in expr){
        for(str in opt.snd()){
          var idx = build.args.index_of((x) -> x == str);
          if(idx!=-1){
            target = Some(opt.fst());
            break;
          }
        }
      }
    }
    return target;
  }
}