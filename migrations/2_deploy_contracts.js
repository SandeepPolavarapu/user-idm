var UserIdentityManagement = artifacts.require("UserIdentityManagement");
var Adoption = artifacts.require("Adoption");

module.exports = function(deployer) {
  deployer.deploy(UserIdentityManagement);  
  deployer.deploy(Adoption);
};
