pragma solidity >= 0.8.15;

import '../baseStructures/PointerArray.sol';

/**
- [ ] Implement a max-heap:
    - [x] insert
    - [x] sift_up - needed for insert
    - [x] get_max - returns the max item, without removing it
    - [x] get_size() - return number of elements stored
    - [x] is_empty() - returns true if heap contains no elements
    - [x] extract_max - returns the max item, removing it
    - [x] sift_down - needed for extract_max
    - [x] remove(x) - removes item at index x
    - [ ] heapify - create a heap from an array of elements, needed for heap_sort
    - [ ] heap_sort() - take an unsorted array and turn it into a sorted array in-place using a max heap or min heap

 */

contract Heap is Store {
    mapping(bytes32 => uint) public heapRoots;

    function get_max(string memory varName) public view returns(uint) {
        return atIndex(varName, 0);
        // return heapRoots[heapRoot][0];
    }

    function is_empty(string memory varName) public view returns(bool) {
        return size(varName) > 0 ? true : false;
        // return get_size(heapRoot) > 0 ? true : false;
    }

    function get_size(string memory varName) public view returns(uint) {
        return size(varName);
        // return heapRoots[heapRoot].length;
    }

    function getParentIndex(uint index) private pure returns(uint) {
        return ((index - 1) / 2);
    }

    function getChildIndices(uint index) private pure returns(uint left, uint right) {
        left = (index * 2) + 1;
        right = (index * 2) + 2;
    }

    function sift_up(string memory varName, uint index) internal {
        uint parentIndex = getParentIndex(index);
        while(atIndex(varName, parentIndex) > atIndex(varName, index)) {
            uint tmpIdxVal = atIndex(varName, index);
            replace(varName, index, atIndex(varName, parentIndex));
            replace(varName, parentIndex, tmpIdxVal);
            index = parentIndex;
            parentIndex = getParentIndex(index);
        }
        // while(heapRoots[heapRoot][parentIndex] > heapRoots[heapRoot][index]) {
        //     uint tmpIdxVal = heapRoots[heapRoot][index];
        //     heapRoots[heapRoot][index] = heapRoots[heapRoot][parentIndex];
        //     heapRoots[heapRoot][parentIndex] = tmpIdxVal;
        //     index = parentIndex;
        //     parentIndex = getParentIndex(index);
        // }
    }

    function insert(string memory varName, uint value) public {
        push(varName, value);
        sift_up(varName, get_size(varName) - 1);
    }

    function extract_max(string memory varName) public returns(uint max) {
        max = get_max(varName);
        deleteIndex(varName, 0);
    }

    function sift_down(string memory varName, uint index) internal {
        // while val is larger than either of its children
            // switch val with the larger val
            // val = child val
        (uint left, uint right) = getChildIndices(index);
        while(atIndex(varName, index) < uintAtIndex(varName, left) || atIndex(varName, index) < uintAtIndex(varName, right)) {
            uint nodeVal = uintAtIndex(varName, index);
            uint leftVal = uintAtIndex(varName, left);
            uint rightVal = uintAtIndex(varName, right);
            if(nodeVal < leftVal || nodeVal < rightVal) {
                uint tmpIdxVal = atIndex(varName, index);
                // switch with whichever is larger
                if(leftVal >= rightVal) {
                    replace(varName, index, leftVal);
                    replace(varName, left, tmpIdxVal);
                    index = left;
                } else {
                    replace(varName, index, rightVal);
                    replace(varName, right, tmpIdxVal);
                    index = right;
                }
            }
            (left, right) = getChildIndices(index);
        }
    }

    function remove_node(string memory varName, uint index) public {
        replace(varName, index, atIndex(varName, get_size(varName) - 1));
        pop(varName);
        sift_down(varName, 0);
    }

    function heapify(string memory varName) public {
        // 
    }
        

}