package src.parser;

import java.util.regex.Pattern;

import src.tree.TreeNode;

import java.util.regex.Matcher;

public final class Parser {
    public static Command parseCommand(String input){
        if(input.startsWith("$ cd")){
            return Command.CD;
        } else if(input.startsWith("$ ls")){
            return Command.LS;
        } else {
            return Command.FILE;
        }
    }

    public static String parseArgument(String input){
        Command c = parseCommand(input);

        if(c == Command.CD){
            return input.split(" ")[input.split(" ").length - 1];
        }

        return input;
    }

    public static void parse(String input, TreeNode currentDir){
        Pattern p = Pattern.compile("\\d+");
        Matcher m = p.matcher(input);
        if(m.find()){
            currentDir.data.setFiles(new File(Integer.parseInt(m.group()), input.split(" ")[input.split(" ").length - 1]));
        } else {
            String name = input.split(" ")[input.split(" ").length - 1];
            name = (currentDir.data.name.equals("/") ? "" : currentDir.data.name) + '/' + name;
            currentDir.addChild(new Dir(name));
        }
    }
}
