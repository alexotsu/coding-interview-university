pragma solidity >= 0.8.15;

// [ ] Implement a vector (mutable array with automatic resizing):
// [ ] Practice coding using arrays and pointers, and pointer math to jump to an index instead of using indexing.
// [x] New raw data array with allocated memory
// can allocate int array under the hood, just not use its features
// start with 16, or if starting number is greater, use power of 2 - 16, 32, 64, 128 // irrelevant
// [x] size() - number of items
// [ ] capacity() - number of items it can hold // irrelevant
// [x] is_empty()
// [x] at(index) - returns item at given index, blows up if index out of bounds // {type}atIndex
// [x] push(item)
// [x] insert(index, item) - inserts item at index, shifts that index's value and trailing elements to the right // will shift right or left along storage
// [x] prepend(item) - can use insert above at index 0
// [x] pop() - remove from end, return value
// [x] delete(index) - delete item at index, shifting all trailing elements left // will shift right or left along storage
// [x] remove(item) - looks for value and removes index holding it (even if in multiple places)
// [ ] find(item) - looks for value and returns first index with that value, -1 if not found
// [ ] resize(new_capacity) // private function // irrelevant
// when you reach capacity, resize to double the size
// when popping an item, if size is 1/4 of capacity, resize to half

library Storage {

    struct GenericArray {
        bytes32 start;
        uint256 size;
    }

    function GenericArrayPtr(string memory varName) internal pure returns(GenericArray storage data) {
        bytes32 ptr = keccak256(abi.encode(varName));
        assembly {
            data.slot := ptr
        }
    }

    function initializeArray(string memory varName) internal returns(GenericArray storage data) {
      data = GenericArrayPtr(varName);
      require(data.start == 0, "Array already initialized");
      data.start = keccak256(abi.encode(varName,0));
      data.size = 0;
    }

    function size(GenericArray storage input) internal view returns(uint256 _size) {
      _size = input.size;
    }

    function isEmpty(GenericArray storage input) internal view returns(bool _isEmpty) {
      _isEmpty = size(input) == 0;
    }

    /** Start uint256 functions */
    function push(GenericArray storage input, uint256 val) internal {
        bytes32 slot = bytes32(uint256(input.start) + input.size);

        ++input.size;

        assembly {
            sstore(slot, val)
        }
    }

    function uintAtIndex(GenericArray storage input, uint256 index) internal view returns(uint256 val) {
        require(input.size > index, "error uintAtIndex: out of range");
        bytes32 ptr = bytes32(uint256(input.start) + index);
        assembly {
            val := sload(ptr)
        }
    }

    // @param startIndex values starting at and including startIndex will be shifted
    // @param shiftDistance distance to shift array values
    // @param append true if expanding array, false if deleting from array.
    // @return indexLoc: for appends, first empty storage location. For deletes, storage location of first deleted item.
    function genericShiftItems(GenericArray storage input, uint startIndex, uint shiftDistance, bool append) public returns(bytes32 indexLoc) {

      if(append) {
        if(startIndex == 0) { // if prepend
          input.start = bytes32(uint256(input.start) - shiftDistance);
        } else {
          bool shiftLeft = startIndex < (input.size / 2) || input.size < 3; // if index is left of middle, shift left items left. Requires updating input.start
          if(shiftLeft) {
            for(uint i = uint(input.start); i < uint(input.start) + startIndex; ++i) {
              bytes32 ptr = bytes32(i);
              assembly {
                sstore(sub(ptr, shiftDistance), sload(ptr))
              }
            }
            input.start = bytes32(uint256(input.start) - shiftDistance);
          } else {
            for(uint i = uint(input.start) + input.size - 1; i >= uint(input.start) + startIndex; --i) {
              bytes32 ptr = bytes32(i);
              assembly {
                sstore(add(ptr, shiftDistance), sload(ptr))
              }
            }
          }
        }

        ++input.size;

      } else { // if not append
        if(startIndex == 0) { // if remove index[0]
          input.start = bytes32(uint256(input.start) + shiftDistance);
        } else {
          bool shiftLeft = startIndex < (input.size / 2) || input.size < 3;
          if(shiftLeft) {
            for(uint i = uint(input.start) + startIndex; i > uint(input.start); --i) {
              bytes32 ptr = bytes32(i);
              assembly {
                sstore(ptr, sload(sub(ptr, shiftDistance))) // copy the value one slot to the left into the current slot
              }
            }
            input.start = bytes32(uint256(input.start) + shiftDistance);
          } else {
            for(uint i = uint(input.start) + startIndex; i < uint(input.start) + input.size; ++i) {
              bytes32 ptr = bytes32(i);
              assembly {
                sstore(ptr, sload(add(ptr, shiftDistance)) )// copy the value one slot to the right into the current slot
              }
            }
          }
        }

        --input.size;

      }

      return bytes32(uint(input.start) + startIndex);

    }

    function insert(GenericArray storage input, uint256 index, uint256 item) internal {
      require(input.size > index);
      bytes32 newLoc = genericShiftItems(input, index, 1, true);
      assembly {
        sstore(newLoc, item)
      }
    }

    function prepend(GenericArray storage input, uint256 item) internal {
      insert(input, 0, item);
    }

    function pop(GenericArray storage input) internal {
      require(input.size > 0, 'error pop: nothing to pop');
      genericShiftItems(input, input.size - 1, 1, false);
    }

    function deleteIndex(GenericArray storage input, uint index) internal {
      require(input.size > index, 'error deleteIndex: out of bounds');
      genericShiftItems(input, index, 1, false);
    }

    function remove(GenericArray storage input, uint item) internal returns(uint found) {
      found;
      for(uint i = 0; i < input.size; ++i) {
        if(uintAtIndex(input, i) == item) {
          genericShiftItems(input, i, 1, false);
          ++found;
        }
      }
    }

    function replace(GenericArray storage input, uint index, uint item) internal {
      bytes32 slot = bytes32(uint256(input.start) + index);

      assembly {
        sstore(slot, item)
      }
    }

    function find(GenericArray storage input, uint item) public view returns(bool, uint){
      for(uint i = 0; i < input.size; ++i) {
        if(uintAtIndex(input, i) == item) {
          return(true, i);
        }
      }
      
      return(false, 0);

    }

    /** End uint256 functions */

}


// Dummy contract for testing
contract Store {
    using Storage for *;
    using Storage for string;

    function initializeArray(string memory varName) public returns(bytes32 start) {
      Storage.GenericArray storage arr = varName.initializeArray();
      return arr.start;
    }

    function push(string memory varName, uint256 val) public {
      Storage.push(varName.GenericArrayPtr(), val);
    }

    function size(string memory varName) public view returns(uint) {
      return Storage.size(varName.GenericArrayPtr());
    }

    function isEmpty(string memory varName) public view returns(bool) {
      return Storage.isEmpty(varName.GenericArrayPtr());
    }

    function atIndex(string memory varName, uint256 index) public view returns(uint256) {
      return Storage.uintAtIndex(varName.GenericArrayPtr(), index);
    }

    function insert(string memory varName, uint index, uint item) public {
      Storage.insert(varName.GenericArrayPtr(), index, item);
    }

    function uintAtIndex(string memory varName, uint index) public view returns(uint) {
      return Storage.uintAtIndex(varName.GenericArrayPtr(), index);
    }

    function prepend(string memory varName, uint item) public {
      Storage.prepend(varName.GenericArrayPtr(), item);
    }

    function pop(string memory varName) public {
      Storage.pop(varName.GenericArrayPtr());
    }

    function deleteIndex(string memory varName, uint index) public {
      Storage.deleteIndex(varName.GenericArrayPtr(), index);
    }

    function remove(string memory varName, uint item) public {
      Storage.remove(varName.GenericArrayPtr(), item);
    }

    function replace(string memory varName, uint index, uint item) public {
      Storage.replace(varName.GenericArrayPtr(), index, item);
    }

    function find(string memory varName, uint item) public view returns(bool, uint) {
      return Storage.find(varName.GenericArrayPtr(), item);
    }

    function returnFullArray(string memory varName) public view returns(uint[] memory arr) {
      for(uint i = 0; i < size(varName); ++i) {
        arr[i] = uintAtIndex(varName, i);
      }
    }
    
}