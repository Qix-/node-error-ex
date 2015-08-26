'use strict';

var util = require('util');

var errorEx = function errorEx(name, properties) {
	if (!name || name.constructor !== String) {
		properties = name || {};
		name = Error.name;
	}

	var errorExError = function ErrorEXError(message) {
		if (!this) {
			return new ErrorEXError(message);
		}

		message = message || this.message;

		Error.call(this, message);
		Error.captureStackTrace(this, this.constructor);
		this.message = message;
		this.name = name;

		var descriptor = Object.getOwnPropertyDescriptor(this, 'stack');
		var stackGetter = descriptor.get;

		descriptor.get = function () {
			var stack = stackGetter.call(this).split(/[\r\n]+/g);

			var lineCount = 1;
			for (var key in properties) {
				if (!properties.hasOwnProperty(key)) {
					continue;
				}

				var modifier = properties[key];
				var line = modifier(this[key], stack);
				if (line) {
					stack.splice(lineCount, 0, '    ' + line);
				}
			}

			return stack.join('\n');
		};

		Object.defineProperty(this, 'stack', descriptor);
	};

	util.inherits(errorExError, Error);

	return errorExError;
};

errorEx.append = function (str, def) {
	return function (v, stack) {
		v = v || def;
		if (v) {
			stack[0] += ' ' + str.replace('%s', v.toString());
		}
	};
};

errorEx.line = function (str, def) {
	return function (v) {
		v = v || def;
		if (v) {
			return str.replace('%s', v.toString());
		}
	};
};

module.exports = errorEx;
