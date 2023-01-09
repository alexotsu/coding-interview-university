// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/binaryTrees/BSTImplementation.sol";

contract BSTTest is Test {
    uint constant MAX_RANGE = 100;
    BSTImplementation bst;
    function setUp() public {
        bst = new BSTImplementation();
    }

    uint[] public referenceMap;
    // test array
    uint[] public sortedMap;

    // // not straightforward populating the tree, since you want to start with a value that lives roughly in the middle and populate around it
    // function makeTree(uint seedVal, uint nodes) private returns(bytes32 root) {
    //     require(nodes < MAX_RANGE);
    //     bytes32 ptr = bst.newRoot(seedVal);
    //     for(uint i = 0; i < nodes; ++i) {
    //         bool inserted;
    //         uint val = i;
    //         // this puts seedVal at halfway through range
    //         uint start = seedVal - (MAX_RANGE / 2);
    //         // to ensure that there are no duplicate values
    //         while(!inserted) {
    //             val = start + (uint(keccak256(abi.encode(val))) % MAX_RANGE);
    //             inserted = bst.insert(ptr, val);
    //             referenceMap.push(val);
    //         }
    //     }
    // }

    // function testPrintTree() public returns(uint[] memory) {
    //     bytes32 rootPtr = makeTree(4214132, 50);
    //     (bytes32 minPtr, uint minVal) = bst.get_min(rootPtr);
    //     while(minPtr != bytes32(0)) {
    //         sortedMap.push(minVal);
    //         (minPtr, minVal) = bst.get_successor(rootPtr, minVal);
    //     }
    //     for(uint i = 0; i < sortedMap.length; ++i) {
    //         console.log(sortedMap[i]);
    //     }
    //     // return(sortedMap);
    // }

    function testInitialize() public {
        uint value = 100;
        bytes32 rootPtr = bst.newRoot(value);
        (bytes32 nodePtr, uint val) = bst.get_min(rootPtr);
        assertEq(nodePtr, rootPtr);
        assertEq(value, val);
    }

    function testInsert(uint insertedVal) public {
        uint value = 100;
        vm.assume(insertedVal > value - value || insertedVal < value * 2);
        bytes32 rootPtr = bst.newRoot(value);
        bst.insert(rootPtr, insertedVal);

        (bool found, bytes32 nodePtr) = bst.find(rootPtr, insertedVal);

        if(insertedVal > value) {
            (bytes32 minPtr, uint minVal) = bst.get_min(rootPtr);
            (bytes32 maxPtr, uint maxVal) = bst.get_max(rootPtr);
            assertEq(minVal, value);
            assertEq(maxVal, insertedVal);

            assertEq(nodePtr, maxPtr);
        } else {
            (bytes32 minPtr, uint minVal) = bst.get_min(rootPtr);
            (bytes32 maxPtr, uint maxVal) = bst.get_max(rootPtr);
            assertEq(minVal, insertedVal);
            assertEq(maxVal, value);

            assertEq(nodePtr, minPtr);
        }

    }

    function testInsertEnd(uint insertedVal) public returns(bytes32 rootPtr, bool left, bool notReturned) {
        uint value = 100;
        vm.assume(insertedVal > 0 && insertedVal < value * 2);
        rootPtr = bst.newRoot(value);
        bytes32 insertedLoc = bst.insert(rootPtr, insertedVal);

        if(insertedVal > value) {
            bytes32 newLoc = bst.insert(rootPtr, insertedVal + 1);
            (bool newPtrFound, bytes32 newNodePtr) = bst.find(rootPtr, insertedVal + 1);
            (bytes32 limitPtr, uint limitVal) = bst.get_max(rootPtr);
            assertTrue(newPtrFound);
            assertEq(limitPtr, newNodePtr);
            assertEq(newNodePtr, newLoc);
            assertEq(limitVal, insertedVal + 1);
            left = false;
        } else if (insertedVal < value) {
            bytes32 newLoc = bst.insert(rootPtr, insertedVal - 1);
            (bool newPtrFound, bytes32 newNodePtr) = bst.find(rootPtr, insertedVal - 1);
            (bytes32 limitPtr, uint limitVal) = bst.get_min(rootPtr);
            assertTrue(newPtrFound);
            assertEq(limitPtr, newNodePtr);
            assertEq(newNodePtr, newLoc);
            assertEq(limitVal, insertedVal - 1);
            left = true;
        } else {
            notReturned = true;
        }
    }

    function testInsertIntermediate(uint insertedVal) public returns(bytes32 rootPtr, bool left, bool notReturned) {
        uint value = 100;
        vm.assume(insertedVal > 0 && insertedVal < value * 2);
        // vm.assume(insertedVal > value + 1 && insertedVal < value - 1);
        rootPtr = bst.newRoot(value);
        bytes32 insertedPtr = bst.insert(rootPtr, insertedVal);

        // +/- 1 because the value _after_ insertedVal will be 1 closer to val
        if(insertedVal > value + 1) {
            bytes32 newLoc = bst.insert(rootPtr, insertedVal - 1);
            (bool newPtrFound, bytes32 newNodePtr) = bst.find(rootPtr, insertedVal - 1);
            (bytes32 limitPtr, uint limitVal) = bst.get_max(rootPtr);
            assertTrue(newPtrFound);
            assertEq(limitPtr, insertedPtr);
            assertEq(newNodePtr, newLoc);
            left = false;
        } else if(insertedVal < value - 1) {
            bytes32 newLoc = bst.insert(rootPtr, insertedVal + 1);
            (bool newPtrFound, bytes32 newNodePtr) = bst.find(rootPtr, insertedVal + 1);
            (bytes32 limitPtr, uint limitVal) = bst.get_min(rootPtr);
            assertTrue(newPtrFound);
            assertEq(limitPtr, insertedPtr);
            assertEq(newNodePtr, newLoc);
            left = true;
        } else {
            notReturned = true;
        }
    }

    function testDeleteEnd(uint val) public {
        (bytes32 rootPtr, bool left, bool notReturned) = testInsertIntermediate(val);
        bytes32 limitPtr;
        uint limitVal;
        if(!notReturned) {
            // if left, get_min
            if(left) {
                (limitPtr, limitVal) = bst.get_min(rootPtr);
                bst.delete_value(rootPtr, limitVal);
                // min should be the newly inserted intermediate val
                (bytes32 newLimitPtr, uint newLimitVal) = bst.get_min(rootPtr);
                assertEq(newLimitVal, limitVal + 1);
            } else {
                (limitPtr, limitVal) = bst.get_max(rootPtr);
                bst.delete_value(rootPtr, limitVal);
                (bytes32 newLimitPtr, uint newLimitVal) = bst.get_max(rootPtr);
                assertEq(newLimitVal, limitVal - 1);
            }
        }
    }

    function testDeleteIntermediate(uint val) public {
        (bytes32 rootPtr, bool left, bool notReturned) = testInsertEnd(val);
        bytes32 limitPtr;
        uint limitVal;

        if(!notReturned) {
            bool deleted = bst.delete_value(rootPtr, val);
            if(left) {
                (limitPtr, limitVal) = bst.get_min(rootPtr);
                // min should not have changed
                (bytes32 newLimitPtr, uint newLimitVal) = bst.get_min(rootPtr);
                assertTrue(deleted);
                assertEq(newLimitVal, limitVal);
            } else {
                (limitPtr, limitVal) = bst.get_max(rootPtr);
                // max should not have changed
                (bytes32 newLimitPtr, uint newLimitVal) = bst.get_max(rootPtr);
                assertTrue(deleted);
                assertEq(newLimitVal, limitVal);
            }
        }
    }
}