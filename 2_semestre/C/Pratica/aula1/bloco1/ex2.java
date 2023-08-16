package aula1;

import java.util.Scanner;
import java.util.Map;
import java.util.HashMap;


class ex2{

    
    public static void main(String[] args){
        
        
        Map<String, Double> map = new HashMap<String, Double>();
        Scanner sc = new Scanner(System.in);
        while(true){
            
            String  a = sc.nextLine();
            String[] k=a.split(" ");
            
            
            if (k[1].equals("=")  && k.length > 3){
                double temp = calc(k[2], k[3], k[4], map);
                System.out.println(temp);
                map.put(k[0], temp);
            }
            else if (k[1].equals("=")){
                double temp = Double.parseDouble(k[2]);
                System.out.println(temp);
                map.put(k[0], temp);
            }
            else if (!k[1].equals("=")){
                System.out.println(calc(k[0], k[1], k[2], map));
            }
            else{
                System.err.println("Invalid operator");
            }
        }

    }

    public static double calc(String nr, String op, String mr, Map<String, Double> map){
        if (map.containsKey(nr)){
            nr = map.get(nr).toString();
        }
        if (map.containsKey(mr)){
            mr = map.get(mr).toString();
        }
        double n = Double.parseDouble(nr);
        double  m = Double.parseDouble(mr);
        if (op.equals("+")){
            return n+m;
        }else if (op.equals("-")){
            return n-m;
        }else if (op.equals("*")){
            return n*m;
        }else if (op.equals("/")){
            return n/m;
        }else{
            System.err.println("Invalid operator");
        }
        return 0;
    }
}
