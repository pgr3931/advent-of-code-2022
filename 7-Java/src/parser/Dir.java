package src.parser;

import java.util.LinkedList;
import java.util.List;

public class Dir {
    public String name;
    public List<File> files = new LinkedList<>();

    public Dir(String name) {
       this.name = name;
    }

    public List<File> getFiles() {
        return files;
    }

    public void setFiles(File file) {
        this.files.add(file);
    }

    public int getSize(){
        int sum = 0;
        for (File file : files) {
            sum += file.size;
        }
        return sum;
    }
}
