class UserPermission {
  String role;

  UserPermission(this.role) {
    if (role.toLowerCase().contains("manager")) {
      canAddUser=true;
    }
    if(role.toLowerCase().contains("user")||role.toLowerCase().contains("user"))
      {
         canAddUser = false;
         canAddLead = false;
         canImport = false;
         canEditLead = false;
         canUploadDocuments = false;
         canEditLabel = false;
      }
  }

  bool canAddUser = true,
      canAddLead = true,
      canImport = true,
      canEditLead = true,
      canUploadDocuments = true,
      canEditLabel = true;
}
