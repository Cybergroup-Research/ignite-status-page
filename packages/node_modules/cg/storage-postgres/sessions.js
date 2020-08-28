var when = require('when');
var settings;
var runtimestorage = require("./storage");
module.exports = {
    init: function(_settings) {
        settings = _settings;
    },
    getSessions: function() {
        return runtimestorage.getJson("cg:session");
    },
    saveSessions: function(sessions) {
        if (settings.readOnly) {
            return when.resolve();
        }
        return runtimestorage.saveJson("cg:session",sessions);
    }
}