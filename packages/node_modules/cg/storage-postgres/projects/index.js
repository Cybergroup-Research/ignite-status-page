var runtimestorage = require("../storage");
var when = require('when');

var initialFlowLoadComplete = false;
function getFlows() {
        if (!initialFlowLoadComplete) {
            initialFlowLoadComplete = true;
        }
        return runtimestorage.getJson("cg:flow", []);
}
function saveFlows(flows) {
    return runtimestorage.saveJson("cg:flow", flows);
}
function getCredentials() {
    return runtimestorage.getJson("cg:credentials");
}
function saveCredentials(credentials) {
    return runtimestorage.saveJson("cg:credentials", credentials);
}
module.exports = {
    getFlows: getFlows,
    saveFlows: saveFlows,
    getCredentials: getCredentials,
    saveCredentials: saveCredentials
};
