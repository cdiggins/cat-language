"use strict";

// A Myna grammar for a variant of the Mustache and CTemplate template languages
// This grammar works with any template delimiters defaulting to "{{" and "}}"
// - http://mustache.github.io/mustache.5.html
// - https://github.com/olafvdspek/ctemplate
// According to the mustache documentation:
// - `#` indicates a start section
// - `/` indicates an end section
// - `^` indicates an inverted section
// - `!` indcates a comment
// - `&` or `{` indicate an unescaped variable 
// - `>` indicates a *partial* which is effectively a file include with run-time expansion.

function CreateMustacheGrammar(myna, start, end) {
    if (start == undefined)
        start = "{{";
    if (end == undefined)
        end = "}}";

    if (start.length == 0 || end.length == 0)
        throw "Missing start and end delimiters";

    let m = myna;

    // Create the grammar object 
    let g = new function() 
    {
        // Define a rule so that we can refer to content recursively
        let _this = this;
        this.recursiveContent = m.delay(function() { return _this.content; });            

        // Main grammar rules. 
        // Only those with 'ast' will generate nodes in the parse tree 
        this.key = m.advanceWhileNot(end).ast;
        this.restOfLine = m.char(' \t').zeroOrMore.then(m.opt('\n'));
        this.startSection = m.seq(start, "#", this.key, end, this.restOfLine);
        this.endSection = m.seq(start, "/", this.key, end);
        this.startInvertedSection = m.seq(start, "^", this.key, end, this.restOfLine);
        this.escapedVar = m.seq(start, m.notAtChar("#/^!{&<"), this.key, end).ast;
        this.unescapedVar = m.seq(start, m.choice(m.seq("{", this.key, "}"), m.seq("&", this.key)), end).ast;
        this.var = m.choice(this.escapedVar, this.unescapedVar);
        this.partial = m.seq(start, ">", m.ws.opt, this.key, end).ast;
        this.comment = m.seq(start, "!", this.key, end).ast;    
        this.sectionContent = this.recursiveContent.ast;
        this.section = m.guardedSeq(this.startSection, this.sectionContent, this.endSection).ast;
        this.invertedSection = m.guardedSeq(this.startInvertedSection, this.sectionContent, this.endSection).ast;
        this.plainText = m.advanceOneOrMoreWhileNot(start).ast;
        this.content = m.choice(this.invertedSection, this.section, this.comment, this.partial, this.var, this.plainText).zeroOrMore;
        this.document = this.content.ast;
    }

    // Register the grammar, providing a name and the default parse rule
    return m.registerGrammar("mustache", g, g.document);
}

// Export the grammar for usage by Node.js and CommonJs compatible module loaders 
if (typeof module === "object" && module.exports) 
    module.exports = CreateMustacheGrammar;