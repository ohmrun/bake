package ;

import bake.Baking;

class Bake{
  static public function pop(){
    #if macro
      //__.log()("macro bake");
      #if(debug)
        //trace(bake.Baking.instance.toString());
      #end
      return bake.Baking.instance;//Need to call any build macros after stx_build plugin is called.
    #else
      //__.log()("runtime bake");
      #if(debug)
        //trace(new bake.Baked().toString());
      #end
      return new bake.Baked();//If this isn't built that's most likely some other error.
    #end
  }
}