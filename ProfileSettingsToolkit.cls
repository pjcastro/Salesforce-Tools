public with sharing Class ProfileSettingsToolkit {

    // Get permissions from all sobject fields associated to an specific user profile
    // and export that list to a csv file
    public class checkFieldLevelSecurity() {
        String profileName = 'Your profile name';

        Profile profileId = [SELECT Id FROM Profile WHERE Name =: profileName];
        String pid = String.valueOf(profileId.Id);
        
        PermissionSet permissionSetId = [SELECT Id FROM PermissionSet WHERE ProfileId =: pid];
        String psid = String.valueOf(permissionSetId.Id);
        
        List<FieldPermissions> fieldPermissionsList = [SELECT SobjectType, Field, PermissionsRead, PermissionsEdit FROM FieldPermissions WHERE ParentId =: psid];
        
        List<String> csvRowValues = new List<String>();
        for (FieldPermissions field : fieldPermissionsList) {
            String rowStr = field.SobjectType + ', ' +  field.Field + ', '+ field.PermissionsRead + ', ' + field.PermissionsEdit;
            csvRowValues.add(rowStr);
        }
        
        String documentName = 'Field-Level-Security-'+ Datetime.now().format('MMM') + Datetime.now().year();
        String csvColumnHeader = 'Sobject, Field, Read, Edit\n';
        String csvContent = csvColumnHeader + String.join(csvRowValues,'\n');
        
        Blob versionData = Blob.valueOf(csvContent);
        ContentVersion csvFile = new ContentVersion();
        csvFile.ContentLocation = 'S';
        csvFile.PathOnClient = documentName + '.csv';
        csvFile.Title = documentName;
        csvFile.VersionData = versionData;
        insert csvFile;
        
        System.debug('Generated CSV: ' + csvFile.Id);
    }

    // Get permissions from all sobjects associated to an specific user profile
    // and export that list to a csv file
    public class checkObjectLevelSecurity() {
        String profileName = 'Your profile name';

        Profile profileId = [SELECT Id FROM Profile WHERE Name =: profileName];
        String pid = String.valueOf(profileId.Id);

        PermissionSet permissionSetId = [SELECT Id FROM PermissionSet WHERE ProfileId =: pid];
        String psid = String.valueOf(permissionSetId.Id);

        List<ObjectPermissions> objectPermissionsList = [SELECT SobjectType, PermissionsCreate, PermissionsEdit, PermissionsRead, PermissionsDelete, PermissionsViewAllRecords, PermissionsModifyAllRecords FROM ObjectPermissions WHERE ParentId =: psid];

        List<String> csvRowValues = new List<String>();
        for (ObjectPermissions obj : objectPermissionsList) {
            String rowStr = obj.SobjectType + ', ' + obj.PermissionsCreate + ', ' + obj.PermissionsEdit + ', ' + obj.PermissionsRead + ', ' + obj.PermissionsDelete + ', ' + obj.PermissionsViewAllRecords + ', ' + obj.PermissionsModifyAllRecords;
            csvRowValues.add(rowStr);
        }

        String documentName = 'Object-Level-Security_' + profileName.trim() + '_' + Datetime.now().format('yyyy-mm-dd hh:mm a');
        String csvColumnHeader = 'Sobject, Create, Edit, Read, Delete, View all records, Modify all records\n';
        String csvContent = csvColumnHeader + String.join(csvRowValues,'\n');

        Blob versionData = Blob.valueOf(csvContent);
        ContentVersion csvFile = new ContentVersion();
        csvFile.ContentLocation = 'S';
        csvFile.PathOnClient = documentName + '.csv';
        csvFile.Title = documentName;
        csvFile.VersionData = versionData;
        insert csvFile;

        System.debug('Generated CSV: ' + documentName + ' - ' + csvFile.Id);
    }


    public class checkRecordTypes() {

        //String profileName = 'Data Model Producer';
        String profileName = 'Data Model Member';

        Profile profileId = [SELECT Id FROM Profile WHERE Name =: profileName];
        String pid = String.valueOf(profileId.Id);

        PermissionSet permissionSetId = [SELECT Id FROM PermissionSet WHERE ProfileId =: pid];
        String psid = String.valueOf(permissionSetId.Id);

        


    }
}
