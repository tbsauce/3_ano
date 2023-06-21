class Frac{
    int e1;
    int e2;

    Frac(int e1,int e2){
        this.e1 = e1;
        this.e2= e2;
    }

    Frac(int e1){
        this.e1 = e1;
        this.e2= 1;
    }

    static Frac add(Frac f1, Frac f2){
        return new Frac((f1.e1*f2.e2) + (f2.e1*f1.e2), f1.e2*f2.e2);
    }

    static Frac sub(Frac f1, Frac f2){
        return new Frac((f1.e1*f2.e2) - (f2.e1*f1.e2), f1.e2*f2.e2);
    }

    static Frac mult(Frac f1, Frac f2){
        return new Frac(f1.e1*f2.e1, f1.e2*f2.e2);
    }

    static Frac div(Frac f1, Frac f2){
        return new Frac(f1.e1*f2.e1, f1.e2*f2.e1);
    }

    static Frac unitaryNegative(Frac f1){
        return new Frac(-f1.e1, f1.e2);
    }

    static  Frac reduce(Frac f) {
        int n = mdc(f.e1, f.e2);
        return new Frac(f.e1/n, f.e2/n);
    }

    static  int mdc(int a, int b) {
        if (b == 0) return a;
        return mdc(b, a%b);
    }

    @Override
    public String toString() {
        if(this.e2 == 1)
            return ""+this.e1;
        return this.e1 + "/" + this.e2;
    }

}