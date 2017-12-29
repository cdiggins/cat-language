"use strict";

var fs = require('fs');
var mdToHtml = require('../tools/myna_markdown_to_html');

// This is a recently failing test. 
var testUrlList = 
`## Themes

* https://github.com/mixu/markdown-styles
* https://themes.gohugo.io
* https://jekyllthemes.org
* https://en-ca.wordpress.org/themes
* https://colorlib.com/wp/free-wordpress-themes
* https://hexo.io/themes`;

var html = mdToHtml(testUrlList);
console.log(html);

// This creates an HTML file from the readme
var md = fs.readFileSync('readme.md', 'utf-8');
var content = mdToHtml(md);
fs.writeFileSync('tests/output/readme.html', content, { encoding:'utf-8' });

process.exit();


