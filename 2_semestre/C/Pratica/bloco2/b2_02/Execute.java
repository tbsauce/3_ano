@SuppressWarnings("CheckReturnValue")
public class Execute extends SuffixCalculatorBaseVisitor<Double> {


   @Override public Double visitStat(SuffixCalculatorParser.StatContext ctx) {
      Double res = null;
      if(ctx.expr() != null){
         System.out.println("Resultado: " + visit(ctx.expr()));
      }
      return res;
   }

   @Override public Double visitExprNumber(SuffixCalculatorParser.ExprNumberContext ctx) {
      Double number = Double.parseDouble(ctx.Number().getText());
      return number;
   }

   @Override public Double visitExprSuffix(SuffixCalculatorParser.ExprSuffixContext ctx) {
      Double res = null;
      Double expr1 = visit(ctx.expr(0));
      Double expr2 = visit(ctx.expr(1));
      String op = ctx.op.getText();

      switch (op){
         case "+":
            res = expr1 + expr2;
            break;
         case "-":
            res = expr1 - expr2;
            break;
         case "*":
            res = expr1 * expr2;
            break;
         case "/":
            res = expr1 / expr2;
            break;
      }

      return res;
   }
}
