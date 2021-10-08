package stx.bake;

using StringTools;

import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.MacroStringTools;

import stx.bake.makro.*;

/**
  @google "Type not found : stx.build.Baked"
  `__.bake` returns `Baking.instance` at macro-time and `stx.build.Baked` at compile time.
  If your program is looking for `Baked`, there was a compiler error.
**/
@:keep
class Baking{ 
  @:allow(stx.Bake) static private var instance(default,null) : stx.bake.Baking; 

  public var is_runtime(get,null):Bool;
  function get_is_runtime(){
    return stx.bake.Baking.instance == null;
  }
  public var root(default,null):haxe.io.Path;
  public var classpaths(default,null):Cluster<String>;
  public var args(default,null):Cluster<String>;
  public var id(default,null):String;
  public var defines(default,null):Cluster<stx.nano.Field<String>>;
  //public var resources(default,null):Map<String,Bytes>;
  public var home(default,null):String;

  public function new(root,classpaths,args,defines:Cluster<stx.nano.Field<String>>,home){
    this.root       = root;
    this.classpaths = classpaths;
    this.args       = args;
    this.id         = __.resource("stx.bake.session.id").string();//sneaking this around via haxe.Resource in a macro.
    this.defines    = defines;
    this.home       = home;
  }
  #if (!macro)
    public function publish(tdef:TypeDefinition){}
  #else
    public function publish(tdef:TypeDefinition){
      return Generate.apply(this,tdef);
    }
  #end
  public var target(get,null) : Option<CompilerTarget>;
  private function get_target(){
    return GetTarget.apply(this);
  }

  public function toString(){
    var rt = is_runtime ? 'runtime' : 'macrotime';
    return 'Bake($id root:$root $target [$rt] home:$home)';
  }
}