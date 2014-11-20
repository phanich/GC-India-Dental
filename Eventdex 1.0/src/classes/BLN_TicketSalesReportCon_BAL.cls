/***********************************************************************************************
*   Controller Name : BLN_TicketSalesReportCon_BAL
*   Date            : 10/30/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the PromoCode Report
*   Change History  : 10/30/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*    10/30/2014              Manasa Gandham                 To Create Page
*  
**************************************************************************************************/

public without sharing class BLN_TicketSalesReportCon_BAL{

    public BLN_TicketSalesReportCon_BAL(){
        
    }  
    
    public BLN_Order_DAO ordersDAOClass{get; set;}
    public BLN_Item_DAO ticketsDAOClass{get; set;}
    
    public LIST<ticketsInner> ticketsSalesForEvent(String EventId, Date FromDate, Date ToDate, String SearchString){
        
        ordersDAOClass= new BLN_Order_DAO();
        ticketsDAOClass= new BLN_Item_DAO();
        LIST<order__c> ordersList= new LIST<order__c>();
        String queryString= '';
        queryString= ' where Events__c = \''+EventId+'\'';
        queryString += ' AND Transaction_Status__c = \''+'Completed'+'\'';
        system.debug('  000000000000  '+queryString);        
        ordersList= ordersDAOClass.orderListForEvent(queryString);
        MAP<String, Decimal> itemDiscountMAP= new MAP<String, Decimal>();
        MAP<String, Decimal> itemAmountMAP= new MAP<String, Decimal>();        
        MAP<String, Decimal> itemTotalDiscountMAP= new MAP<String, Decimal>();        
        MAP<String, Decimal> itemTotalAmountMAP= new MAP<String, Decimal>();
        MAP<String, Decimal> itemCountMAP= new MAP<String, Decimal>();
        system.debug(ordersList.size()+'  ORDERS SIZE ');        
        for(order__c order: ordersList){
            system.debug(' 00000000000000 '+order);        
            LIST<Payment__c> PaymentsList= new LIST<Payment__c>();
            PaymentsList= order.Payments__r;
            String paymentTypeString='';
            if(PaymentsList.size() >0){
            if(PaymentsList[0].Payment_Mode__c == 'Check'){
                paymentTypeString= PaymentsList[0].Payment_Mode__c;            
            }else if(PaymentsList[0].Payment_Mode__c == 'MasterCard' || PaymentsList[0].Payment_Mode__c == 'Visa' || PaymentsList[0].Payment_Mode__c == 'Discover' || PaymentsList[0].Payment_Mode__c == 'American Express'){
                paymentTypeString= 'CreditCard';                        
            }
            system.debug(' 11111111111111 '+paymentTypeString);        
            LIST<Order_Item__c> orderItemsList= new LIST<Order_Item__c>();
            orderItemsList= order.Order_Items__r;
            for(Order_Item__c orderItem: orderItemsList){ 
                if(orderItem.Status__c == 'Active'){
                
                    paymentTypeString= orderItem.Item__c+'-'+paymentTypeString;
                    system.debug(' 22222222222222 '+paymentTypeString);        
                    //Assigning Item Payment type Count to MAP                    
                    if(itemCountMAP.containsKey(paymentTypeString)){
                        Decimal itemCount= itemCountMAP.get(paymentTypeString);
                        itemCount= itemCount+orderItem.Item_Quantity__c;
                        itemCountMAP.put(paymentTypeString, itemCount);
                    }else{
                        itemCountMAP.put(paymentTypeString, orderItem.Item_Quantity__c);
                    }
                      
                    //Assiging discount with payment type to MAP
                    if(itemDiscountMAP.containsKey(paymentTypeString)){
                        Decimal discountAmount= itemDiscountMAP.get(paymentTypeString);
                        discountAmount= discountAmount+orderItem.Item_Discount__c;
                        itemDiscountMAP.put(paymentTypeString, discountAmount);
                    }else{
                        itemDiscountMAP.put(paymentTypeString, orderItem.Item_Discount__c);
                    }
                    //Assiging Total Amount with payment type to MAP
                    if(itemAmountMAP.containsKey(paymentTypeString)){
                        Decimal totalAmount= itemAmountMAP.get(paymentTypeString);
                        totalAmount= totalAmount+orderItem.Item_Total__c;
                        itemAmountMAP.put(paymentTypeString, totalAmount);
                    }else{
                        itemAmountMAP.put(paymentTypeString, orderItem.Item_Total__c);
                    }
                    //Assiging Tickets discount to MAP
                    if(itemTotalDiscountMAP.containsKey(orderItem.Item__c)){
                        Decimal discountAmount= itemTotalDiscountMAP.get(orderItem.Item__c);
                        discountAmount= discountAmount+orderItem.Item_Discount__c;
                        itemTotalDiscountMAP.put(orderItem.Item__c, discountAmount);
                    }else{
                        itemTotalDiscountMAP.put(orderItem.Item__c, orderItem.Item_Discount__c);
                    }
                    //Assiging Tickets Total Amount to MAP
                     system.debug(orderItem.Item__c+' 222222222222222 '+itemTotalAmountMAP.containsKey(orderItem.Item__c));        
                     if(itemTotalAmountMAP.containsKey(orderItem.Item__c)){
                        Decimal totalAmount= itemTotalAmountMAP.get(orderItem.Item__c);
                        totalAmount= totalAmount+orderItem.Item_Total__c;
                        itemTotalAmountMAP.put(orderItem.Item__c, totalAmount);
                        system.debug('   44444444   '+itemTotalAmountMAP);
                    }else{
                        itemTotalAmountMAP.put(orderItem.Item__c, orderItem.Item_Total__c);
                        system.debug('  555555555   '+itemTotalAmountMAP);
                    }
                    system.debug(orderItem.Item__c+' 333333333333333 '+itemTotalAmountMAP);            

                }               
                
            }
            }
        
        }
        
        //Getting Tickets List belongs to Event
        LIST<ticketsInner> ticketsInnerList= new LIST<ticketsInner>();
        LIST<BLN_Item__c> itemsList= new LIST<BLN_Item__c>();
        queryString= '';
        queryString= ' where Event__c = \''+EventId+'\'';
        itemsList= ticketsDAOClass.itemsListForEvent(queryString);
        
        Decimal TotalTicketCount= 0;
        Decimal TotalAmount= 0;
        Decimal TotalDiscountAmount= 0;
        
        Decimal TotalCheckTicketCount= 0;
        Decimal TotalCreditCardTicketCount= 0;
        Decimal TotalCheckAmount= 0;
        Decimal TotalCreditCardAmount= 0;
        Decimal TotalCheckDiscountAmount= 0;
        Decimal TotalCreditCardDiscountAmount= 0;
            
        for(BLN_Item__c item: itemsList){
            system.debug('  ITEM ID '+item.Id);
            Decimal usedTicketsCount=0;
            if(itemCountMAP.get(item.Id+'-'+'Check') != NULL){
                usedTicketsCount= itemCountMAP.get(item.Id+'-'+'Check');
            }
            if(itemCountMAP.get(item.Id+'-'+'CreditCard') != NULL){
                usedTicketsCount += itemCountMAP.get(item.Id+'-'+'CreditCard');
            }
            Decimal discountPrice=0;
            Decimal totalPrice= 0;
            if(itemTotalDiscountMAP.get(item.Id) != NULL){
                discountPrice= itemTotalDiscountMAP.get(item.Id);
            }else{
                discountPrice=0;
            }
            
            if(itemTotalAmountMAP.get(item.Id) != NULL){
                totalPrice= itemTotalAmountMAP.get(item.Id);
            }else{
                totalPrice=0;
            }
           
            Decimal CheckTicketCount= 0;
            Decimal CreditCardTicketCount= 0;
            Decimal CheckTotalAmount= 0;
            Decimal CreditCardTotalAmount= 0;
            Decimal CheckDiscountAmount= 0;
            Decimal CreditCardDiscountAmount= 0;
            
            if(itemCountMAP.containsKey(item.Id+'-'+'Check')){
                CheckTicketCount= itemCountMAP.get(item.Id+'-'+'Check');
            }else{
                CheckTicketCount=0;
            }
            if(itemCountMAP.containsKey(item.Id+'-'+'CreditCard')){
                CreditCardTicketCount= itemCountMAP.get(item.Id+'-'+'CreditCard');
            }else{
                CreditCardTicketCount=0;
            }
            
            if(itemDiscountMAP.containsKey(item.Id+'-'+'Check')){
                CheckDiscountAmount= itemDiscountMAP.get(item.Id+'-'+'Check');
            }else{
                CheckDiscountAmount=0;
            }
            
            if(itemDiscountMAP.containsKey(item.Id+'-'+'CreditCard')){
                CreditCardDiscountAmount= itemDiscountMAP.get(item.Id+'-'+'CreditCard');
            }else{
                CreditCardDiscountAmount=0;
            }
            
            if(itemAmountMAP.containsKey(item.Id+'-'+'Check')){
                CheckTotalAmount= itemAmountMAP.get(item.Id+'-'+'Check');
            }else{
                CheckTotalAmount=0;
            }
            
            if(itemAmountMAP.containsKey(item.Id+'-'+'CreditCard')){
                CreditCardTotalAmount= itemAmountMAP.get(item.Id+'-'+'CreditCard');
            }else{
                CreditCardTotalAmount=0;
            }
            TotalTicketCount +=usedTicketsCount;            
            TotalCheckTicketCount += CheckTicketCount;
            TotalCreditCardTicketCount += creditCardTicketCount;
            
            TotalAmount += totalPrice;
            TotalCheckAmount+= CheckTotalAmount;
            TotalCreditCardAmount +=CreditCardTotalAmount;
            TotalDiscountAmount += discountPrice; 
            TotalCheckDiscountAmount+= CheckDiscountAmount;
            TotalCreditCardDiscountAmount+= CreditCardDiscountAmount; 
            system.debug(totalPrice+' DISCOUNT '+discountPrice);           
           system.debug(ticketsInnerList.size()+'    TICKETS INNER LIST '+ticketsInnerList);
            ticketsInnerList.add(new ticketsInner(item, usedTicketsCount, discountPrice, totalPrice, CheckTicketCount, creditCardTicketCount, CheckTotalAmount, CreditCardTotalAmount, CheckDiscountAmount, CreditCardDiscountAmount));
        }
        ticketsInnerList.add(new ticketsInner(new BLN_Item__c(), TotalTicketCount, TotalDiscountAmount, TotalAmount, TotalCheckTicketCount, TotalCreditCardTicketCount, TotalCheckAmount, TotalCreditCardAmount , TotalCheckDiscountAmount, TotalCreditCardDiscountAmount));
        return ticketsInnerList;
    }
    
    
    public class ticketsInner{
        
        public BLN_Item__c ticketData{get; set;}
        public Decimal usedTickets{get; set;}
        public Decimal totalDiscount{get; set;}
        public Decimal totalAmount{get; set;}
        public Decimal checkTicketCount{get; set;}
        public Decimal creditCardTicketCount{get; set;}
        public Decimal checkTotalAmount{get; set;}
        public Decimal creditCardTotalAmount{get; set;}
        public Decimal checkDiscountAmount{get; set;}
        public Decimal creditCardDiscountAmount{get; set;}
       //public LIST<paymentTypeInner> paymentTypeInnerList{get; set;}
        
        public ticketsInner(BLN_Item__c ticketData, Decimal usedTickets, Decimal totalDiscount, Decimal totalAmount, Decimal checkTicketCount, Decimal creditCardTicketCount, Decimal checkTotalAmount, Decimal creditCardTotalAmount, Decimal checkDiscountAmount, Decimal creditCardDiscountAmount){
            this.ticketData= ticketData;
            this.usedTickets= usedTickets;
            this.totalDiscount= totalDiscount;
            this.totalAmount= totalAmount;
            this.checkTicketCount= checkTicketCount;
            this.creditCardTicketCount= creditCardTicketCount;
            this.checkTotalAmount= checkTotalAmount;
            this.creditCardTotalAmount= creditCardTotalAmount;
            this.checkDiscountAmount= checkDiscountAmount;
            this.creditCardDiscountAmount= creditCardDiscountAmount;
            //this.paymentTypeInnerList= paymentTypeInnerList;
        }
    }
    
    /*
    public class paymentTypeInner{
        
        public String paymentType{get; set;}
        public Decimal ticketCount{get; set;}
        public Decimal typeDiscountPrice{get; set;}
        public Decimal typeTotalAmount{get; set;}
                
        public paymentTypeInner(String paymentType, Decimal ticketCount, Decimal typeDiscountPrice, Decimal typeTotalAmount){
            
            this.paymentType= paymentType;
            this.ticketCount= ticketCount;
            this.typeDiscountPrice= typeDiscountPrice;
            this.typeTotalAmount= typeTotalAmount;
        }
    
    }
    */
    
    
    }