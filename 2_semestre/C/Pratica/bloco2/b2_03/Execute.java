@SuppressWarnings("CheckReturnValue")
public class Execute extends CalculatorBaseVisitor<Double> {

   @Override public Double visitExprIntegerSignal(CalculatorParser.ExprIntegerSignalContext ctx) {
      Double res = null;
      Double expr = visit(ctx.expr());
      String op = ctx.op.getText();

      switch (op){
         case "+":
            res = expr;
            break;
         case "-":
            res = -expr;
            break;

      }
      return res;
   }

      @Override public Double visitStat(CalculatorParser.StatContext ctx) {
      Double res = null;
      if(ctx.expr() != null){
         System.out.println("Resultado: " + visit(ctx.expr()));
      }
      return res;
   }

   @Override public Double visitExprAddSub(CalculatorParser.ExprAddSubContext ctx) {
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
      }
      return res;
   }

   @Override public Double visitExprMultDivMod(CalculatorParser.ExprMultDivModContext ctx) {
      Double res = null;
      Double expr1 = visit(ctx.expr(0));
      Double expr2 = visit(ctx.expr(1));
      String op = ctx.op.getText();

      switch (op){
         case "*":
            res = expr1 * expr2;
            break;
         case "/":
            res = expr1 / expr2;
            break;
         case "%":
            res = expr1 % expr2;
            break;
      }
      return res;
   }

   @Override public Double visitExprParent(CalculatorParser.ExprParentContext ctx) {
      return visit(ctx.expr());
   }

   @Override public Double visitExprInteger(CalculatorParser.ExprIntegerContext ctx) {
      Double number = Double.parseDouble(ctx.Integer().getText());
      return number;
   }
}
