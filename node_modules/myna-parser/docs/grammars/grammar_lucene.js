"use strict";

// This is a grammar for Lucene 4.0 and Solr queries
// http://lucene.apache.org/core/4_0_0/queryparser/org/apache/lucene/queryparser/classic/package-summary.html
// https://wiki.apache.org/solr/SolrQuerySyntax

// Additional grammars to be built
// https://cwiki.apache.org/confluence/display/solr/Spatial+Search
// https://wiki.apache.org/solr/SpatialSearch
// http://lucene.apache.org/core/4_0_0/core/org/apache/lucene/util/automaton/RegExp.html?is-external=true

// Sample grammars
// https://github.com/thoward/lucene-query-parser.js/blob/master/lib/lucene-query.grammar
// https://github.com/lrowe/lucenequery/blob/master/lucenequery/StandardLuceneGrammar.g4
// https://github.com/romanchyla/montysolr/blob/master/contrib/antlrqueryparser/grammars/StandardLuceneGrammar.g

// TODO: is a&&b a single term? Or two terms? 
// TODO: support geo-coordinate parsing 
// TODO: support fucntion parsing 

// TODO: support date-time parsing 
// http://lucene.apache.org/solr/6_5_1/solr-core/org/apache/solr/util/DateMathParser.html

function CreateLuceneGrammar(myna) 
{
    let m = myna;

    let g = new function() 
    { 
        let _this = this; 
        this.delayedQuery = m.delay(function () { return _this.query; });

        this.ws = m.char(' \t\n\r\f').zeroOrMore;
        this.escapedChar = m.char('\\').advance;
        this.float = m.digit.zeroOrMore.then(m.seq('.', m.digits).opt).ast;    

        //
        this.boostFactor = this.float.ast;
        this.boost = m.text("^").then(this.boostFactor).ast;
        
        this.fuzzFactor = this.float.ast; 
        this.fuzz = m.seq('~', this.fuzzFactor.opt).ast;    

        this.modifier = m.char("+-").ast;

        this.symbolicOperator = m.choice("||", "&&", "!");
        this.operator = m.keywords("OR NOT", "AND NOT", "OR", "AND", "NOT").or(this.symbolicOperator).opt.ast;

        // Represents valid termchars 
        // NOTE: according to the specification additional characters are not accepted: ':/&|' however, many of these 
        // interfere with date parsing. 
        this.termChar = m.seq(this.symbolicOperator.not, m.notChar(' \t\r\n\f{}()"^~[]\\')).or(this.escapedChar);

        this.singleTerm = this.termChar.oneOrMore.ast;    
        this.fieldName = this.termChar.unless(m.char(':/')).oneOrMore.ast;
        this.field = this.fieldName.then(':');

        // TODO: this should be in Myna
        this.phrase = m.doubleQuoted(m.notChar('"').zeroOrMore).ast;
        this.regex = m.seq('/', m.notChar('/').zeroOrMore, '/').ast;
        
        // TODO: use the whitespace in the grammar 
        this.group = m.seq('(', this.delayedQuery, m.assert(')')).ast;
                        
        // TODO: make the ranges a guarded sequence 
        this.endPoint  = m.seq(this.ws, this.singleTerm, this.ws);
        this.inclusiveRange = m.seq('[', this.endPoint, m.keyword("TO"), this.endPoint, ']').ast;
        this.exclusiveRange = m.seq('{', this.endPoint, m.keyword("TO"), this.endPoint, '}').ast;
        this.range = m.choice(this.inclusiveRange, this.exclusiveRange).ast;
        this.postOps = m.choice(this.boost.then(this.fuzz.opt), this.fuzz.then(this.boost.opt));
        this.term = m.seq(this.field.opt, this.modifier.opt, m.choice(this.group, this.singleTerm, this.phrase, this.regex, this.range), this.postOps.opt).ast;        

        // localParams
        this.keyChar = m.letter.or(".");
        this.escapedChar = m.char('\\').then(m.advance);
        this.paramKey = this.keyChar.oneOrMore.ast;
        this.singleQuotedValue= m.singleQuotedString(this.escapedChar).ast;
        this.doubleQuotedValue= m.doubleQuotedString(this.escapedChar).ast;
        this.paramValue = m.choice(this.singleQuotedValue, this.doubleQuotedValue, this.term).ast;
        this.param = this.paramKey.then('=').opt.then(this.paramValue).ast;
        this.localParams = m.seq('{!', m.delimited(this.param, this.ws), m.assert('}')).ast;

        // Query 
        this.terms = m.delimited(this.term.then(this.ws), this.operator.then(this.ws)).ast;
        this.query = m.seq(this.ws, this.localParams.opt, this.ws, this.terms, this.ws).ast;
    };

    // Register the grammar, providing a name and the default parse rule
    return m.registerGrammar("lucene", g, g.query);
}

// Export the grammar for usage by Node.js and CommonJs compatible module loaders 
if (typeof module === "object" && module.exports) 
    module.exports = CreateLuceneGrammar;