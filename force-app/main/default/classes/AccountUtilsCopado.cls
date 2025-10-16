public with sharing class AccountUtilsCopado {
    
    /**
     * ---------------------------------------------------------------------------
     * Author:      Demo User
     * Company:     ACME Corporation
     * Description: Updates the contact count for a list of accounts
     * Inputs:      List<Account> accounts - List of accounts to update
     * Returns:     void
     * 
     * Date         Author              Brief Description of Change  
     * -----------  ----------------    --------------------------------
     * 16-Oct-2024  Demo User           Initial version of the code
     * ---------------------------------------------------------------------------
     */
    public static void updateContactCount(List<Account> accounts) {
        
        if (accounts == null || accounts.isEmpty()) {
            System.debug('updateContactCount called with null or empty account list');
            return;
        }
        
        try {
            System.debug('Starting contact count update for ' + accounts.size() + ' accounts');
            
            // Collect account IDs for bulk processing
            Set<Id> accountIds = new Set<Id>();
            for (Account acc : accounts) {
                if (acc.Id != null) {
                    accountIds.add(acc.Id);
                }
            }
            
            if (accountIds.isEmpty()) {
                System.debug('No valid account IDs found for contact count update');
                return;
            }
            
            // Query contact counts for all accounts in a single SOQL query
            Map<Id, Integer> accountContactCounts = new Map<Id, Integer>();
            
            for (AggregateResult ar : [
                SELECT AccountId, COUNT(Id) contactCount 
                FROM Contact 
                WHERE AccountId IN :accountIds 
                GROUP BY AccountId
            ]) {
                accountContactCounts.put((Id)ar.get('AccountId'), (Integer)ar.get('contactCount'));
            }
            
            // Update accounts with contact counts
            List<Account> accountsToUpdate = new List<Account>();
            for (Account acc : accounts) {
                if (acc.Id != null) {
                    Integer contactCount = accountContactCounts.get(acc.Id);
                    acc.NumberOfEmployees = contactCount != null ? contactCount : 0;
                    accountsToUpdate.add(acc);
                }
            }
            
            // Perform bulk DML operation outside the loop
            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
                System.debug('Successfully updated contact count for ' + accountsToUpdate.size() + ' accounts');
            }
            
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in updateContactCount: ' + e.getMessage());
            throw e;
        }
    }
    
    /**
     * ---------------------------------------------------------------------------
     * Author:      Demo User
     * Company:     ACME Corporation
     * Description: Validates account types and sets appropriate industry values
     * Inputs:      List<Account> accounts - List of accounts to validate
     * Returns:     Boolean - true if all validations pass
     * 
     * Date         Author              Brief Description of Change  
     * -----------  ----------------    --------------------------------
     * 16-Oct-2024  Demo User           Initial version of the code
     * ---------------------------------------------------------------------------
     */
    public static Boolean validateAccountTypes(List<Account> accounts) {
        
        if (accounts == null || accounts.isEmpty()) {
            System.debug('validateAccountTypes called with null or empty account list');
            return false;
        }
        
        try {
            System.debug('Starting account type validation for ' + accounts.size() + ' accounts');
            
            Boolean allValid = true;
            
            for (Account acc : accounts) {
                
                // Validate account type
                if (String.isBlank(acc.Type)) {
                    acc.Type = 'Prospect';
                    System.debug('Set default type for account: ' + acc.Name);
                }
                
                // Set industry based on type
                if (acc.Type == 'Customer - Direct' || acc.Type == 'Customer - Channel') {
                    if (String.isBlank(acc.Industry)) {
                        acc.Industry = 'Technology';
                        System.debug('Set default industry for customer account: ' + acc.Name);
                    }
                }
                
                // Validate required fields for customers
                if (acc.Type.startsWith('Customer') && String.isBlank(acc.Phone)) {
                    System.debug(LoggingLevel.WARN, 'Customer account missing phone number: ' + acc.Name);
                    allValid = false;
                }
            }
            
            System.debug('Account type validation completed. All valid: ' + allValid);
            return allValid;
            
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in validateAccountTypes: ' + e.getMessage());
            throw e;
        }
    }
    
    /**
     * ---------------------------------------------------------------------------
     * Author:      Demo User
     * Company:     ACME Corporation
     * Description: Gets account summary information for reporting
     * Inputs:      Set<Id> accountIds - Set of account IDs to summarize
     * Returns:     Map<Id, String> - Map of account ID to summary string
     * 
     * Date         Author              Brief Description of Change  
     * -----------  ----------------    --------------------------------
     * 16-Oct-2024  Demo User           Initial version of the code
     * ---------------------------------------------------------------------------
     */
    public static Map<Id, String> getAccountSummaries(Set<Id> accountIds) {
        
        Map<Id, String> summaryMap = new Map<Id, String>();
        
        if (accountIds == null || accountIds.isEmpty()) {
            System.debug('getAccountSummaries called with null or empty account ID set');
            return summaryMap;
        }
        
        try {
            System.debug('Generating summaries for ' + accountIds.size() + ' accounts');
            
            // Query accounts with related data in a single query
            List<Account> accounts = [
                SELECT Id, Name, Type, Industry, NumberOfEmployees, 
                       (SELECT Id FROM Contacts LIMIT 1)
                FROM Account 
                WHERE Id IN :accountIds
                LIMIT 200
            ];
            
            for (Account acc : accounts) {
                String summary = acc.Name + ' (' + 
                               (acc.Type != null ? acc.Type : 'No Type') + ')';
                
                if (acc.Industry != null) {
                    summary += ' - ' + acc.Industry;
                }
                
                if (acc.NumberOfEmployees != null) {
                    summary += ' - ' + acc.NumberOfEmployees + ' employees';
                }
                
                if (!acc.Contacts.isEmpty()) {
                    summary += ' - Has contacts';
                }
                
                summaryMap.put(acc.Id, summary);
            }
            
            System.debug('Generated ' + summaryMap.size() + ' account summaries');
            
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in getAccountSummaries: ' + e.getMessage());
            throw e;
        }
        
        return summaryMap;
    }
}