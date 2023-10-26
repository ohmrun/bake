
class Main {
	static function main() {
		macro_time();

		final bake = Bake.pop();
		
		trace(bake.timestamp);
		// trace(bake);
	}
	static public macro function macro_time(){
		final bake = Bake.pop();
		//trace(bake.args);
		trace(bake.timestamp);
		return macro {};
	}
}
