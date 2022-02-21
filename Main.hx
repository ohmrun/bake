using stx.Nano;
using stx.Bake;
using stx.Log;

class Main {
	static function main() {
		final log = __.log().global;
					log.includes.push("stx/bake");

		trace("Hello, world!");
		trace(__.bake().args);
		trace(__.bake().get_build_location());
	}
}
