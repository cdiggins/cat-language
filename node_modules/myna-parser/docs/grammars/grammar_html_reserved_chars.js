'use strict';

// Define a grammar for common HTML reserved chars. Those are characters like <, >, and & that should be
// be replaced by an HTML entity to be displayed correctly.
function CreateHtmlReservedCharsGrammar(myna) 
{
    let m = myna;
    
    let g = new function() 
    {
        let escapeChars = '&<>"\'';        
        this.specialChar = m.char(escapeChars).ast;
        this.plainText = m.notChar(escapeChars).oneOrMore.ast;
        this.text = m.choice(this.specialChar, this.plainText).zeroOrMore;
    }

    // Register the grammar, providing a name and the default parse rule
    return m.registerGrammar('html_reserved_chars', g, g.text);
}

// Export the main function for usage by Node.js and CommonJs compatible module loaders 
if (typeof module === "object" && module.exports) 
    module.exports = CreateHtmlReservedCharsGrammar;