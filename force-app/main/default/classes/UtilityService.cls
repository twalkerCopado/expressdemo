/**
 * @description Utility service with common helper methods
 * @author Copado AI Platform
 * @date 2026-03-30
 */
public with sharing class UtilityService {
    
    /**
     * @description Converts a list to a set
     * @param inputList List to convert
     * @return Set of values
     */
    public static Set<Id> listToSet(List<Id> inputList) {
        return new Set<Id>(inputList);
    }
    
    /**
     * @description Checks if a string is blank or null
     * @param value String to check
     * @return True if blank or null
     */
    public static Boolean isBlank(String value) {
        return String.isBlank(value);
    }
    
    /**
     * @description Formats a decimal value to specified decimal places
     * @param value Decimal value to format
     * @param decimalPlaces Number of decimal places
     * @return Formatted decimal
     */
    public static Decimal formatDecimal(Decimal value, Integer decimalPlaces) {
        if (value == null) {
            return 0;
        }
        return value.setScale(decimalPlaces, RoundingMode.HALF_UP);
    }
    
    /**
     * @description Calculates percentage
     * @param part Part value
     * @param total Total value
     * @return Percentage value
     */
    public static Decimal calculatePercentage(Decimal part, Decimal total) {
        if (total == null || total == 0) {
            return 0;
        }
        return (part / total) * 100;
    }
    
    /**
     * @description Gets current user information
     * @return User information wrapper
     */
    public static CurrentUserInfo getCurrentUserInfo() {
        CurrentUserInfo info = new CurrentUserInfo();
        info.userId = UserInfo.getUserId();
        info.userName = UserInfo.getUserName();
        info.userEmail = UserInfo.getUserEmail();
        info.profileId = UserInfo.getProfileId();
        return info;
    }
    
    /**
     * @description Checks if current user has specified permission
     * @param permissionName Permission API name
     * @return True if user has permission
     */
    public static Boolean hasPermission(String permissionName) {
        return FeatureManagement.checkPermission(permissionName);
    }
    
    /**
     * @description Generates a unique identifier
     * @return Unique string identifier
     */
    public static String generateUniqueId() {
        return String.valueOf(Crypto.getRandomLong()) + String.valueOf(System.now().getTime());
    }
    
    /**
     * @description Parses JSON string to map
     * @param jsonString JSON string to parse
     * @return Map of string to object
     */
    public static Map<String, Object> parseJsonToMap(String jsonString) {
        try {
            return (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error parsing JSON: ' + e.getMessage());
            return new Map<String, Object>();
        }
    }
    
    /**
     * @description Converts map to JSON string
     * @param dataMap Map to convert
     * @return JSON string
     */
    public static String mapToJson(Map<String, Object> dataMap) {
        try {
            return JSON.serialize(dataMap);
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error converting to JSON: ' + e.getMessage());
            return '{}';
        }
    }
    
    /**
     * @description Wrapper class for user information
     */
    public class CurrentUserInfo {
        public Id userId { get; set; }
        public String userName { get; set; }
        public String userEmail { get; set; }
        public Id profileId { get; set; }
    }
}