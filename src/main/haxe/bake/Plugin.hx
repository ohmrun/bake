package bake;

#if macro


import bake.Env;
import haxe.io.Bytes;

import haxe.macro.Expr;
import haxe.macro.Printer;
import haxe.macro.Context;

import bake.makro.*;

private typedef Pos = 
#if macro
haxe.macro.Expr.Position
#else
haxe.PosInfos;
#end

@:access(bake) class Plugin{
  static public function note(v:Dynamic,?pos:Pos){
    #if (debug && bake.switches.debug==true)
      #if macro
        haxe.Log.trace(v);
      #else
        haxe.Log.trace(v,pos);
      #end
    #end
  }
  static var printer = new Printer();
  macro static function use(){
    var cwd         = std.Sys.getCwd();
      
    var cp                                           = Context.getClassPath();
    var args                                         = std.Sys.args();
    var defines_map                                  = Context.getDefines();
    var defines = [];
    for(key => val in defines_map){
      defines.push({key : key, value : val});
    }
    final is_eval     = defines.search(x -> x.key == 'eval');
    note('is_eval:   $is_eval');
    final is_interp   = defines.search(x -> x.key == 'interp');
    note('is_interp: $is_interp');
    final target_name = defines.search(x -> x.key == 'target.name');
    note('target_name: $target_name');
    var resources     = Context.getResources();
    note(Bake.is_macro());
    var session     = Util.uuid();
        Context.addResource("bake.session.id",Bytes.ofString(session));

    var home        = new Env().home().fudge('home environment variable not found');
       
    bake.Baking.instance = new bake.Baking(new haxe.io.Path(cwd),cp,args,defines,home);
    
    var self              = { pack : ['bake'], name : 'Baked' };
    var parent            = { pack : ['bake'], name : 'Baking'};
    
    var parent_tpath      = TPath({ name : parent.name, pack : parent.pack});
    var kind              = TDAbstract(parent_tpath,[],[parent_tpath]);

    var field : Field = {
      name : 'new',
      kind : FFun({
        args  : [],
        ret   : null,
        expr  : macro this = 
          new bake.Baking(
            new haxe.io.Path($v{cwd}),
            $v{cp},
            $v{args},
            $v{defines}.map((kv) -> bake.Field.lift({ key : kv.key, value : kv.value})),
            $v{home})
      }),
      access  : [APublic],
      pos     : Context.currentPos()
    } 
    var tdef : TypeDefinition = {
      meta    : [{name : ":forward", pos : Context.currentPos()}],
      name    : self.name,
      pack    : self.pack,
      fields  : [field],
      kind    : kind,
      pos     : Context.currentPos()
    }
    
    try{
      Context.getType(self.toIdentifier());
    }catch(e:Dynamic){
      //trace(e);
      Context.defineType(tdef);
    }
    return macro {};
  }
}
#end