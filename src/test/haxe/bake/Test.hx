package bake;

using stx.Nano;
using stx.Test;
using stx.Log;
using Bake;

class Test extends TestCase{
  static public function main(){
    boot();
    final bake = Bake.pop();
    trace(bake);

    __.test().run(
      [
        new Test()
      ],[]
    );
  }
  static public macro function boot(){
    final bake = Bake.pop();
    trace(bake);
    return macro {}
  }
  public function test(){

  }
}
