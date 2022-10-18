// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
// import "../src/Counter.sol";
import "../src/PointerArray.sol";

contract ArrayTest is Test {
    Store public store;
    string varName = 'arr';
    function setUp() public {
       store = new Store();
       bytes32 loc = store.initializeArray(varName);
    }

    function seedArray(uint size) private returns(uint lastVal) {
        lastVal = uint(keccak256(abi.encode(block.number)));
        for(uint i = 0; i < size; ++i) {
            lastVal = uint(keccak256(abi.encode(lastVal)));
            store.push(varName, lastVal);
        }
    }

    function testPush(uint val) public {
        assertTrue(store.isEmpty(varName));

        store.push(varName, val);
        assertEq(store.atIndex(varName, 0), val);

        assertEq(store.size(varName), 1);
    }

    // function testGenericShift()

    function testInsert(uint size, uint index, uint item) public {
        vm.assume(size < 100 && size > 0 && index < size);
        
        uint lastVal = seedArray(size);
        uint oldAtIndex;
        uint afterIndex;

        // conditional to not have to deal with out of range errors for new memory locations of values
        if(size > 5 && index > 0 && index < size - 1) {
            uint oldAtIndex = store.atIndex(varName, index);
            uint afterIndex = store.atIndex(varName, index + 1);
        }

        store.insert(varName, index, item);

        assertEq(store.size(varName), size + 1, "error: size does not match");
        assertEq(store.atIndex(varName, index), item, "error: wrong value at index");

        // conditional to not have to deal with out of range errors for new memory locations of values
        if(size > 5 && index > 0 && index < size - 1) {
            assertEq(store.atIndex(varName, index - 1), oldAtIndex, "error: values did not shift");
            assertEq(store.atIndex(varName, index + 1), afterIndex, "error: values did not shift");
        }
    }

    function testPrepend(uint val) public {
        uint arrSize = 10;
        uint lastVal = seedArray(arrSize);
        store.prepend(varName, val);
        assertEq(store.size(varName), arrSize + 1);
        assertEq(store.atIndex(varName, 0), val);
    }

    function testPop() public {
        uint arrSize = 10;
        uint lastVal = seedArray(arrSize);
        lastVal = store.atIndex(varName, arrSize - 2);
        store.pop(varName);
        assertEq(store.size(varName), arrSize - 1);
        assertEq(store.atIndex(varName, store.size(varName) - 1), lastVal);
    }

    function testDelete(uint size, uint index) public {
        vm.assume(size < 100 && size > 0 && index < size);
        
        uint lastVal = seedArray(size);
        uint beforeIndex;
        uint afterIndex;

        // conditional to not have to deal with out of range errors for new memory locations of values
        if(size > 5 && index > 0 && index < size - 1) {
            uint beforeIndex = store.atIndex(varName, index - 1);
            uint afterIndex = store.atIndex(varName, index + 1);

            store.deleteIndex(varName, index);

            assertEq(store.size(varName), size - 1, "error: size does not match");
            if(size / index < 2 || size < 3) { // left items shifted right
                assertEq(store.atIndex(varName, index), beforeIndex, "error: wrong value at index");
            } else {
                assertEq(store.atIndex(varName, index), afterIndex, "error: wrong value at index");
            }
        } else if (index < size - 1 && index > 0) {
            store.deleteIndex(varName, index);
            assertEq(store.size(varName), size - 1, "error: size does not match");
            assertEq(store.atIndex(varName, index), afterIndex, "error: wrong value at index");
        }

    }

    function testFind() public {
        uint size = 10;
        uint lastVal = seedArray(size);
        (bool wasFound, uint index) = store.find(varName, lastVal);
        assertTrue(wasFound);
        assertEq(index, size - 1);
        assertEq(store.uintAtIndex(varName, index), lastVal);
    }
}
