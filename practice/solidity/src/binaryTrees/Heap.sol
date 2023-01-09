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
    - [x] heapify - create a heap from an array of elements, needed for heap_sort
    - [x] heap_sort() - take an unsorted array and turn it into a sorted array in-place using a max heap or min heap

 */

contract Heap is Store {

    function get_max(string memory varName) public view returns(uint) {
        return atIndex(varName, 0);
        // return heapRoots[heapRoot][0];
    }

    function is_empty(string memory varName) public view returns(bool) {
        // return size(varName) > 0 ? true : false;
        return isEmpty(varName);
        // return get_size(heapRoot) > 0 ? true : false;
    }

    function get_size(string memory varName) public view returns(uint) {
        return size(varName);
        // return heapRoots[heapRoot].length;
    }

    function getParentIndex(uint index) private pure returns(uint) {
        return ((index - 1) / 2);
    }

    function getChildIndices(uint index) private pure returns(uint[2] memory children) {
        children[0] = (index * 2) + 1;
        children[1] = (index * 2) + 2;
    }

    function sift_up(string memory varName, uint index) internal {
        uint parentIndex = getParentIndex(index);
        while(atIndex(varName, parentIndex) < atIndex(varName, index)) {
            uint tmpIdxVal = atIndex(varName, index);
            replace(varName, index, atIndex(varName, parentIndex));
            replace(varName, parentIndex, tmpIdxVal);
            index = parentIndex;
            parentIndex = getParentIndex(index);
        }
    }

    function insert(string memory varName, uint value) public {
        push(varName, value);
        sift_up(varName, get_size(varName) - 1);
    }

    function extract_max(string memory varName) public returns(uint max) {
        max = get_max(varName);
        remove_node(varName, 0);
    }

    function getLargerChild(string memory varName, uint index, uint valAtIndex) private view returns(uint childIndex) {
    // if returns 0, you are at the correct node
        uint heapSize = size(varName);
        uint[2] memory children = getChildIndices(index);
        uint childrenCount;
        for(uint i = 0; i < children.length; ++i) {
            if(children[i] >= heapSize) {
                return childIndex;
            }

            if(uintAtIndex(varName, children[i]) > valAtIndex) {
                childIndex = children[i];
                valAtIndex = uintAtIndex(varName, children[i]);
            }
        }
    }   

    function sift_down(string memory varName, uint index) internal {
        uint largerChild = getLargerChild(varName, index, uintAtIndex(varName, index));
        while(largerChild != 0) {
            uint tmpIdxVal = uintAtIndex(varName, index);
            replace(varName, index, uintAtIndex(varName, largerChild));
            replace(varName, largerChild, tmpIdxVal);
            index = largerChild;
            largerChild = getLargerChild(varName, index, uintAtIndex(varName, index));
        }
    }

    function remove_node(string memory varName, uint index) public {
        replace(varName, index, atIndex(varName, get_size(varName) - 1));
        pop(varName);
        sift_down(varName, index);
    }

    function heapify(string memory varName) public {
        // for each node, starting from the back of the array
        // sift down
        bool heaped;
        uint i = size(varName) - 1;
        // would have preferred a for loop, but threw underflow errors when reaching i == 0 and trying to decrement
        while(!heaped) {
            sift_down(varName, i);
            if(i > 0) {
                --i;
            } else {
                heaped = true;
            }
        }
    }

    function heap_sort(string memory varName) public {
        uint originalSize = size(varName);
        for(uint i = 0; i < originalSize - 1; ++i) { // originalSize - 1 because the final iteration isn't needed, there will only be one item left
            uint tmpIdxVal = uintAtIndex(varName, 0);
            replace(varName, 0, uintAtIndex(varName, originalSize - (i + 1)));
            replace(varName, originalSize - (i + 1), tmpIdxVal);
            Storage.GenericArrayPtr(varName).size -= 1;
            sift_down(varName, 0);
        }

        Storage.GenericArrayPtr(varName).size = originalSize;
    }
        

}