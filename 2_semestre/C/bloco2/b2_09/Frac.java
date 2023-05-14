public class Frac {
    
    int e1;
    int e2;

    Frac(String e1, String e2){
        this.e1 = Integer.parseInt(e1);
        this.e2 = Integer.parseInt(e2);
    }

    Frac(String e1){
        this.e1 = Integer.parseInt(e1);
        this.e2 = 1;
    }

    Frac(int e1, int e2){
        this.e1 = e1;
        this.e2 = e2;
    }

    Frac(int e1){
        this.e1 = e1;
        this.e2 = 1;
    }

    @Override
    public String toString(){
        if(this.e2 == 1){
            return Integer.toString(this.e1);
        } 
        return this.e1 + "/" + this.e2;
    }

    Frac negative(){
        return new Frac(-e1, e2);
    }

    Frac multiplication(Frac expr){
        return new Frac(this.e1 * expr.e1, this.e2 * expr.e2 );
    }

    Frac division(Frac expr){
        return new Frac(this.e1 * expr.e2, this.e2 * expr.e1 );
    }

    Frac addition(Frac expr){
        return new Frac(this.e1 * expr.e2 + expr.e1 * this.e2, this.e2 * expr.e2 );
    }

    Frac subtration(Frac expr){

        if(this.e1 * expr.e2 - expr.e1 * this.e2 == 0)
            return new Frac(0);
        else
            return new Frac(this.e1 * expr.e2 - expr.e1 * this.e2, this.e2 * expr.e2 );
    }


}
