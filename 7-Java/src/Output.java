package src;

import java.io.File;  
import java.io.FileNotFoundException;  
import java.util.Scanner;

import src.parser.Command;
import src.parser.Dir;
import src.parser.Parser;
import src.tree.TreeNode;

public class Output {
    public static void main(String[] args) {
        TreeNode root = new TreeNode(new Dir("/"));
        TreeNode currentDir = root;

        try {
            File f = new File("./src/input.txt");
            Scanner r = new Scanner(f);

            while (r.hasNextLine()) {
                String line = r.nextLine();
                Command c = Parser.parseCommand(line);

                switch (c) {
                    case CD:
                        String arg = Parser.parseArgument(line);
                        currentDir = arg.equals("/") ? root : arg.equals("..") ? currentDir.parent : currentDir.findTreeNode(arg);
                        break; 
                    case FILE:
                            Parser.parse(line, currentDir);
                        break;              
                    default:
                        break;
                }
            }
            
            r.close();
        } catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }

        for (TreeNode node : root) {
			String indent = createIndent(node.getLevel());
			System.out.println(indent + node.data.name + " " + node.getSize());
		}

        System.out.println("\n");

        // Part one

        int i = 0;

        for (TreeNode node : root) {
			int size = node.getSize();
            if(size <= 100000){
                i += size;
            }
		}

        System.out.println(i);

        // Part two

        int necessarySpace = (70000000 - root.getSize() - 30000000) * -1;
        i = root.getSize();

        for (TreeNode node : root) {
			int size = node.getSize();
            if(size >= necessarySpace){
                i = Math.min(size, i);
            }
		}

        System.out.println(i);
    }

    private static String createIndent(int depth) {
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < depth; i++) {
			sb.append(' ');
		}
		return sb.toString();
	}
}