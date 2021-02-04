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

@:access(stx.bake)class Plugin{
  static var printer = new Printer();
  macro static function use(){
    __.log().info("MACRO: stx_bake");
    var cwd         = Sys.getCwd();
      
    var cp          = Context.getClassPath();
    var args        = Sys.args();
    var defines     = Context.getDefines().keyValueIterator().toIter().lfold(
      (next,memo:Array<stx.nano.Field<String>>) -> memo.snoc(stx.nano.Field.create(next.key,next.value)),
      []
    );
    var session     = __.uuid();
        Context.addResource("stx.bake.session.id",Bytes.ofString(session));

    var home        = new Env().home().fudge();
       
    stx.bake.Baking.instance = new stx.bake.Baking(new haxe.io.Path(cwd),cp,args,defines,home);
    
    var self              = __.ident("stx.bake.Baked").toIdentDef();
    var parent            = __.ident("stx.bake.Baking").toIdentDef();
    
    var parent_tpath      = TPath({ name : parent.name, pack : parent.pack});
    var kind              = TDAbstract(parent_tpath,[],[parent_tpath]);

    var field : Field = {
      name : 'new',
      kind : FFun({
        args  : [],
        ret   : null,
        expr  : macro this = new stx.bake.Baking(new haxe.io.Path($v{cwd}),$v{cp},$v{args},$v{defines},$v{home})
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
      Context.getType(Identifier.fromIdentDef(self));
    }catch(e:Dynamic){
      //trace(e);
      Context.defineType(tdef);
    }
    return macro {};
  }
}
#end