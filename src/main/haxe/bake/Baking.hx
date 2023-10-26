package bake;

using StringTools;

import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.MacroStringTools;

//import nano.CompilerTarget.CompilerTargetSum;

import bake.makro.*;

/**
  @google "Type not found : build.Baked"
  `Bake.pop()` returns `Baking.instance` at macro-time and `build.Baked` at compile time.
  If your program is looking for `Baked`, there was a compiler error.
**/ 
@:using(bake.Baking.BakingLift)
@:keep
class Baking{ 
  @:allow(Bake) static private var instance(default,null) : bake.Baking; 

  public var is_runtime(get,null):Bool;
  function get_is_runtime(){
    return bake.Baking.instance == null;
  }
  public var root(default,null):haxe.io.Path;
  public var classpaths(default,null):Array<String>;
  public var args(default,null):Array<String>;
  public var id(default,null):String;
  public var defines(default,null):Array<bake.Field<String>>;
  public var timestamp(default,null):String;

  public function new(root,classpaths,args,defines:Array<bake.Field<String>>,timestamp){
    this.root       = root;
    this.classpaths = classpaths;
    this.args       = args;
    this.id         = haxe.Resource.getString("bake.session.id");//sneaking this around via haxe.Resource in a macro.
    this.defines    = defines;
    this.timestamp  = timestamp;
  }
  public var target(get,null) : Option<String>;
  private function get_target(){
    trace("sd");
    return GetTarget.apply(this);
  }

  public function toString(){
    var rt = is_runtime ? 'runtime' : 'macrotime';
    return 'Bake($id root:$root $target [$rt])';
  }
}
class BakingLift{
  static public function get_build_location(self:Baking):Option<String>{
    return self.target.flat_map(
      (target) -> {
        return if(target == 'interp'){
          Util.option(self.root.toString());
        }else{
          final arr = ['--${target}','-${target}'];
          #if (stx_log || stx)
          __.log().trace(arr);
          #end
          
          final idx = arr.fold(
            (n:String,m:Option<Int>) -> m.fold(
              ok -> Util.option(ok),
              () -> {
                final i = self.args.index_of(x -> n == x); 
                return switch(i){
                  case -1 : None;
                  default : Some(i);
                }
              }
            ),
            None
          ); 

          idx.flat_map(
            (i) -> switch(target){
              case 'interp'   : None;
              default         : Some(self.args[i+1]); 
            }
          ).map(
            (tail) -> haxe.io.Path.addTrailingSlash(self.root.toString()) + tail
          );
        }
      });
  }
  static public function get_main(baking:Baking):Option<String>{
    final result = baking.args.fold(
      (n:String,m:{ data : Null<String>, done : Bool }) -> switch(m){
        case { done : false } : 
          ['-main','--main'].any(
            (str) -> str == m.data
          ).if_else(
            () -> { done : true, data : n },
            () -> { done : false, data : n }
          );
        case { done : true }   :
          m;
      },
      { done : false, data : null }
    );
    return result.done == true ? Util.option(result.data) : Util.option(null); 
  }
}