@SuppressWarnings("CheckReturnValue")
public class Numbers extends NumbersBaseVisitor<Execute> {

   @Override public Execute visitProgram(NumbersParser.ProgramContext ctx) {
      Execute res = null;
      return visitChildren(ctx);
      //return res;
   }

   @Override public Execute visitText(NumbersParser.TextContext ctx) {
      Execute res = null;
      return visitChildren(ctx);
      //return res;
   }

   @Override public Execute visitLine(NumbersParser.LineContext ctx) {
      Execute res = null;
      return visitChildren(ctx);
      //return res;
   }
}
