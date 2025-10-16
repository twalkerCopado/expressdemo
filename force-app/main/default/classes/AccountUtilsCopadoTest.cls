/**
 * ---------------------------------------------------------------------------
 * Name:        AccountUtilsCopadoTest.cls
 * Description: Test class for AccountUtilsCopado utility class
 *              Provides 100% code coverage with positive and negative test cases
 *                 
 * Date         Version    Author          Tag         Summary of Changes  
 * -----------  -------    -----------     -----       ------------------
 * 16-Oct-2024  0.1        Demo User       None        Initial draft
 * ---------------------------------------------------------------------------
 */
@isTest
private class AccountUtilsCopadoTest {
    
    /**
     * ---------------------------------------------------------------------------
     * Author:      Demo User
     * Company:     ACME Corporation
     * Description: Creates test data for account utility tests
     * Inputs:      None
     * Returns:     List<Account> - List of test accounts
     * 
     * Date         Author              Brief Description of Change  
     * -----------  ----------------    --------------------------------
     * 16-Oct-2024  Demo User           Initial version of the code
     * ---------------------------------------------------------------------------
     */
    @TestSetup
    static void setupTestData() {
        
        // Create test accounts with different types
        List<Account> testAccounts = new List<Account>();
        
        testAccounts.add(new Account(
            Name = 'Test Customer Account',
            Type = 'Customer - Direct',
            Industry = 'Technology',
            Phone = '555-123-4567'
        ));
        
        testAccounts.add(new Account(
            Name = 'Test Prospect Account',
            Type = 'Prospect',
            Industry = 'Healthcare'
        ));
        
        testAccounts.add(new Account(
            Name = 'Test Partner Account',
            Type = 'Partner',
            Phone = '555-987-6543'
        ));
        
        insert testAccounts;
        
        // Create test contacts for the first account
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            testContacts.add(new Contact(
                FirstName = 'Test',
                LastName = 'Contact ' + i,
                AccountId = testAccounts[0].Id,
                Email = 'test' + i + '@example.com'
            ));
        }
        
        insert testContacts;
    }
    
    /**
     * ---------------------------------------------------------------------------
     * Author:      Demo User
     * Company:     ACME Corporation
     * Description: Tests updateContactCount method with valid accounts
     * Inputs:      None
     * Returns:     void
     * 
     * Date         Author              Brief Description of Change  
     * -----------  ----------------    --------------------------------
     * 16-Oct-2024  Demo User           Initial version of the code
     * ---------------------------------------------------------------------------
     */
    @isTest
    static void testUpdateContactCountPositive() {
        
        Test.startTest();
        
        // Get test accounts
        List<Account> accounts = [SELECT Id, Name, NumberOfEmployees FROM Account];
        
        // Call the method under test
        AccountUtilsCopado.updateContactCount(accounts);
        
        Test.stopTest();
        
        // Verify results
        List<Account> updatedAccounts = [SELECT Id, Name, NumberOfEmployees FROM Account ORDER BY Name];
        
        // First account should have 3 contacts
        System.assertEquals(3, updatedAccounts[0].NumberOfEmployees, 
                          'Customer account should have 3 contacts');
        
        // Other accounts should have 0 contacts
        System.assertEquals(0, updatedAccounts[1].NumberOfEmployees, 
                          'Partner account should have 0 contacts');
        System.assertEquals(0, updatedAccounts[2].NumberOfEmployees, 
                          'Prospect account should have 0 contacts');
    }
    
    /**
     * ---------------------------------------------------------------------------
     * Author:      Demo User
     * Company:     ACME Corporation
     * Description: Tests updateContactCount method with null and empty inputs
     * Inputs:      None
     * Returns:     void
     * 
     * Date         Author              Brief Description of Change  
     * -----------  ----------------    --------------------------------
     * 16-Oct-2024  Demo User           Initial version of the code
     * ---------------------------------------------------------------------------
     */
    @isTest
    static void testUpdateContactCountNegative() {
        
        Test.startTest();
        
        // Test with null input
        AccountUtilsCopado.updateContactCount(null);
        
        // Test with empty list
        AccountUtilsCopado.updateContactCount(new List<Account>());
        
        // Test with accounts without IDs
        List<Account> accountsWithoutIds = new List<Account>();
        accountsWithoutIds.add(new Account(Name = 'Test Account'));
        AccountUtilsCopado.updateContactCount(accountsWithoutIds);
        
        Test.stopTest();
        
        // No exceptions should be thrown and method should handle gracefully
        System.assert(true, 'Method should handle null and empty inputs gracefully');
    }
    
    /**
     * ---------------------------------------------------------------------------
     * Author:      Demo User
     * Company:     ACME Corporation
     * Description: Tests validateAccountTypes method with various account types
     * Inputs:      None
     * Returns:     void
     * 
     * Date         Author              Brief Description of Change  
     * -----------  ----------------    --------------------------------
     * 16-Oct-2024  Demo User           Initial version of the code
     * ---------------------------------------------------------------------------
     */
    @isTest
    static void testValidateAccountTypesPositive() {
        
        Test.startTest();
        
        // Create accounts with different scenarios
        List<Account> testAccounts = new List<Account>();
        
        // Account without type (should get default)
        testAccounts.add(new Account(Name = 'No Type Account'));
        
        // Customer account without industry (should get default)
        testAccounts.add(new Account(
            Name = 'Customer No Industry',
            Type = 'Customer - Direct',
            Phone = '555-111-2222'
        ));
        
        // Valid customer account
        testAccounts.add(new Account(
            Name = 'Valid Customer',
            Type = 'Customer - Channel',
            Industry = 'Finance',
            Phone = '555-333-4444'
        ));
        
        // Call the method under test
        Boolean result = AccountUtilsCopado.validateAccountTypes(testAccounts);
        
        Test.stopTest();
        
        // Verify results
        System.assertEquals(true, result, 'All accounts should be valid');
        System.assertEquals('Prospect', testAccounts[0].Type, 'Default type should be set');
        System.assertEquals('Technology', testAccounts[1].Industry, 'Default industry should be set');
        System.assertEquals('Finance', testAccounts[2].Industry, 'Existing industry should be preserved');
    }
    
    /**
     * ---------------------------------------------------------------------------
     * Author:      Demo User
     * Company:     ACME Corporation
     * Description: Tests validateAccountTypes method with invalid data
     * Inputs:      None
     * Returns:     void
     * 
     * Date         Author              Brief Description of Change  
     * -----------  ----------------    --------------------------------
     * 16-Oct-2024  Demo User           Initial version of the code
     * ---------------------------------------------------------------------------
     */
    @isTest
    static void testValidateAccountTypesNegative() {
        
        Test.startTest();
        
        // Test with null input
        Boolean nullResult = AccountUtilsCopado.validateAccountTypes(null);
        System.assertEquals(false, nullResult, 'Null input should return false');
        
        // Test with empty list
        Boolean emptyResult = AccountUtilsCopado.validateAccountTypes(new List<Account>());
        System.assertEquals(false, emptyResult, 'Empty list should return false');
        
        // Test with customer account missing phone
        List<Account> invalidAccounts = new List<Account>();
        invalidAccounts.add(new Account(
            Name = 'Invalid Customer',
            Type = 'Customer - Direct'
            // Missing phone number
        ));
        
        Boolean invalidResult = AccountUtilsCopado.validateAccountTypes(invalidAccounts);
        
        Test.stopTest();
        
        System.assertEquals(false, invalidResult, 'Customer without phone should be invalid');
    }
    
    /**
     * ---------------------------------------------------------------------------
     * Author:      Demo User
     * Company:     ACME Corporation
     * Description: Tests getAccountSummaries method with valid account IDs
     * Inputs:      None
     * Returns:     void
     * 
     * Date         Author              Brief Description of Change  
     * -----------  ----------------    --------------------------------
     * 16-Oct-2024  Demo User           Initial version of the code
     * ---------------------------------------------------------------------------
     */
    @isTest
    static void testGetAccountSummariesPositive() {
        
        Test.startTest();
        
        // Get test account IDs
        List<Account> accounts = [SELECT Id FROM Account];
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        
        // Call the method under test
        Map<Id, String> summaries = AccountUtilsCopado.getAccountSummaries(accountIds);
        
        Test.stopTest();
        
        // Verify results
        System.assertEquals(3, summaries.size(), 'Should return summaries for all 3 accounts');
        
        // Check that summaries contain expected information
        for (String summary : summaries.values()) {
            System.assert(summary.contains('Test'), 'Summary should contain account name');
            System.assert(summary.contains('('), 'Summary should contain account type in parentheses');
        }
    }
    
    /**
     * ---------------------------------------------------------------------------
     * Author:      Demo User
     * Company:     ACME Corporation
     * Description: Tests getAccountSummaries method with null and empty inputs
     * Inputs:      None
     * Returns:     void
     * 
     * Date         Author              Brief Description of Change  
     * -----------  ----------------    --------------------------------
     * 16-Oct-2024  Demo User           Initial version of the code
     * ---------------------------------------------------------------------------
     */
    @isTest
    static void testGetAccountSummariesNegative() {
        
        Test.startTest();
        
        // Test with null input
        Map<Id, String> nullResult = AccountUtilsCopado.getAccountSummaries(null);
        System.assertEquals(0, nullResult.size(), 'Null input should return empty map');
        
        // Test with empty set
        Map<Id, String> emptyResult = AccountUtilsCopado.getAccountSummaries(new Set<Id>());
        System.assertEquals(0, emptyResult.size(), 'Empty set should return empty map');
        
        Test.stopTest();
        
        System.assert(true, 'Method should handle null and empty inputs gracefully');
    }
    
    /**
     * ---------------------------------------------------------------------------
     * Author:      Demo User
     * Company:     ACME Corporation
     * Description: Tests bulk processing capabilities of all methods
     * Inputs:      None
     * Returns:     void
     * 
     * Date         Author              Brief Description of Change  
     * -----------  ----------------    --------------------------------
     * 16-Oct-2024  Demo User           Initial version of the code
     * ---------------------------------------------------------------------------
     */
    @isTest
    static void testBulkProcessing() {
        
        Test.startTest();
        
        // Create a larger set of test accounts for bulk testing
        List<Account> bulkAccounts = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            bulkAccounts.add(new Account(
                Name = 'Bulk Test Account ' + i,
                Type = 'Prospect',
                Industry = 'Technology'
            ));
        }
        
        insert bulkAccounts;
        
        // Test bulk validation
        Boolean validationResult = AccountUtilsCopado.validateAccountTypes(bulkAccounts);
        System.assertEquals(true, validationResult, 'Bulk validation should succeed');
        
        // Test bulk contact count update
        AccountUtilsCopado.updateContactCount(bulkAccounts);
        
        // Test bulk summary generation
        Set<Id> bulkAccountIds = new Set<Id>();
        for (Account acc : bulkAccounts) {
            bulkAccountIds.add(acc.Id);
        }
        
        Map<Id, String> bulkSummaries = AccountUtilsCopado.getAccountSummaries(bulkAccountIds);
        
        Test.stopTest();
        
        System.assertEquals(50, bulkSummaries.size(), 'Should handle bulk processing correctly');
    }
    
    /**
     * ---------------------------------------------------------------------------
     * Author:      Demo User
     * Company:     ACME Corporation
     * Description: Tests exception handling in updateContactCount method
     * Inputs:      None
     * Returns:     void
     * 
     * Date         Author              Brief Description of Change  
     * -----------  ----------------    --------------------------------
     * 16-Oct-2024  Demo User           Initial version of the code
     * ---------------------------------------------------------------------------
     */
    @isTest
    static void testUpdateContactCountException() {
        
        Test.startTest();
        
        // Create an account with an invalid ID to trigger an exception
        List<Account> invalidAccounts = new List<Account>();
        Account invalidAccount = new Account(Name = 'Test Account');
        invalidAccount.Id = '001000000000000'; // Invalid ID format
        invalidAccounts.add(invalidAccount);
        
        try {
            AccountUtilsCopado.updateContactCount(invalidAccounts);
            System.assert(false, 'Exception should have been thrown');
        } catch (Exception e) {
            System.assert(true, 'Exception was properly thrown and handled');
        }
        
        Test.stopTest();
    }
}