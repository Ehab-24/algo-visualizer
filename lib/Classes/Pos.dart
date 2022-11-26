

class Pos {
	int x, y;

	Pos(this.y, this.x);

  bool inlineWith(Pos pos){
    return x == pos.x || y == pos.y;
  }
}
