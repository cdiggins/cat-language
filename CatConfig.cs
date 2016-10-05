/// Dedicated to the public domain by Christopher Diggins
/// http://creativecommons.org/licenses/publicdomain/

using System;
using System.Collections.Generic;
using System.Text;

namespace Cat
{
    /// <summary>
    /// The config class contain global switches for controlling the behaviour 
    /// of the interpreter and compiler. This is not actively maintained, and could
    /// easily be out of sync with the rest of the code
    /// </summary>
    class Config
    {
        /// <summary>
        /// Tells us whether this is a release build or not.
        /// </summary>
        public static bool gbReleaseVersion = true;

        /// <summary>
        /// Determines whether the contents of the stacks is reported 
        /// after each line entry into the interpreter.
        /// </summary>
        public static bool gbOutputStack = true;

        /// <summary>
        /// Output the amount of time elapsed after each entry in the interpreter.
        /// </summary>
        public static bool gbOutputTimeElapsed = false;

        /// <summary>
        /// The number of completion port threads (?) that the interpreter can spawn at one time. 
        /// </summary>
        public static int gnMaxCompletionPortThreads = 0;

        /// <summary>
        /// Set this to false to prevent implicit redefining existing functions. 
        /// </summary>
        public static bool gbAllowRedefines = true;

        /// <summary>
        /// Set to false to only implement point-free Cat
        /// </summary>
        public static bool gbAllowNamedParams = true;

        /// <summary>
        /// Outputs the result of performing a conversion from a function
        /// with named arguments to a point-free form.
        /// </summary>
        public static bool gbShowPointFreeConversion = false;

        /// <summary>
        /// Turns on type checking and type reconstruction algorithms
        /// </summary>
        public static bool gbTypeChecking = true;

        /// <summary>
        /// Outputs detailed information of each of the inference mechanism works
        /// </summary>
        public static bool gbVerboseInference = false;

        /// <summary>
        /// When a function is defined in interpreter, shows the inferred type.
        /// </summary>
        public static bool gbShowInferredType = true;

        /// <summary>
        /// Outputs detailed information of each of the inference mechanism works
        /// while loading a module.
        /// </summary>
        public static bool gbVerboseInferenceOnLoad = false;

        /// <summary>
        /// Version number 
        /// </summary>
        public static string gsVersion = "1.0 beta 4";

        /// <summary>
        /// Displays a turtle representing the current pen when drawing. 
        /// </summary>
        public static bool gbShowTurtle = true;

        /// <summary>
        /// Cause bin_rec to use a second thread.
        /// </summary>
        public static bool gbMultiThreadBinRec = false;

        /// <summary>
        /// Shows a log of each rewriting rule applied
        /// </summary>
        public static bool gbShowRewritingRuleApplications = false;

        /// <summary>
        /// Shows the total result of all rewritings
        /// </summary>
        public static bool gbShowRewritingResults = false;

        /// <summary>
        /// Show a welcome message when the interpreter starts up
        /// </summary>
        public static bool gbShowWelcome = true;

        /// <summary>
        /// Applies rewriting rules to improve lambda definitions
        /// </summary>
        public static bool gbOptimizeLambdas = false;

        /// <summary>
        /// Applies rewriting rules to all literal quotations
        /// </summary>
        public static bool gbOptimizeQuotations = false;

        /// <summary>
        /// run all self-tests automatically
        /// </summary>
        public static bool gbSelfTest = true;
    }
}
