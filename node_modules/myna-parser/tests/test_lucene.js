'use strict';

let myna = require('../myna');
require('../grammars/grammar_lucene')(myna);

function testQuery(q) 
{
    console.log("Input query = " + q);
    let ast = myna.parsers.lucene(q);    
    console.log(ast.toString());
}

let qs = [
    'title:"The Right Way" AND text:go', 
    'title:"Do it right" AND right', 
    'timestamp:[* TO NOW]', 
    'createdate:[1976-03-06T23:59:59.999Z TO *]',
    '+popularity:[10 TO  *] +section:0', 
    '{!func}popularity', 
    '{!q.op=AND df=title}solr rocks', 
    "{!type=dismax qf='myfield yourfield'}solr rocks", 
    '{!type=dismax qf="myfield yourfield"}solr rocks', 
    '{!dismax qf=myfield}solr rocks', 
    '{!type=dismax qf=myfield}solr rocks', 
    "{!type=dismax qf=myfield v='solr rocks'}", 
    '{!lucene q.op=AND df=text}myfield:foo +bar -baz', 
    '(jakarta OR apache) AND website', 
    '"jakarta apache" -"Apache Lucene"', 
    'NOT "jakarta apache"', 
    '"jakarta apache" NOT "Apache Lucene"', 
    '+jakarta lucene',
    '"jakarta apache" AND "Apache Lucene"', 
    '"jakarta apache" OR jakarta', 
    '"jakarta apache" jakarta', 
    '"jakarta apache"^4 "Apache Lucene"', 
    'jakarta^4 apache',
    'jakarta apache', 
    'title:{Aida TO Carmen}', 
    '"jakarta apache"~10', 
    'roam~0.8', 
    'roam~', 
    'foo:{bar TO baz}', 
    'foo:[bar TO baz]', 
    'fizz AND (buzz OR baz)', 
    'fizz (buzz baz)', 
    'fizz || buzz', 
    'fizz && buzz',
    'foo:+"fizz buzz"', 
    'foo:-"fizz buzz"', 
    'foo:+bar', 
    'foo:-bar', 
    'foo:"fizz buzz"',
    'sub.foo:bar', 
    'foo:2015-01-01', 
    'foo:bar', 
    '+"fizz buzz"', 
    '-"fizz buzz"', 
    'published_at:>now+5d', 
    'created_at:>now-5d', 
    ' Test:Foo', 
    ' \r\n'
]

for (let q of qs) {
    testQuery(q);   
}
