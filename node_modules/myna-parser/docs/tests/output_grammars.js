"use strict";

// This project outputs the grammars and the schemas of the AST trees 

var myna = require('../tools/myna_all');

for (let g of myna.grammarNames()) 
{
    console.log("==============================");
    console.log("Grammar: " + g);
    console.log("==============================");
    console.log(myna.grammarToString(g));

    console.log("==============================");
    console.log("AST Schema: " + g);
    console.log("==============================");
    console.log(myna.astSchemaToString(g));
}

