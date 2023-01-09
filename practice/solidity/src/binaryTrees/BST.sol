pragma solidity >= 0.8.13;

// - [ ] Implement:
//     - [x] insert    // insert value into tree
//     - [ ] get_node_count // get count of values stored
//     - [ ] print_values // prints the values in the tree, from min to max
//     - [ ] delete_tree
//     - [x] is_in_tree // returns true if given value exists in the tree
//     - [ ] get_height // returns the height in nodes (single node's height is 1)
//     - [x] get_min   // returns the minimum value stored in the tree
//     - [x] get_max   // returns the maximum value stored in the tree
//     - [ ] is_binary_search_tree
//     - [x] delete_value
//     - [x] get_successor // returns next-highest value in tree after given value, -1 if none

abstract contract BST {

    struct Node {
        bytes32 parentPtr;
        uint value;
        // where ptrs[0] is left and ptrs[1] is right
        bytes32[2] ptrs;
    }


    uint private rootNonce;
    mapping(bytes32 => Node) internal nodes;

    // need to keep track of current node and next node. If the place the value should be is between node and next, it wasn't found
    function find(bytes32 rootPtr, uint value) public view returns(bool found, bytes32 nodePtr) {
        nodePtr = rootPtr;
        Node memory node = nodes[nodePtr];
        Node memory next;

        while(node.value != value) {

            uint ptrIdx = value < node.value ? 0 : 1;
            next = nodes[node.ptrs[ptrIdx]];
            uint high = ptrIdx == 0 ? node.value : next.value;
            uint low = ptrIdx == 0 ? next.value : node.value;
            if((value < high && value > low) || node.ptrs[ptrIdx] == bytes32(0)) return(false, nodePtr);
            nodePtr = node.ptrs[ptrIdx];
            
            node = next;

        }

        return(true, nodePtr);

    }

    function newRoot(uint value) public returns(bytes32 rootPtr) {
        rootPtr = keccak256(abi.encode(rootNonce));
        nodes[rootPtr].value = value;
        ++rootNonce;
    }

    // error valueExists();
    function insert(bytes32 rootPtr, uint value) public returns(bytes32) {
        (bool found, bytes32 parentPtr) = find(rootPtr, value);
        // if(found) revert valueExists();
        if(found) return bytes32(0);
        bytes32 newLoc = keccak256(abi.encode(rootPtr, value));

        uint ptrIdx = value < nodes[parentPtr].value ? 0 : 1;
        // need to populate a separate array to pass in constructing the new node
        bytes32[2] memory ptrs;
        ptrs[ptrIdx] = nodes[parentPtr].ptrs[ptrIdx];
        // insert node with parent = parentPtr, leftPtr = parent's old left child
        nodes[newLoc] = Node(parentPtr, value, ptrs);

        // update old child to have new parent
        nodes[nodes[parentPtr].ptrs[ptrIdx]].parentPtr = newLoc;
        // update parent to have new child
        nodes[parentPtr].ptrs[ptrIdx] = newLoc;

        return newLoc;
    }

    /// @notice gets next highest value
    /// @param rootPtr node location the search starts from
    /// @param value the value being searched for
    /// @return successorPtr location of the successor. Returns 0x0 if there is no successor
    /// @return successorValue value of the successor. Returns 0 if there is no successor.
    function get_successor(bytes32 rootPtr, uint value) public view returns(bytes32 successorPtr, uint successorValue) {
        
        (bool found, bytes32 nodePtr) = find(rootPtr, value);
        if(!found) {
            return(bytes32(0), 0);
        }

        if(found) {
            // find smallest value in right branch if exists
            if(nodes[nodePtr].ptrs[1] != bytes32(0)) {
                (successorPtr, successorValue) = get_min(nodes[nodePtr].ptrs[1]);
            // else find the largest value in the left branch
            } else if(nodes[nodePtr].ptrs[0] != bytes32(0)) {
                (successorPtr, successorValue) = get_max(nodes[nodePtr].ptrs[0]);
            // else no successor
            } else {
                return(bytes32(0), 0);
            }
        }
    }

    /// @notice Deletes `value` from a binary search tree
    /// @param rootPtr node location the search starts from
    /// @param value the value being searched for
    /// @return true if the value was found (and thus deleted), false if not.
    function delete_value(bytes32 rootPtr, uint value) public returns(bool) {
        // find the value, return false if not found
        (bool found, bytes32 nodePtr) = find(rootPtr, value);
        // if it has no children, remove the child pointer from the parent
        if(found && uint(nodes[nodePtr].ptrs[0]) + uint(nodes[nodePtr].ptrs[1]) == 0) {
            uint ptrIdx = value < nodes[nodes[nodePtr].parentPtr].value ? 0 : 1;
            // drop parent node's reference to child
            nodes[nodes[nodePtr].parentPtr].ptrs[ptrIdx] = bytes32(0);
            delete(nodes[nodePtr]);
        }
        // if it has children, get_successor and replace node with successor
        else if(found) {
            // switch node and successor's value
            (bytes32 successorPtr, uint successorValue) = get_successor(nodePtr, value);
            nodes[nodePtr].value = successorValue;
            // drop successor's parent node's reference to old child
            uint ptrIdx = value < nodes[nodes[successorPtr].parentPtr].value ? 0 : 1;
            nodes[nodes[successorPtr].parentPtr].ptrs[ptrIdx] = bytes32(0);
            delete(nodes[successorPtr]);
        }

        return found;
    }

    function is_in_tree(bytes32 rootPtr, uint value) public view returns(bool found) {
        (found, ) = find(rootPtr, value);
    }

    function get_limit(bytes32 rootPtr, bool min) private view returns(bytes32 nodePtr, uint val) {
        uint ptrIdx = min ? 0 : 1;
        nodePtr = rootPtr;
        val = nodes[nodePtr].value;

        Node memory next = nodes[nodePtr];

        while(next.ptrs[ptrIdx] != bytes32(0)) {
            nodePtr = next.ptrs[ptrIdx];
            next = nodes[nodePtr];
        }
        val = nodes[nodePtr].value;
    }

    function get_min(bytes32 rootPtr) public view returns(bytes32 nodePtr, uint val) {
        (nodePtr, val) = get_limit(rootPtr, true);
    }

    function get_max(bytes32 rootPtr) public view returns(bytes32 nodePtr, uint val) {
        (nodePtr, val) = get_limit(rootPtr, false);
    }
}