package src.tree;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import src.parser.Dir;

//https://github.com/gt4dev/yet-another-tree-structure/blob/master/java/src/com/tree/TreeNode.java
public class TreeNode implements Iterable<TreeNode> {

	public Dir data;
	public TreeNode parent;
	public List<TreeNode> children;

	public boolean isRoot() {
		return parent == null;
	}

	public boolean isLeaf() {
		return children.size() == 0;
	}

	private List<TreeNode> elementsIndex;

	public TreeNode(Dir data) {
		this.data = data;
		this.children = new LinkedList<TreeNode>();
		this.elementsIndex = new LinkedList<TreeNode>();
	}

	public TreeNode addChild(Dir child) {
		TreeNode childNode = new TreeNode(child);
		childNode.parent = this;
		this.children.add(childNode);
		this.registerChildForSearch(childNode);
		return childNode;
	}

	public int getLevel() {
		if (this.isRoot())
			return 0;
		else
			return parent.getLevel() + 1;
	}

	private void registerChildForSearch(TreeNode node) {
		elementsIndex.add(node);
		if (parent != null)
			parent.registerChildForSearch(node);
	}

	public TreeNode findTreeNode(String name) {
		for (TreeNode element : this.elementsIndex) {
			Dir elData = element.data;
			if (elData.name.endsWith(name))
				return element;
		}

		return null;
	}

	public int getSize(){
		int sum = 0;
		for (TreeNode node : this) {
			sum += node.data.getSize();
		}
		return sum;
	}

	@Override
	public String toString() {
		return data != null ? data.toString() : "[data null]";
	}

	@Override
	public Iterator<TreeNode> iterator() {
		TreeNodeIter<Dir> iter = new TreeNodeIter<Dir>(this);
		return iter;
	}

}