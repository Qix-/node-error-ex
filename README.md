# node-error-ex [![Travis-CI.org Build Status](https://img.shields.io/travis/Qix-/node-error-ex.svg?style=flat-square)](https://travis-ci.org/Qix-/node-error-ex) [![Coveralls.io Coverage Rating](https://img.shields.io/coveralls/Qix-/node-error-ex.svg?style=flat-square)](https://coveralls.io/r/Qix-/node-error-ex)
> Easily subclass and customize new Error types

## Examples
To include in your project:
```javascript
var errorEx = require('error-ex');
```

To create an error message type with a specific name (note, that `ErrorFn.name`
will not reflect this):
```javascript
var JSONError = errorEx('JSONError');

var err = new JSONError('error');
err.name; //-> JSONError
throw err; //-> JSONError: error
```

To add a stack line:
```javascript
var JSONError = errorEx('JSONError', {fileName: errorEx.line('in {}')});

var err = new JSONError('error')
err.fileName = '/a/b/c/foo.json';
throw err; //-> (line 2)-> in /a/b/c/foo.json
```

To append to the error message:
```javascript
var JSONError = errorEx('JSONError', {fileName: errorEx.append('in {}')});

var err = new JSONError('error');
err.fileName = '/a/b/c/foo.json';
throw err; //-> JSONError: error in /a/b/c/foo.json
```

## License
Licensed under the [MIT License](http://opensource.org/licenses/MIT).
You can find a copy of it in [LICENSE](LICENSE).
