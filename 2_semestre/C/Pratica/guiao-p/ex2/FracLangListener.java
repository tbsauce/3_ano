// Generated from FracLang.g4 by ANTLR 4.12.0
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link FracLangParser}.
 */
public interface FracLangListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link FracLangParser#program}.
	 * @param ctx the parse tree
	 */
	void enterProgram(FracLangParser.ProgramContext ctx);
	/**
	 * Exit a parse tree produced by {@link FracLangParser#program}.
	 * @param ctx the parse tree
	 */
	void exitProgram(FracLangParser.ProgramContext ctx);
	/**
	 * Enter a parse tree produced by {@link FracLangParser#stat}.
	 * @param ctx the parse tree
	 */
	void enterStat(FracLangParser.StatContext ctx);
	/**
	 * Exit a parse tree produced by {@link FracLangParser#stat}.
	 * @param ctx the parse tree
	 */
	void exitStat(FracLangParser.StatContext ctx);
	/**
	 * Enter a parse tree produced by {@link FracLangParser#print}.
	 * @param ctx the parse tree
	 */
	void enterPrint(FracLangParser.PrintContext ctx);
	/**
	 * Exit a parse tree produced by {@link FracLangParser#print}.
	 * @param ctx the parse tree
	 */
	void exitPrint(FracLangParser.PrintContext ctx);
	/**
	 * Enter a parse tree produced by {@link FracLangParser#assign}.
	 * @param ctx the parse tree
	 */
	void enterAssign(FracLangParser.AssignContext ctx);
	/**
	 * Exit a parse tree produced by {@link FracLangParser#assign}.
	 * @param ctx the parse tree
	 */
	void exitAssign(FracLangParser.AssignContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprMultDiv}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprMultDiv(FracLangParser.ExprMultDivContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprMultDiv}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprMultDiv(FracLangParser.ExprMultDivContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprRead}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprRead(FracLangParser.ExprReadContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprRead}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprRead(FracLangParser.ExprReadContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprAddSub}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprAddSub(FracLangParser.ExprAddSubContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprAddSub}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprAddSub(FracLangParser.ExprAddSubContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprParent}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprParent(FracLangParser.ExprParentContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprParent}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprParent(FracLangParser.ExprParentContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprReduce}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprReduce(FracLangParser.ExprReduceContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprReduce}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprReduce(FracLangParser.ExprReduceContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprID}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprID(FracLangParser.ExprIDContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprID}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprID(FracLangParser.ExprIDContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprFrac}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprFrac(FracLangParser.ExprFracContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprFrac}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprFrac(FracLangParser.ExprFracContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprNum}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprNum(FracLangParser.ExprNumContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprNum}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprNum(FracLangParser.ExprNumContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprUnitary}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprUnitary(FracLangParser.ExprUnitaryContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprUnitary}
	 * labeled alternative in {@link FracLangParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprUnitary(FracLangParser.ExprUnitaryContext ctx);
}