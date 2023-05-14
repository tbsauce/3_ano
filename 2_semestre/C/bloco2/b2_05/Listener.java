import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.TerminalNode;
@SuppressWarnings("CheckReturnValue")

public class Listener extends NumbersBaseListener {

   HashMap<String, Integer> map = new HashMap<>();

   @Override public void enterProgram(NumbersParser.ProgramContext ctx) {
   }

   @Override public void exitProgram(NumbersParser.ProgramContext ctx) {
   }

   @Override public void enterText(NumbersParser.TextContext ctx) {
   }

   @Override public void exitText(NumbersParser.TextContext ctx) {
   }

   @Override public void enterLine(NumbersParser.LineContext ctx) {
      map.put(ctx.ID().getText(), Integer.parseInt(ctx.Num().getText()));
   }

   public HashMap<String, Integer> getMap(){
		return map;
	}

   @Override public void exitLine(NumbersParser.LineContext ctx) {
   }

   @Override public void enterEveryRule(ParserRuleContext ctx) {
   }

   @Override public void exitEveryRule(ParserRuleContext ctx) {
   }

   @Override public void visitTerminal(TerminalNode node) {
   }

   @Override public void visitErrorNode(ErrorNode node) {
   }
}
