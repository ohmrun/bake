package stx.bake;

#if macro
using stx.Pico;
using stx.Nano;
using stx.Ds;
using stx.Log;


import stx.nano.Field in HaxeField;

import stx.bake.Env;
import haxe.io.Bytes;

import haxe.macro.Expr;
import haxe.macro.Printer;
import haxe.macro.Context;
import stx.makro.expr.TypeDefinition;

import stx.bake.makro.*;

@:access(stx.bake) class Plugin{
  static var printer = new Printer();
  macro static function use(){
    __.log().info("stx.bake.Plugin.use");
    var cwd         = std.Sys.getCwd();
      
    var cp                                           = Context.getClassPath();
    var args                                         = std.Sys.args();
    var defines : Cluster<stx.nano.Field<String>>    = Context.getDefines().keyValueIterator().toIter().lfold(
      (next,memo:Cluster<stx.nano.Field<String>>) -> memo.snoc(stx.nano.Field.create(next.key,next.value)),
      Cluster.unit()
    );
    var resources   = Context.getResources();
    
    var session     = __.uuid();
        Context.addResource("stx.bake.session.id",Bytes.ofString(session));

    var home        = new Env().home().fudge();
       
    stx.bake.Baking.instance = new stx.bake.Baking(new haxe.io.Path(cwd),cp,args,defines,home);
    
    var self              = Ident.fromIdentifier(__.ident("stx.bake.Baked"));
    var parent            = Ident.fromIdentifier(__.ident("stx.bake.Baking"));
    
    var parent_tpath      = TPath({ name : parent.name, pack : parent.pack});
    var kind              = TDAbstract(parent_tpath,[],[parent_tpath]);

    var field : Field = {
      name : 'new',
      kind : FFun({
        args  : [],
        ret   : null,
        expr  : macro this = 
          new stx.bake.Baking(
            new haxe.io.Path($v{cwd}),
            stx.nano.Cluster.lift($v{cp}),
            stx.nano.Cluster.lift($v{args}),
            stx.nano.Cluster.lift($v{defines}.map((kv) -> stx.nano.Field.lift({ key : kv.key, val : kv.val}))),
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