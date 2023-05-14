import java.util.Scanner;
import java.util.Map;
import java.util.HashMap;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.File;

public class ex5 {
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
        int Number = 0;
        String [] textSplit = text.split(" ");
        for (String word : textSplit) {
            
        }

        for (int i = 0; i < textSplit.length-1; i=i+2) {
            if(!numbers.containsKey(textSplit[i])){
                i++;
            }
            if (numbers.containsKey(textSplit[i])) {
                if(numbers.get(textSplit[i]) < numbers.get(textSplit[i+1])){
                    Number += numbers.get(textSplit[i+1]) * numbers.get(textSplit[i]);
                }
                else{
                    Number += numbers.get(textSplit[i+1]) + numbers.get(textSplit[i]);
                }
            }
        }

        System.out.println(Number);
        scanner.close();
    }
        
}