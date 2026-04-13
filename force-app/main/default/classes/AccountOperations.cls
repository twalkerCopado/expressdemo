public class AccountOperations {
    Public static Account setDefaultDescription(Account a){
        If (a.Description != null) return a;
        Else {
            a.Description = 'Default description';
            return a;
        }
    }
       //New methods introduced by Developer 1 working on the US-001 
    public static Account setDefaultBillingAddress(Account a){//DEV 1
        a.billingstreet = '123 Masuri'; // DEV 3 updates 
        a.billingstate = 'Espana';
        a.billingpostalcode ='12345'; // DEV 3 updates
        return a;
    }
    public static Account setDefaultShippingAddress(Account a){//DEV 1
        a.shippingstreet = '535 Mission Street'; // DEV 2 updates 
        a.shippingstate = 'California';
        a.shippingpostalcode ='94105'; // DEV 2 updates
        return a;
    }
    public static Account setDefaultPhone(Account a) {//DEV 1
        a.Phone='998887777'; // DEV 3 updates
        return a;
    }
    public static Account setDefaultURL(Account a) { //DEV 1
        a.website = 'www.copado.com'; // DEV 2 updates
        return a;
    }
}