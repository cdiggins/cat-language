'use strict';

// Modules
var fs = require("fs");
var path = require('path');
var mdToHtml = require('../tools/myna_markdown_to_html');
var expand = require('../tools/myna_mustache_expander');

// File paths 
var templateFilePath = 'website/index.template.html';
var markdownFilePath = 'website/index.md';
var indexFilePath = 'docs/index.html';

// logic
var template = fs.readFileSync(templateFilePath, 'utf-8');
var markdown = fs.readFileSync(markdownFilePath, 'utf-8');
var content = mdToHtml(markdown);
var index = expand(template, { content: content });
fs.writeFileSync(indexFilePath, index, 'utf-8');

// Complete
process.exit();