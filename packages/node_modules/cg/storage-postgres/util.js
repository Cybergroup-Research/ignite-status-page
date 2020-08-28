var fs = require('fs-extra');
var when = require('when');
var nodeFn = require('when/node/function');

function parseJSON(data) {
    if (data.charCodeAt(0) === 0xFEFF) {
        data = data.slice(1)
    }
    return JSON.parse(data);
}
function readFile(path,backupPath,emptyResponse,type) {
    return when.promise(function(resolve) {
        fs.readFile(path,'utf8',function(err,data) {
            if (!err) {
                if (data.length === 0) {
                    try {
                        var backupStat = fs.statSync(backupPath);
                        if (backupStat.size === 0) {
                            // Empty flows, empty backup - return empty flow
                            return resolve(emptyResponse);
                        }
                        // Empty flows, restore backup
                        fs.copy(backupPath,path,function(backupCopyErr) {
                            if (backupCopyErr) {
                                // Restore backup failed
                                resolve([]);
                            } else {
                                // Loop back in to load the restored backup
                                resolve(readFile(path,backupPath,emptyResponse,type));
                            }
                        });
                        return;
                    } catch(backupStatErr) {
                        // Empty flow file, no back-up file
                        return resolve(emptyResponse);
                    }
                }
                try {
                    return resolve(parseJSON(data));
                } catch(parseErr) {
                    return resolve(emptyResponse);
                }
            } else {
                if (type === 'flow') {
                }
                resolve(emptyResponse);
            }
        });
    });
}

module.exports = {
    /**
     * Write content to a file using UTF8 encoding.
     * This forces a fsync before completing to ensure
     * the write hits disk.
     */
     writeFile: function(path,content,backupPath) {
         if (backupPath) {
            if (fs.existsSync(path)) {
                fs.renameSync(path,backupPath);
            }
        }
        return when.promise(function(resolve,reject) {
            var stream = fs.createWriteStream(path);
            stream.on('open',function(fd) {
                stream.write(content,'utf8',function() {
                    fs.fsync(fd,function(err) {
                        if (err) {
                            console.log(err);
                        }
                        stream.end(resolve);
                    });
                });
            });
            stream.on('error',function(err) {
                reject(err);
            });
        });
     },
    readFile: readFile,

    parseJSON: parseJSON
}