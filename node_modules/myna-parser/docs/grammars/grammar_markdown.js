"use strict";

// Implements a grammar for the Git-flavor of Markdown
// https://daringfireball.net/projects/markdown/syntax#autolink 
// https://help.github.com/articles/basic-writing-and-formatting-syntax/
// https://guides.github.com/features/mastering-markdown/

function CreateMarkdownGrammar(myna)
{
    let m = myna;

    let g = new function()
    {        
        // Allows the "inline" to be referenced before it is defined. 
        // This enables recursive definitions. 
        let _this = this;
        this.inlineDelayed = m.delay(function() { return _this.inline; });            
        
        this.boundedInline = function(begin, end) {
            if (end == undefined) end = begin;
            return m.seq(begin, this.inlineDelayed.unless(end).zeroOrMore, end);
        }
        
        // Plain text
        this.specialCharSet = '[]()*~`@#\\_!';
        this.escaped = m.seq('\\', m.advance).ast;
        this.ws = m.char(' \t').oneOrMore;
        this.optWs = this.ws.opt;
        this.wsOrNewLine = this.ws.or(m.newLine);
        this.nonSpecialChar = m.notChar(this.specialCharSet).unless(m.newLine);
        this.specialChar = m.char(this.specialCharSet).ast;
        this.plainText = m.choice(m.digits, m.letters, this.ws, this.nonSpecialChar).oneOrMore.ast;

        // Styling instructions 
        this.bold = m.choice(this.boundedInline('**'), this.boundedInline('__')).ast;
        this.boldItalic = m.choice(this.boundedInline('*_', '_*'), this.boundedInline('_*', '*_')).ast;
        this.italic = m.choice(this.boundedInline('*'), this.boundedInline('_')).ast;
        this.strike = this.boundedInline('~~').ast;
        this.code = m.not('```').then(this.boundedInline('`')).ast;
        this.styledText = m.choice(this.bold, this.italic, this.strike);

        // Image instructions 
        this.linkedUrl = m.choice(this.escaped, m.notChar(')')).zeroOrMore.ast;
        this.altText =  m.choice(this.escaped, m.notChar(']')).zeroOrMore.ast;
        this.image = m.seq('![', this.altText, ']', m.ws, '(', this.linkedUrl, ')').ast;

        // Linked text
        this.linkedText = this.inlineDelayed.unless(']').zeroOrMore.ast;
        this.linkText = m.seq('[', this.linkedText, ']');
        this.linkUrl = m.seq('(', this.linkedUrl, ')');
        this.link = m.seq(this.linkText, m.ws, this.linkUrl).ast;        

        // Mention
        this.reference = m.choice(m.char('/-'), m.identifierNext).oneOrMore.ast;
        this.mention = m.seq('@', this.reference).ast;    

        // Comment
        this.comment = m.seq("<!--", m.advanceUntilPast("-->")).ast;

        // Beginning of sections 
        this.indent = m.zeroOrMore('  ').ast;
        this.inlineUrl = m.seq(m.choice("http://", "https://", "mailto:"), m.advanceWhileNot(this.wsOrNewLine)).ast;
        this.numListStart = m.seq(this.indent, m.digit.oneOrMore, '.', m.ws);
        this.quotedLineStart = m.seq(this.indent, '>');
        this.listStart = m.seq(this.indent, m.char('-').or(m.seq('*', m.not('*'))), m.ws);
        this.headingLineStart = m.quantified('#', 1, 6).ast;
        this.codeBlockDelim = m.text("```");
        this.specialLineStart = this.optWs.then(m.choice(this.listStart, this.headingLineStart, this.quotedLineStart, this.numListStart, this.codeBlockDelim));

        // Inline content 
        this.any = m.advance.ast;
        this.inline = m.choice(this.comment, this.image, this.link, this.mention, this.styledText, this.code, this.escaped, this.inlineUrl, this.plainText, this.any).unless(m.newLine);
        this.lineEnd = m.newLine.or(m.assert(m.end));
        this.emptyLine = m.char(' \t').zeroOrMore.then(m.newLine).ast;
        this.restOfLine = m.seq(this.inline.zeroOrMore).then(this.lineEnd).ast;
        this.simpleLine = m.seq(this.emptyLine.not, this.specialLineStart.not, m.notEnd, this.restOfLine).ast;
        this.paragraph = this.simpleLine.oneOrMore.ast;
        
        // Lists
        this.orderedListItem = m.seq(this.numListStart, this.optWs, this.restOfLine).ast;
        this.unorderedListItem = m.seq(this.listStart, this.optWs, this.restOfLine).ast;
        this.orderedList = this.orderedListItem.oneOrMore.ast;
        this.unorderedList = this.unorderedListItem.oneOrMore.ast;
        this.list = m.choice(this.orderedList, this.unorderedList);
        
        // Quotes
        this.quotedLine = m.seq('>', this.optWs, this.restOfLine).ast;
        this.quote = this.quotedLine.oneOrMore.ast;    

        // Code blocks        
        this.codeBlockContent = m.advanceWhileNot(this.codeBlockDelim).ast;
        this.codeBlockHint = m.advanceWhileNot(m.choice(m.newLine, this.codeBlockDelim)).ast;
        this.codeBlock = m.guardedSeq(this.codeBlockDelim, this.codeBlockHint, m.newLine.opt, this.codeBlockContent, this.codeBlockDelim).ast;

        // Heading 
        this.heading = this.headingLineStart.then(this.optWs).then(this.restOfLine).ast;

        // A section 
        this.content = m.choice(this.heading, this.list, this.quote, this.codeBlock, this.paragraph, this.emptyLine); 
        this.document = this.content.zeroOrMore;
    }

    // Register the grammar, providing a name and the default parse rule
    return m.registerGrammar("markdown", g, g.document);
}

// Export the grammar for usage by Node.js and CommonJs compatible module loaders 
if (typeof module === "object" && module.exports) 
    module.exports = CreateMarkdownGrammar;