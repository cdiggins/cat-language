# Myna Tests

There are two types of tests with Myna

1. **Parser tests** - Effectively these are unit tests run using QUnit which test the core parsers, the various combinarors, and the sample grammars.  
2. **Tool tests** - These are integration tests, which test simples tools built using the sample grammars. 

The tool tests demonstrate how to use Myna in an actual tool. 

## Parser Tests 

To run the Parse tests open the `QUnit.html` file in your browser. You do not have to be using a server, you can just point your browser to the local file. 

## Tool Tests

To run the local tests you will need to use node from the root folder of the Myna distribution as follows:

```
  node tests\test_tools.js
```





