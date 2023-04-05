
class Main {
	static function main() {
		trace("Hello, world!");
		final bake = Bake.pop();
		trace(bake.args);
		trace(bake.get_build_location());
		trace(bake.defines);
	}
}
