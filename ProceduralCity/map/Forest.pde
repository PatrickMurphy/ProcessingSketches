class Forest {
  ArrayList <Tree> trees;
  int treeCount = 0;
  Forest() {
    trees = new ArrayList<Tree>();
  }
  Forest addTree(Tree t){
    trees.add(t);
    println("add tree " + treeCount++);
    println(t.pos);
    return this;
  };
  Forest display(){
    for (Tree t : trees) {
      t.display();
    }
    return this;
  }
}