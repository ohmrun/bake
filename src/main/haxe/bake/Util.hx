package bake;

import haxe.ds.Option;

class Util{
  @:noUsing static public function option<T>(v:Null<T>):Option<T>{
    return switch(v){
      case null : None;
      case x    : Some(x);
    }
  }
  #if (sys || nodejs)
  @:noUsing static public function env(str:String){
    return option(Sys.getEnv(str));
  }
  #end
/**
  Returns a unique identifier, each `x` replaced with a hex character.
**/
@:noUsing static public function uuid(value : String = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx') : String {
  var reg = ~/[xy]/g;
  return reg.map(value, function(reg) {
      var r = std.Std.int(Math.random() * 16) | 0;
      var v = reg.matched(0) == 'x' ? r : (r & 0x3 | 0x8);
      return StringTools.hex(v);
  }).toLowerCase();
}
}
class OptionUtil{
  static public function is_defined<T>(opt:Option<T>){
    return switch(opt){
      case Some(_) : true;
      default : false;
    }
  }
  static public function zip_with<Ti,Tii,Z>(l:Option<Ti>,r:Option<Tii>,fn:Ti->Tii->Z):Option<Z>{
    return switch([l,r]){
      case [Some(l),Some(r)]  : Some(fn(l,r));
      default                 : None;
    }
  }
  static public function flat_map<T,Ti>(self:Option<T>,fn:T->Option<Ti>):Option<Ti>{
    return switch(self){
      case Some(x) : fn(x);
      default      : None;
    }
  }
  static public function fold<T,Z>(self:Option<T>,some:T->Z,none:Void->Z):Z{
    return switch(self){
      case Some(v)  : some(v);
      case None     : none();
    }
  }
  static public function fudge<T>(self:Option<T>,?msg:String):T{
    return fold(self,(x) -> x,() -> throw msg);
  }
  static public function map<T,Ti>(self:Option<T>,fn:T->Ti):Option<Ti>{
    return fold(self,x -> Some(fn(x)),() -> None);
  }
}
class BoolUtil{
  static public function if_else<T>(b:Bool,l:Void->T,r:Void->T){
    return b ? l() : r();
  }
}
class IdentUtil{
  static public function toIdentifier(self:{ pack : Array<String>, name : String }){
    return switch(self){
      case { name : n, pack : null }                          : n;
      case { name : n, pack : pack }    if (pack.length == 0) : n;
      case { name : n, pack : p    }                          : {
        var next = p.copy();
        next.push(n);
        return next.join(".");
      }
    }
  }
}
class ArrayUtil{
  /**
	 * Produces the index of element `t`. For a function producing an `Option`, see `findArrayOf`.
	**/
  static public inline function index_of<T>(self: Array<T>, t: T->Bool): Int {
    var index = 0;
    var ok    = false;

    for (e in self) {
      if (t(e)){
        ok = true;
        break;
      }

      ++index;
    }

    return ok ? index : -1;
  }
/**
	 * Produces `true` if the predicate returns `true` for *any* element, `false` otherwise.
	**/
  static public function any<T>(self:Array<T>,fn:T->Bool): Bool {
    return self.fold(function(b,a) {
      return switch (a) {
        case false: fn(b);
        case true:  true;
      }
    },false);
  }

  /**
    * Produces an `Option.Some(element)` the first time the predicate returns `true`,
    * `None` otherwise.
	**/
  static public function search<T>(self:Array<T>,fn:T->Bool):Option<T>{
    var out = None;
    for(el in self){
      if(fn(el)){
        out = Some(el);
        break;
      }
    }
    return out;
  }
}
class TargetUtil{
  static public function uses_file(self:String):Bool{
    return switch(self){
      case 'swf' | 'js' | 'neko' | 'cppia' | 'python' | 'lua' | 'hl'        : true;
      case 'php' | 'cpp' | 'cs' | 'java' | 'interp'                         : false;
      default : true;
    }
  }
}