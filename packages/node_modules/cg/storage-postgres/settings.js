var when = require('when');
var runtimestorage = require("./storage");

var settings;

module.exports = {
    init: function(_settings) {
        settings = _settings;
    },
    getSettings: function() {
        return runtimestorage.getJson("cg:setting", {});
    },
    saveSettings: function(newSettings) {
        if (settings.readOnly) {
            return when.resolve();
        }
        return runtimestorage.saveJson("cg:setting",newSettings);
    }
}