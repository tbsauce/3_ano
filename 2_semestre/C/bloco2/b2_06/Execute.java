import java.util.HashMap;

@SuppressWarnings("CheckReturnValue")
public class Execute extends CalculatorBaseVisitor<Double> {

   HashMap<String, Double> map  = new HashMap<>();

   @Override public Double visitStat(CalculatorParser.StatContext ctx) {
      Double res = null;
      if(ctx.expr() != null){
         System.out.println("Resultado: " + visit(ctx.expr()));
      }
      if(ctx.assignement() != null){
         System.out.println("Resultado: " + visit(ctx.assignement()));
      }
      return res;
   }

   @Override public Double visitAssignement(CalculatorParser.AssignementContext ctx) {
      Double res = null;
      String var = ctx.ID().getText();
      Double val = visit(ctx.expr());
      map.put(var, val);
      return val;

      
   }

   @Override public Double visitExprId(CalculatorParser.ExprIdContext ctx) {
      Double res = null;
      double var = map.get(ctx.ID().getText());
      return var;
   }

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
