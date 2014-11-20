public class StaticTestCon {
    
    public  integer showProof{get; set;}
    
    public StaticTestCon(){
        showProof = StaticTestCon2.StaticTestCon2Static;
    
    }
    
    
    public void addOneMore(){
        
        StaticTestCon2.StaticTestCon2Static = showProof  + 1 ;
        
      showProof = StaticTestCon2.StaticTestCon2Static;
        
    }



}