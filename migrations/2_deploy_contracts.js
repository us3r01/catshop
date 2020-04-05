// 2_deploy_contracts.js
const CatShop = artifacts.require("CatShop");
module.exports = function(deployer) {
 deployer.deploy(CatShop);
};