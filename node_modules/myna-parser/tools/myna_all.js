// Loads the Myna module and all grammars 
"use strict";

var myna = require('../myna');
require('../grammars/grammar_arithmetic')(myna);
require('../grammars/grammar_csv')(myna);
require('../grammars/grammar_html_reserved_chars')(myna);
require('../grammars/grammar_json')(myna);
require('../grammars/grammar_lucene')(myna);
require('../grammars/grammar_markdown')(myna);
require('../grammars/grammar_mustache')(myna);
require('../grammars/grammar_glsl')(myna);

module.exports = myna;