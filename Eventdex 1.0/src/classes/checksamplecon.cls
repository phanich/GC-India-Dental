public with sharing class checksamplecon {

    public LIST<SelectOption> Answers{get;set;}
    public String[] SelectedAnswer{get;set;}
   

    
    public checksamplecon(){
        SelectedAnswer = new String[]{};
        Answers = new LIST<SelectOption>();
        Answers.add(new SelectOption('1','Checkbox1'));
        Answers.add(new SelectOption('2','Checkbox2'));
        Answers.add(new SelectOption('3','Checkbox3'));
    }
    
    public void checkMethod(){
        system.debug('Checked Values '+SelectedAnswer);
    }
}