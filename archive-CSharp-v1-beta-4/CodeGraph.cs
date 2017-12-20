using System;
using System.Collections.Generic;
using System.Text;

namespace Cat
{
    /// <summary>
    /// Used to create a searchable graph of all code possibilities from 
    /// </summary>
    public class CodeGraph
    {
        static Node MakeNode(CatExpr expr)
        {
            Node ret = new Node();
            ret.expr = expr;
            return ret;
        }

        class Node 
        {
            public CatExpr expr;

            public static Node MakeNode(CatExpr expr)
            {
                return CodeGraph.MakeNode(expr);
            }

            List<Node> nodes;
            
            public IEnumerable<Node> GetNodeIter()
            {
                if (nodes == null) 
                {
                    nodes = new List<Node>();
                }
                return nodes;
            }

            public IEnumerator<Node> GetNodes(int cutAt)
            {
                if (cutAt < 0) 
                    yield return null;
                if (cutAt >= expr.Count)
                    yield return null;
                CatExpr leftSubExpr = expr.GetRangeFromTo(0, cutAt);
                CatExpr rightSubExpr = expr.GetRangeFromTo(cutAt + 1, expr.Count - 1);
                Node leftNode = MakeNode(leftSubExpr);
                Node rightNode = MakeNode(rightSubExpr);
                foreach (Node node in leftNode.GetNodeIter())
                    yield return Compose(leftNode, node);
                foreach (Node node in rightNode.GetNodeIter())
                    yield return Compose(node, rightNode);
            }

            public Node Compose(Node left, Node right)
            {
                // TODO: ... 
                return null;
            }

            public Node()
            {
            }
        }

        Node root;
        
        public CodeGraph(CatExpr expr)
        {
            root = MakeNode(expr);            
        }
    }
}
