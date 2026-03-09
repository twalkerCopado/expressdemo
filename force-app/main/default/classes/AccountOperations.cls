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
        a.shippingstreet = '123 Masuri'; // DEV 3 updates 
        a.shippingstate = 'Espana';
        a.shippingpostalcode ='12345'; // DEV 3 updates
        return a;
    }
    public static Account setDefaultPhone(Account a) {//DEV 1
        a.Phone='666777888'; // DEV 2 updates
        return a;
    }
    public static Account setDefaultURL(Account a) { //DEV 1
        a.website = 'www.copado.com'; // DEV 2 updates
        return a;
    }
}