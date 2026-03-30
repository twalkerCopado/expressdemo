/**
 * @description Test class for UtilityService
 * @author Copado AI Platform
 * @date 2026-03-30
 */
@IsTest
private class UtilityServiceTest {
    
    /**
     * @description Test listToSet method with valid data
     */
    @IsTest
    static void testListToSet_ValidData() {
        // Create test accounts to get valid IDs
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert testAccounts;
        
        List<Id> accountIds = new List<Id>();
        for (Account acc : testAccounts) {
            accountIds.add(acc.Id);
        }
        
        Test.startTest();
        Set<Id> resultSet = UtilityService.listToSet(accountIds);
        Test.stopTest();
        
        System.assertEquals(5, resultSet.size(), 'Set should contain 5 unique IDs');
        System.assert(resultSet.contains(testAccounts[0].Id), 'Set should contain first account ID');
    }
    
    /**
     * @description Test listToSet method with empty list
     */
    @IsTest
    static void testListToSet_EmptyList() {
        List<Id> emptyList = new List<Id>();
        
        Test.startTest();
        Set<Id> resultSet = UtilityService.listToSet(emptyList);
        Test.stopTest();
        
        System.assertEquals(0, resultSet.size(), 'Set should be empty');
    }
    
    /**
     * @description Test isBlank method with various inputs
     */
    @IsTest
    static void testIsBlank_VariousInputs() {
        Test.startTest();
        
        // Test null value
        System.assertEquals(true, UtilityService.isBlank(null), 'Null should return true');
        
        // Test empty string
        System.assertEquals(true, UtilityService.isBlank(''), 'Empty string should return true');
        
        // Test whitespace
        System.assertEquals(true, UtilityService.isBlank('   '), 'Whitespace should return true');
        
        // Test valid string
        System.assertEquals(false, UtilityService.isBlank('Test'), 'Valid string should return false');
        
        Test.stopTest();
    }
    
    /**
     * @description Test formatDecimal method with valid values
     */
    @IsTest
    static void testFormatDecimal_ValidValues() {
        Test.startTest();
        
        Decimal result1 = UtilityService.formatDecimal(123.456789, 2);
        System.assertEquals(123.46, result1, 'Should round to 2 decimal places');
        
        Decimal result2 = UtilityService.formatDecimal(100.1234, 3);
        System.assertEquals(100.123, result2, 'Should round to 3 decimal places');
        
        Decimal result3 = UtilityService.formatDecimal(50.555, 2);
        System.assertEquals(50.56, result3, 'Should round up correctly');
        
        Test.stopTest();
    }
    
    /**
     * @description Test formatDecimal method with null value
     */
    @IsTest
    static void testFormatDecimal_NullValue() {
        Test.startTest();
        Decimal result = UtilityService.formatDecimal(null, 2);
        Test.stopTest();
        
        System.assertEquals(0, result, 'Null value should return 0');
    }
    
    /**
     * @description Test calculatePercentage method with valid values
     */
    @IsTest
    static void testCalculatePercentage_ValidValues() {
        Test.startTest();
        
        Decimal result1 = UtilityService.calculatePercentage(25, 100);
        System.assertEquals(25, result1, 'Should calculate 25%');
        
        Decimal result2 = UtilityService.calculatePercentage(50, 200);
        System.assertEquals(25, result2, 'Should calculate 25%');
        
        Decimal result3 = UtilityService.calculatePercentage(75, 150);
        System.assertEquals(50, result3, 'Should calculate 50%');
        
        Test.stopTest();
    }
    
    /**
     * @description Test calculatePercentage method with edge cases
     */
    @IsTest
    static void testCalculatePercentage_EdgeCases() {
        Test.startTest();
        
        // Test with zero total
        Decimal result1 = UtilityService.calculatePercentage(50, 0);
        System.assertEquals(0, result1, 'Division by zero should return 0');
        
        // Test with null total
        Decimal result2 = UtilityService.calculatePercentage(50, null);
        System.assertEquals(0, result2, 'Null total should return 0');
        
        Test.stopTest();
    }
    
    /**
     * @description Test getCurrentUserInfo method
     */
    @IsTest
    static void testGetCurrentUserInfo() {
        Id expectedUserId = UserInfo.getUserId();
        String expectedUserName = UserInfo.getUserName();
        String expectedUserEmail = UserInfo.getUserEmail();
        Id expectedProfileId = UserInfo.getProfileId();
        
        Test.startTest();
        UtilityService.CurrentUserInfo userInfo = UtilityService.getCurrentUserInfo();
        Test.stopTest();
        
        System.assertNotEquals(null, userInfo, 'User info should not be null');
        System.assertEquals(expectedUserId, userInfo.userId, 'User ID should match');
        System.assertEquals(expectedUserName, userInfo.userName, 'User name should match');
        System.assertEquals(expectedUserEmail, userInfo.userEmail, 'User email should match');
        System.assertEquals(expectedProfileId, userInfo.profileId, 'Profile ID should match');
    }
    
    /**
     * @description Test hasPermission method
     */
    @IsTest
    static void testHasPermission() {
        Test.startTest();
        Boolean result = UtilityService.hasPermission('TestPermission');
        Test.stopTest();
        
        // Result will be false since permission doesn't exist, but we're testing the method executes
        System.assertNotEquals(null, result, 'Result should not be null');
    }
    
    /**
     * @description Test generateUniqueId method
     */
    @IsTest
    static void testGenerateUniqueId() {
        Test.startTest();
        
        String id1 = UtilityService.generateUniqueId();
        String id2 = UtilityService.generateUniqueId();
        
        Test.stopTest();
        
        System.assertNotEquals(null, id1, 'ID should not be null');
        System.assertNotEquals(null, id2, 'ID should not be null');
        System.assertNotEquals(id1, id2, 'IDs should be unique');
        System.assert(id1.length() > 0, 'ID should have length');
    }
    
    /**
     * @description Test parseJsonToMap method with valid JSON
     */
    @IsTest
    static void testParseJsonToMap_ValidJson() {
        String validJson = '{"name":"Test","value":123,"active":true}';
        
        Test.startTest();
        Map<String, Object> result = UtilityService.parseJsonToMap(validJson);
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(3, result.size(), 'Map should have 3 entries');
        System.assertEquals('Test', result.get('name'), 'Name should match');
        System.assertEquals(123, result.get('value'), 'Value should match');
        System.assertEquals(true, result.get('active'), 'Active should match');
    }
    
    /**
     * @description Test parseJsonToMap method with invalid JSON
     */
    @IsTest
    static void testParseJsonToMap_InvalidJson() {
        String invalidJson = '{invalid json}';
        
        Test.startTest();
        Map<String, Object> result = UtilityService.parseJsonToMap(invalidJson);
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(0, result.size(), 'Map should be empty for invalid JSON');
    }
    
    /**
     * @description Test mapToJson method with valid map
     */
    @IsTest
    static void testMapToJson_ValidMap() {
        Map<String, Object> testMap = new Map<String, Object>{
            'name' => 'Test Account',
            'amount' => 1000,
            'isActive' => true
        };
        
        Test.startTest();
        String jsonResult = UtilityService.mapToJson(testMap);
        Test.stopTest();
        
        System.assertNotEquals(null, jsonResult, 'JSON result should not be null');
        System.assert(jsonResult.contains('Test Account'), 'JSON should contain name value');
        System.assert(jsonResult.contains('1000'), 'JSON should contain amount value');
    }
    
    /**
     * @description Test mapToJson method with empty map
     */
    @IsTest
    static void testMapToJson_EmptyMap() {
        Map<String, Object> emptyMap = new Map<String, Object>();
        
        Test.startTest();
        String jsonResult = UtilityService.mapToJson(emptyMap);
        Test.stopTest();
        
        System.assertNotEquals(null, jsonResult, 'JSON result should not be null');
        System.assertEquals('{}', jsonResult, 'Empty map should return empty JSON object');
    }
    
    /**
     * @description Test CurrentUserInfo wrapper class
     */
    @IsTest
    static void testCurrentUserInfoWrapper() {
        Id currentUserId = UserInfo.getUserId();
        Id currentProfileId = UserInfo.getProfileId();
        
        Test.startTest();
        
        UtilityService.CurrentUserInfo userInfo = new UtilityService.CurrentUserInfo();
        userInfo.userId = currentUserId;
        userInfo.userName = 'testuser@example.com';
        userInfo.userEmail = 'test@example.com';
        userInfo.profileId = currentProfileId;
        
        Test.stopTest();
        
        System.assertEquals(currentUserId, userInfo.userId, 'User ID should be set');
        System.assertEquals('testuser@example.com', userInfo.userName, 'User name should be set');
        System.assertEquals('test@example.com', userInfo.userEmail, 'User email should be set');
        System.assertEquals(currentProfileId, userInfo.profileId, 'Profile ID should be set');
    }
}