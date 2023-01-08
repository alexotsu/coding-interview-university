# Heap / Priority Queue / Binary Heap 
## Priority Queue
[video](https://www.coursera.org/lecture/data-structures/introduction-2OpTs)

No sense of beginning/end, but each element is given a priority. Processing elements is done by priority.

Definition:
- Insert(p)
- ExtractMax()

Additional operations:
- Remove(t): removes element pointed at by iterator _t_
- GetMax()
- ChangePriority(t, p)

## Binary Max Heap
[video](https://www.coursera.org/lecture/data-structures/binary-trees-GRV2q)

## Binary Tree Full Course:
[video](https://www.youtube.com/watch?v=fAAZixBzIAI)

```
library Node {
    struct Node {
        uint val;
        bytes32[2] ptrs;
    }
}

abstract contract Tree {
    using Node for *;

    uint private nonce;

    mapping(bytes32 => Node.Node) public tree;

    function populateNode(uint val) public returns(bytes32 loc) {
        loc = keccak256(abi.encodePacked(nonce));
        ++nonce;
        tree[loc] = Node.Node(val, [bytes32(0), bytes32(0)]);
    }

    function setPtr(bool left, bytes32 nodeLoc, bytes32 ptr) public {
        uint ptrIdx = left ? 0 : 1;
        tree[nodeLoc].ptrs[ptrIdx] = ptr;
    }
}

contract DepthFirstSearch is Tree {
    
    bytes32[] stack;

    function depthFirstSearch(bytes32 root, bool isMin) public returns(Node.Node memory) {
        // no empty root
        require(root != bytes32(0));
        stack.push(root);

        // keep track of the pointer with the lowest value
        bytes32 limitNodePtr = root;

        while(stack.length > 0) {
            bytes32 topStack = stack[stack.length - 1];
            // if topStack val < limit val AND we are looking for the min, or if topStack val > limit val AND we are looking for the max
            if((tree[topStack].val < tree[limitNodePtr].val && isMin) || (tree[topStack].val > tree[limitNodePtr].val && !isMin)) {
                limitNodePtr = topStack;
            }

            stack.pop();

            if(tree[topStack].ptrs[1] != bytes32(0)) {
                stack.push(tree[topStack].ptrs[1]);
            }

            if(tree[topStack].ptrs[0] != bytes32(0)) {
                stack.push(tree[topStack].ptrs[0]);
            }
        }

        return tree[limitNodePtr];
    }
}

contract BreadthFirstSearch is Tree {
    mapping(uint => bytes32) queue;
    
    function breadthFirstSearch(bytes32 root, bool isMin) public returns(Node.Node memory) {
        require(root != bytes32(0));

        uint queuePointer;
        queue[queuePointer] = root;

        bytes32 limitNodePtr = root;

        while(queue[queuePointer] != bytes32(0)) {
            if((tree[queue[queuePointer]].val < tree[limitNodePtr].val && isMin) || (tree[queue[queuePointer]].val > tree[limitNodePtr].val && !isMin)) {
                limitNodePtr = queue[queuePointer];
            }

            ++queuePointer;

            if(tree[queue[queuePointer]].ptrs[0] != bytes32(0)) {
                queue[queuePointer] = tree[queue[queuePointer]].ptrs[0];
                ++queuePointer;
            }
            
            if(tree[queue[queuePointer]].ptrs[1] != bytes32(0)) {
                queue[queuePointer] = tree[queue[queuePointer]].ptrs[1];
                ++queuePointer;
            }


        }        

        return(tree[limitNodePtr]);

    }
}
```

Depth-first traversal: use a stack to traverse the tree all the way down to first branch's last leaf.

# Heap
[Video](https://youtu.be/odNJmw5TOEE?list=PLFDnELG9dpVxQCxuD-9BSy2E7BWY3t5Sm&t=3291)

Heaps always have values added to the end of them. 
* Child values must be smaller than parent value, but there is no enforced order like in a binary search tree
* Values are added to the bottom of the tree sequentially. Example:

            20
         ____|____
        |         |
        13        19
       /  \      /
      9    7    14
* This allows it to be stored as an array. The above example would look like:
    * [20, 13, 19, 9, 7, 14]
    * Given a node at index i, its children are at indices `2i+1` and `2i+2`, and its parent is at index `floor[(i−1)/2]`

To add a value, append it to the closest empty branch (i.e. the end of the array)
* If the child value is larger than its parent, bubble it up the tree until it is not
    * "Bubbling up" involves switching parent and child node values until heap characteristics are satisfied.

To remove a value, replace it with the value from the end of the array, then bubble the value *down* the tree.
* "Bubbling down" involves (per node):
    1. Compare value to new child values. 
    2. If child values are larger, find which one is the larger of the two
    3. Switch the parent and larger child value

Sorting a heap can be done in fixed space
1. Switch the root (which is known to be the largest) with the value at the end of the array. The "new" heap length is old.length-1, and the last slot becomes "off limits" in the heap because from that slot onward, it no longer follows heap rules.
2. Bubble the value that is now at the root down until it is in the right place, ignoring the off limit slot.
3. Repeat with the new root (which should be the second largest value) and the new last slot. (_n-1_)
    Pseudocode:
    ```
    for(i=0; i<n; i++) {
        swap A[0], A[A.length]
        size--;
        SiftDown(A[0])
    }
    ```

## Building a heap
Start from the bottom of the heap (back of the array), and bubble all non-heap items down.
* Intuitively, this works because each new item should have a legal heap below it

