package ;

#if (stx_log || stx)
  using stx.Nano;
  using stx.Log;
#end
import bake.Baking;

class Bake{
  #if macro
  @:noUsing static public function is_macro(){
    return true;
  }
  #else
  @:noUsing static public function is_macro(){
    return false;
  }
  #end
  static public function pop(){
    #if (macro)
      //__.log()("macro bake");
      #if (stx_log || stx)
      __.log().trace("macro bake");
      #end
      #if(debug)
        //trace(bake.Baking.instance.toString());
      #end
      return bake.Baking.instance;//Need to call any build macros after stx_build plugin is called.
    #else
      //__.log()("runtime bake");
      #if (stx_log || stx)
      __.log().trace("runtime bake");
      #end
      #if(debug)
        //trace(new bake.Baked().toString());
      #end
      return new bake.Baked();//If this isn't built that's most likely some other error.
    #end
  }
}