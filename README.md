# Stx Bake

Metadata from both the macro context and the runtime context of Haxe.


During the Macro stage, the type is called `Baking`, during runtime, it's called `Baked`

```haxe
  public var is_runtime(get,null):Bool;
  public var root(default,null):haxe.io.Path;
  //see get_build_location for guessing the current build folder
  public var classpaths(default,null):Cluster<String>;
  public var args(default,null):Cluster<String>;
  public var id(default,null):String;//Generates a uuid in Plugin
  public var defines(default,null):Cluster<nano.Field<String>>;
  public var home(default,null):String;
```