using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace Cat                        
{
    class CatTypeReconstructor : ConstraintSolver
    {
        public Constraint KindVarToConstraintVar(CatKind k)
        {
            Trace.Assert(k.IsKindVar());
            return CreateVar(k.ToString().Substring(1));
        }

        public Vector TypeVectorToConstraintVector(CatTypeVector x)
        {
            Vector vec = new Vector();
            foreach (CatKind k in x.GetKinds())
                vec.Insert(0, CatKindToConstraint(k));
            return vec;
        }

        public Relation FxnTypeToRelation(CatFxnType ft)
        {
            Vector cons = TypeVectorToConstraintVector(ft.GetCons());
            Vector prod = TypeVectorToConstraintVector(ft.GetProd());
            Relation r = new Relation(cons, prod);
            return r;
        }

        public Constraint CatKindToConstraint(CatKind k)
        {
            if (k is CatTypeVector)
            {
                return TypeVectorToConstraintVector(k as CatTypeVector);
            }
            else if (k is CatFxnType)
            {
                return FxnTypeToRelation(k as CatFxnType);
            }
            else if (k.IsKindVar())
            {
                return KindVarToConstraintVar(k);
            }
            else
            {
                return new Constant(k.ToIdString());
            }   
        }

        public CatTypeVector CatTypeVectorFromVec(Vector vec)
        {
            CatTypeVector ret = new CatTypeVector();
            foreach (Constraint c in vec)
                ret.PushKindBottom(ConstraintToCatKind(c));
            return ret;
        }

        public CatFxnType CatFxnTypeFromRelation(Relation rel)
        {
            CatTypeVector cons = CatTypeVectorFromVec(rel.GetLeft());
            CatTypeVector prod = CatTypeVectorFromVec(rel.GetRight());

            // TODO: add the boolean as a third value in the vector.
            // it becomes a variable when unknown, and is resolved otherwise.
            return new CatFxnType(cons, prod, false);
        }

        public CatKind ConstraintToCatKind(Constraint c)
        {
            if (c is ScalarVar)
            {
                return new CatTypeVar(c.ToString());
            }
            else if (c is VectorVar)
            {
                return new CatStackVar(c.ToString());
            }
            else if (c is Vector)
            {
                return CatTypeVectorFromVec(c as Vector);
            }
            else if (c is Relation)
            {
                return CatFxnTypeFromRelation(c as Relation);
            }
            else if (c is RecursiveRelation)
            {
                return new CatRecursiveType();
            }
            else if (c is Constant)
            {
                // TODO: deal with CatCustomKinds
                return new CatSimpleTypeKind(c.ToString());
            }
            else
            {
                throw new Exception("unhandled constraint " + c.ToString());
            }
        }

        public CatFxnType LocalComposeTypes(CatFxnType left, CatFxnType right)        
        {
            // Make sure that the variables on the left function and the variables
            // on the right function are different
            CatVarRenamer renamer = new CatVarRenamer();
            left = renamer.Rename(left.AddImplicitRhoVariables());
            renamer.ResetNames();
            right = renamer.Rename(right.AddImplicitRhoVariables());

            Log("==");
            Log("Composing : " + left.ToString());
            Log("with      : " + right.ToString());

            Log("Adding constraints");
            
            Relation rLeft = FxnTypeToRelation(left); 
            Relation rRight = FxnTypeToRelation(right);
            
            //TODO: remove
            //rLeft.UnrollRecursiveRelations();
            //rRight.UnrollRecursiveRelations();
            
            Relation result = new Relation(rLeft.GetLeft(), rRight.GetRight());
            
            AddTopLevelConstraints(rLeft.GetRight(), rRight.GetLeft());
            AddConstraint(CreateVar("result$"), result);            

            Log("Constraints");
            ComputeConstraintLists();
            LogConstraints();

            Log("Unifiers");
            ComputeUnifiers();
            foreach (string sVar in GetConstrainedVars())
            {
                Constraint u = GetUnifierFor(sVar);
                Log("var: " + sVar + " = " + u);
            }

            Log("Composed Type");
            Constraint c = GetResolvedUnifierFor("result$");

            if (!(c is Relation))
                throw new Exception("Resolved type is not a relation");

            // TODO: remove
            // Relation r = c as Relation;
            // r.RollupRecursiveRelations();

            CatKind k = ConstraintToCatKind(c);
            CatFxnType ft = k as CatFxnType;
            Log("raw type    : " + ft.ToString());
            Log("pretty type : " + ft.ToPrettyString());
            Log("==");

            CheckConstraintQueueEmpty();

            // Check if the relation was valid, and thus the function type
            if (!ft.IsValid())
                throw new Exception("invalid function type: " + ft.ToString());

            return ft;
        }

        public static void OutputInferredType(CatFxnType ft)
        {
            Log("After rewriting");
            Log(ft.ToPrettyString());
            Log("");
        }

        public static CatFxnType Infer(CatExpr f)
        {
            if (!Config.gbTypeChecking)
                return null;

            if (f.Count == 0)
            {
                if (Config.gbVerboseInference)
                    Log("type is ( -> )");
                return CatFxnType.Create("( -> )");
            }
            else if (f.Count == 1)
            {
                Function x = f[0];
                if (Config.gbVerboseInference)
                    OutputInferredType(x.GetFxnType());
                return x.GetFxnType();
            }
            else
            {
                Function x = f[0];
                CatFxnType ft = x.GetFxnType();
                if (Config.gbVerboseInference)
                    Log("initial term = " + x.GetName() + " : " + x.GetFxnTypeString());

                for (int i = 1; i < f.Count; ++i)
                {
                    if (ft == null)
                        return ft;
                    Function y = f[i];
                    if (Config.gbVerboseInference)
                    {
                        Log("Composing accumulated terms with next term");
                        string s = "previous terms = { ";
                        for (int j = 0; j < i; ++j)
                            s += f[j].GetName() + " ";
                        Log(s + "} : " + ft.ToString());
                        Log("next term = " + y.GetName() + " : " + y.GetFxnTypeString());
                    }

                    ft = ComposeTypes(ft, y.GetFxnType());

                    if (ft == null)
                        return null;
                }
                return ft;
            }
        }

        public static CatFxnType ComposeTypes(CatFxnType left, CatFxnType right)
        {
            if (!Config.gbTypeChecking)
                return null;

            CatTypeReconstructor inferer = new CatTypeReconstructor();
            return inferer.LocalComposeTypes(left, right);
        }
    }
}
