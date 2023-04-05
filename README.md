# Bake

Metadata from both the macro context and the runtime context of Haxe.

## Usage
```haxe
  class Main{
    static public macro function test(e:Expr){
      final bake = Bake.pop();//Baking
    }
    static public function main(){
      final bake = Bake.pop()://Baked
    } 
  }
```

During the Macro stage, the type is called `Baking`, during runtime, it's called `Baked`

```haxe
  public var is_runtime(get,null):Bool;
  public var root(default,null):haxe.io.Path;
  //see get_build_location for guessing the current build folder
  public var classpaths(default,null):Array<String>;
  public var args(default,null):Array<String>;
  public var id(default,null):String;//Generates a uuid in Plugin
  public var defines(default,null):Array<bake.Field<String>>;
  public var home(default,null):String;
```