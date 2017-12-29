// This file demonstrates how to use Myna from a TypeScript project 
import { Myna as m } from "../myna";
for (let r of m.allGrammarRules())
    console.log(r.toString());

declare var process : any;   
process.exit();
