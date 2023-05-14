@SuppressWarnings("CheckReturnValue")
public class Execute extends HelloBaseVisitor<String> {

   @Override public String visitBye(HelloParser.ByeContext ctx) {	
      String res = "Bye ";
	for(int i = 0; i < ctx.ID().size() ; i++)
	{
		res+= ctx.ID().get(i)+" ";
	}
	res+= "\n";
	System.out.print(res);
      return res;
   }

   @Override public String visitGrettings(HelloParser.GrettingsContext ctx) {
      String res = "Hello ";
	for(int i = 0; i < ctx.ID().size() ; i++)
	{
		res+= ctx.ID().get(i)+" ";
	}
	res+= "\n";
	System.out.print(res);
      return res;
   }
}
