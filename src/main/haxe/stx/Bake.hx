package stx;

using stx.bake.Logging;
import stx.bake.Baking;

class Bake{
  static public function bake(wildcard:Wildcard){
    #if macro
      //__.log()("macro bake");
      #if(debug)
        //trace(stx.bake.Baking.instance.toString());
      #end
      return stx.bake.Baking.instance;//Need to call any build macros after stx_build plugin is called.
    #else
      //__.log()("runtime bake");
      #if(debug)
        //trace(new stx.bake.Baked().toString());
      #end
      return new stx.bake.Baked();//If this isn't built that's most likely some other error.
    #end
  }
}