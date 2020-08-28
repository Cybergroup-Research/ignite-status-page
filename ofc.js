var fs = require("fs");
var path = require("path");
var JavaScriptObfuscator = require('javascript-obfuscator');
var arg = process.argv.slice(1)[1];

if (fs.statSync(arg).isDirectory()) {
    getAllFiles(arg).forEach(function(filename){
        obfuscate(filename);
    });
}
else
{
    obfuscate(arg);
}
function obfuscate(filename){
    if(path.extname(filename) === ".json")
    {
        console.log("The file was Skipped!, ", filename);
        return;
    }
    fs.readFile(filename, "UTF-8", function(err, data) {
        if (err) {
            throw err;
        }
        var obfuscationResult = JavaScriptObfuscator.obfuscate(data);
        fs.writeFile( filename,obfuscationResult.getObfuscatedCode() , function(err) {
            if(err) {
                return console.log(err, ", for:", filename);
            }
            console.log("The file was Obfuscated And Saved!, ", filename);
        });
    });
}
function getAllFiles(dirPath, arrayOfFiles) {
    files = fs.readdirSync(dirPath)
  
    arrayOfFiles = arrayOfFiles || []
  
    files.forEach(function(file) {
      if (fs.statSync(dirPath + "/" + file).isDirectory()) {
        arrayOfFiles = getAllFiles(dirPath + "/" + file, arrayOfFiles)
      } else {
        arrayOfFiles.push(path.join(__dirname, dirPath, "/", file))
      }
    })
  
    return arrayOfFiles
  }