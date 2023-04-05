package bake;

typedef FieldDef<T> = { key : String, value:T };

@:forward abstract Field<T>(FieldDef<T>) from FieldDef<T> to FieldDef<T>{
  public function new(self) this = self;
  @:noUsing static public function lift<T>(self:FieldDef<T>):Field<T> return new Field(self);

  public function prj():FieldDef<T> return this;
  private var self(get,never):Field<T>;
  private function get_self():Field<T> return lift(this);
}