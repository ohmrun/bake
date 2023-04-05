
class Main {
	static function main() {
		trace("Hello, world!");
		final bake = Bake.pop();
		trace(bake.args);
		trace(bake.get_build_location());
		trace(bake.defines);
		trace(bake);
	}
	static public macro function macro_time(){
		final bake = Bake.pop();
		trace(bake);
		return macro {};
	}
}
