package stx.bake.makro;

class Generate{
  static public function apply(self:Baking,tdef:TypeDefinition){
    var printer = new haxe.macro.Printer();
    var to_disk = printer.printTypeDefinition(tdef);
    var gen     = "src.gen.haxe".split(".");
    var name    = tdef.name;
    var classes = self.root.into(gen);
    var str     = classes.into(tdef.pack).into('$name.hx');
    __.log().info('building: $classes $str');

    try{
      sys.FileSystem.createDirectory(classes.into(tdef.pack).toString());
      sys.io.File.saveContent(str.toString(),to_disk);
      
    }catch(e:haxe.Exception){
      __.log().fatal(e.toString());
      throw(e);
    }
    

  }
}