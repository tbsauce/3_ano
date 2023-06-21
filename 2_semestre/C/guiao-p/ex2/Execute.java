import java.util.*;

@SuppressWarnings("CheckReturnValue")
public class Execute extends FracLangBaseVisitor<Frac> {

   Scanner sc = new Scanner(System.in);
   Map<String, Frac> map = new HashMap<>();

   @Override public Frac visitProgram(FracLangParser.ProgramContext ctx) {
      Frac res = null;
      return visitChildren(ctx);
      //return res;
   }

   @Override public Frac visitStat(FracLangParser.StatContext ctx) {
      Frac res = null;
      return visitChildren(ctx);
      //return res;
   }

   @Override public Frac visitPrint(FracLangParser.PrintContext ctx) {
      System.out.println(visit(ctx.expr()));
      return null;
   }

   @Override public Frac visitAssign(FracLangParser.AssignContext ctx) {
      map.put(ctx.ID().getText(), visit(ctx.expr()));
      return null;
   }

   @Override public Frac visitExprRead(FracLangParser.ExprReadContext ctx) {
      String out = ctx.String().getText();
      System.out.println(out.substring(1, out.length()-1));
      String in = sc.nextLine();
      if(in.contains("/")){
         String [] num = in.split("/");
         try{
            return new Frac(Integer.parseInt(num[0]), Integer.parseInt(num[1]));
         }
         catch(Exception e){
            System.err.println("Error Frac invalid");
            return null;
         }
      }
      else{
         try{
            return new Frac(Integer.parseInt(in));
         }
         catch(Exception e){
            System.err.println("Error Frac invalid");
            return null;
         }
      }

   }

   @Override public Frac visitExprParent(FracLangParser.ExprParentContext ctx) {
      return visit(ctx.expr());
   }

   @Override public Frac visitExprReduce(FracLangParser.ExprReduceContext ctx) {
      return Frac.reduce(visit(ctx.expr()));
   }

   @Override public Frac visitExprID(FracLangParser.ExprIDContext ctx) {
      return map.get(ctx.ID().getText());
   }

   @Override public Frac visitExprFrac(FracLangParser.ExprFracContext ctx) {
      return new Frac(Integer.parseInt(ctx.Num(0).getText()),Integer.parseInt(ctx.Num(1).getText()));
   }

   @Override public Frac visitExprNum(FracLangParser.ExprNumContext ctx) {
     return new Frac(Integer.parseInt(ctx.Num().getText()));
   }

   @Override public Frac visitExprAddSub(FracLangParser.ExprAddSubContext ctx) {
      String op = ctx.op.getText();
      Frac e0 = visit(ctx.expr(0));
      Frac e1 = visit(ctx.expr(1));
      
      if(op.equals("+"))
         return Frac.add(e0, e1);
      else if(op.equals("-"))
         return Frac.sub(e0,e1);
      return null;
   }

   @Override public Frac visitExprMultDiv(FracLangParser.ExprMultDivContext ctx) {
      String op = ctx.op.getText();
      Frac e0 = visit(ctx.expr(0));
      Frac e1 = visit(ctx.expr(1));
      
      if(op.equals("*"))
         return Frac.mult(e0, e1);
      else if(op.equals(":"))
         return Frac.div(e0,e1);
      return null;
   }

   @Override public Frac visitExprUnitary(FracLangParser.ExprUnitaryContext ctx) {
      String op = ctx.op.getText();
      if(op.equals("-"))
         return Frac.unitaryNegative(visit(ctx.expr()));
      return visit(ctx.expr());
   }
}
