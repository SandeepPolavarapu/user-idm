var UserIdentityManagement = artifacts.require("./UserIdentityManagement.sol");

module.exports = function(deployer) {
  deployer.deploy(UserIdentityManagement);  
};
