@SuppressWarnings("CheckReturnValue")
public class Execute extends PreffixCalculatorBaseVisitor<Double> {


   @Override public Double visitStat(PreffixCalculatorParser.StatContext ctx) {
      Double res = null;
      if(ctx.expr() != null){
         System.out.println("Resultado: " + visit(ctx.expr()));
      }
      return res;
   }

   @Override public Double visitExprPreffix(PreffixCalculatorParser.ExprPreffixContext ctx) {
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

   @Override public Double visitExprNumber(PreffixCalculatorParser.ExprNumberContext ctx) {
      Double number = Double.parseDouble(ctx.Number().getText());
      return number;
   }
}
