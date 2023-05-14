@SuppressWarnings("CheckReturnValue")
public class Execute extends CalculatorBaseVisitor<String> {

   
   @Override public String visitStat(CalculatorParser.StatContext ctx) {
      String res = null;
      if(ctx.expr() != null){
         System.out.println(ctx.expr().getText() +  " --> " + visit(ctx.expr()));
      }
      if(ctx.assignement() != null){
         System.out.println(ctx.assignement().getText() + " --> " + visit(ctx.assignement()));
      }
      return res;
   }

   @Override public String visitAssignement(CalculatorParser.AssignementContext ctx) {
      String res = null;
      return ctx.ID().getText() + " = " + visit(ctx.expr());
   }

   @Override public String visitExprAddSub(CalculatorParser.ExprAddSubContext ctx) {
      String res = null;
      String expr1 = visit(ctx.expr(0));
      String expr2 = visit(ctx.expr(1));
      String op = ctx.op.getText();

      return expr1 + " " + expr2 + " " + op;
   }

   @Override public String visitExprIntegerSignal(CalculatorParser.ExprIntegerSignalContext ctx) {
      String res = null;
      String expr = visit(ctx.expr());
      String op = ctx.op.getText();
      return expr + " !" + op;
   }

   @Override public String visitExprParent(CalculatorParser.ExprParentContext ctx) {
      String res = null;
      return visit(ctx.expr());
   }

   @Override public String visitExprMultDivMod(CalculatorParser.ExprMultDivModContext ctx) {
      String res = null;
      String expr1 = visit(ctx.expr(0));
      String expr2 = visit(ctx.expr(1));
      String op = ctx.op.getText();
      return expr1 + " " + expr2 + " " + op;
   }

   @Override public String visitExprInteger(CalculatorParser.ExprIntegerContext ctx) {
      String res = null;
      return ctx.Integer().getText();
   }

   @Override public String visitExprId(CalculatorParser.ExprIdContext ctx) {
      String res = null;
      return ctx.ID().getText();
   }
}
