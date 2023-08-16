import java.util.HashMap;

import javax.xml.crypto.dsig.keyinfo.RetrievalMethod;

@SuppressWarnings("CheckReturnValue")
public class Execute extends CalFracBaseVisitor<Frac> {

   HashMap<String, Frac> map  = new HashMap<>();

   @Override public Frac visitExprPrint(CalFracParser.ExprPrintContext ctx) {
      Frac res = null;
      visit(ctx.print());
      return res;
   }

   @Override public Frac visitExprassign(CalFracParser.ExprassignContext ctx) {
      Frac res = null;
      visit(ctx.assign());
      return res;
   }

   @Override public Frac visitPrint(CalFracParser.PrintContext ctx) {
      Frac res = null;
      System.out.println(visit(ctx.expr()));
      return res;
   }

   @Override public Frac visitAssign(CalFracParser.AssignContext ctx) {
      Frac res = null;
      String var = ctx.ID().getText();
      Frac val = visit(ctx.expr());
      map.put(var, val);
      return val;
   }

   @Override public Frac visitExprFrac(CalFracParser.ExprFracContext ctx) {
      Frac res = new Frac(ctx.Integer(0).getText(),ctx.Integer(1).getText());
      return res;
   }

   @Override public Frac visitExprInteger(CalFracParser.ExprIntegerContext ctx) {
      Frac res = new Frac(ctx.Integer().getText());
      return res;
   }

   @Override public Frac visitExprIntegerSignal(CalFracParser.ExprIntegerSignalContext ctx) {
      Frac res = null;
      Frac expr = visit(ctx.expr());
      String op = ctx.op.getText();

      switch (op){
         case "+":
            res = expr;
            break;
         case "-":
            res = expr.negative();
            break;

      }
      return res;
   }

   @Override public Frac visitExprParent(CalFracParser.ExprParentContext ctx) {
      return visit(ctx.expr());
   }

   @Override public Frac visitExprId(CalFracParser.ExprIdContext ctx) {
      Frac var = map.get(ctx.ID().getText());
      return var;
   }

   @Override public Frac visitExprMultDiv(CalFracParser.ExprMultDivContext ctx) {
      Frac res = null;
      Frac expr1 = visit(ctx.expr(0));
      Frac expr2 = visit(ctx.expr(1));
      String op = ctx.op.getText();

      switch (op){
         case "*":
            res = expr1.multiplication(expr2);
            break;
         case ":":
         res = expr1.division(expr2);
            break;
      }
      return res;
   }

   @Override public Frac visitExprAddSub(CalFracParser.ExprAddSubContext ctx) {
      Frac res = null;
      Frac expr1 = visit(ctx.expr(0));
      Frac expr2 = visit(ctx.expr(1));
      String op = ctx.op.getText();

      switch (op){
         case "+":
            res = expr1.addition(expr2);
            break;
         case "-":
         res = expr1.subtration(expr2);
            break;
      }
      return res;
   }
}
