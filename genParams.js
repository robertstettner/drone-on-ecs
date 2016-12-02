'use strict';
var fs = require('fs');

var output = [];
var filename = 'params.json';

for (var key in process.env) {
    if (process.env.hasOwnProperty(key) && key.indexOf('CF_') === 0) {
        output.push({
            ParameterKey: key.substring(3),
            ParameterValue: process.env[key]
        });
    }
}

fs.writeFile(filename, JSON.stringify(output, null, 2), function (err) {
    if (err) throw err;
    console.log(filename);
    process.exit(0);
});
