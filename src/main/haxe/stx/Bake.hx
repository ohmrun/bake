package stx;

import stx.bake.Baking;

class Bake{
  static public function bake(wildcard:Wildcard){
    #if macro
      //__.log()("macro bake");
      return stx.bake.Baking.instance;//Need to call any build macros after stx_build plugin is called.
    #else
      //__.log()("runtime bake");
      return new stx.bake.Baked();//If this isn't built that's most likely some other error.
    #end
  }
}