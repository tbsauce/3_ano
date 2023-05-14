import java.util.Scanner;
import java.util.Map;
import java.util.HashMap;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.File;

public class ex4 {
    public static void main(String[] args){
        Map<String, Integer> numbers = new HashMap<String, Integer>();

        File numbersTxt = new File("bloco1/numbers.txt");

        try {
            FileReader reader = new FileReader(numbersTxt);
            BufferedReader bufferedReader = new BufferedReader(reader);
            String line;

            while ((line = bufferedReader.readLine()) != null) {
                String[] parts = line.split(" - ");
                numbers.put(parts[1], Integer.parseInt(parts[0]));
            }

            reader.close();
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }

        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter a Text: ");
        String text = scanner.nextLine();
        
        String [] textSplit = text.split(" ");  

        String newText = "";

        for (String word : textSplit) {
            if (numbers.containsKey(word)) {
                newText += numbers.get(word) + " ";
            } else {
                newText += word + " ";
            }
        }

        System.out.println(newText);
        scanner.close();
    }
        
}