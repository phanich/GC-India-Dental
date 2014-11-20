public with sharing class StaticTestCon2 {

    public static integer StaticTestCon2Static=10;
    
    public StaticTestCon2(){
    	StaticTestCon2Static = 10;
    }
    
    
    public static integer giveVal(){
       
        StaticTestCon2Static += 1;
        
        return StaticTestCon2Static;
    }

    
     

}