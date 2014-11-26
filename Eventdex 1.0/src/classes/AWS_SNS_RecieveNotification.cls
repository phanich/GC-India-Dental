@RestResource(urlMapping='/AWS_SNS_RecieveNotification')
global class AWS_SNS_RecieveNotification {
@HttpGet
global static void doGet() {
    RestContext.response.addHeader('Content-Type', 'text/plain');
    //String name = RestContext.request.params.get('name');
    
    
    RestContext.response.addHeader('client_id','3MVG9GiqKapCZBwHzyHJ_RnuesB4SLhNhSBC2Z6JIKEf1j1sSRhMHoxf6h0U4nxZqJafm89IR74G3PQCDzrZy');
    RestContext.response.addHeader('client_secret','835319979606089662');
    RestContext.response.addHeader('username','sfadmin@globalnest.com');
    RestContext.response.addHeader('password','Administrator@123yYsXgJo6B7mrL6GvURrhlMFQ');
    
  }
}