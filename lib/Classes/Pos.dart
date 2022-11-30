

class Pos {
	int x, y;

	Pos(this.y, this.x);

  bool inlineWith(Pos pos){
    return x == pos.x || y == pos.y;
  }

  Pos operator -() {
    return Pos(-y,-x);
  }

  Pos operator +(Pos other) {
    return Pos(y + other.y, x + other.x);
  }

  Pos operator -(Pos other) {
    return Pos(y - other.y, x - other.x);
  }
}
