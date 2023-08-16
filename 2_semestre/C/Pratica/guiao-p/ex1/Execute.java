import java.util.*;

@SuppressWarnings("CheckReturnValue")
public class Execute extends StrLangBaseVisitor<String> {

   Map <String, String> map = new HashMap<>();
   Scanner sc = new Scanner(System.in);

   @Override public String visitProgram(StrLangParser.ProgramContext ctx) {
      String res = null;
      return visitChildren(ctx);
      //return res;
   }

   @Override public String visitStat(StrLangParser.StatContext ctx) {
      String res = null;
      return visitChildren(ctx);
      //return res;
   }

   @Override public String visitAssing(StrLangParser.AssingContext ctx) {
      map.put(ctx.ID().getText(), visit(ctx.expr()));
      return null;
   }

   @Override public String visitPrint(StrLangParser.PrintContext ctx) {
      System.out.println(visit(ctx.expr()));
      return null;
   }

   @Override public String visitExprString(StrLangParser.ExprStringContext ctx) {
      String txt = ctx.String().getText();
      return txt.substring(1, txt.length()-1);
   }

   @Override public String visitExprSubs(StrLangParser.ExprSubsContext ctx) {
      String expr0 = visit(ctx.expr(0));
      String expr1 = visit(ctx.expr(1));
      String expr2 = visit(ctx.expr(2));
      return expr0.replace(expr1, expr2);
   }

   @Override public String visitExprParent(StrLangParser.ExprParentContext ctx) {
      return visit(ctx.expr());
   }

   @Override public String visitExprTrim(StrLangParser.ExprTrimContext ctx) {
      String expr = visit(ctx.expr());
      return expr.trim();
   }

   @Override public String visitExprID(StrLangParser.ExprIDContext ctx) {
      return map.get(ctx.ID().getText());
   }

   @Override public String visitExprScan(StrLangParser.ExprScanContext ctx) {
      System.out.println(visit(ctx.expr()));
      return sc.nextLine();
   }

   @Override public String visitExprCalc(StrLangParser.ExprCalcContext ctx) {
      String op = ctx.op.getText();
      String expr0 = visit(ctx.expr(0));
      String expr1 = visit(ctx.expr(1));
      if(op.equals("+"))
         return expr0 + expr1;
      else if(op.equals("-"))
         return expr0.replace(expr1, "");
         
      return null;
   }
}
