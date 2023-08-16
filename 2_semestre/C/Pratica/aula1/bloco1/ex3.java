package aula1;

import java.util.Scanner;
import java.util.Stack;

public class ex3 {
    public static void main(String[] args){
        Stack<Double> stack = new Stack<Double>();
        
        Scanner sc = new Scanner(System.in);

        while(true){
            String  a = sc.nextLine();
            String[] in=a.split(" ");
            for (String k : in) {
                if(k.equals("+") || k.equals("-") || k.equals("*") || k.equals("/")){
                    double n1 = stack.pop();
                    double n2 = stack.pop();

                    stack.push(calc(n1, k, n2));

                    System.out.println(stack.peek());
                    
                }
                else{
                    stack.push(Double.parseDouble(k));
                }
            }
        }
    }

    public static double calc(double n, String op, double m){
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
