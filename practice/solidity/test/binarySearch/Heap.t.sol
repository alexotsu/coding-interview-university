// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/binaryTrees/Heap.sol";

contract HeapTest is Test {
    Heap public heap;
    string varName = 'heap';
    uint heapLength = 10;

    function setUp() public {
        heap = new Heap();
        bytes32 loc = heap.initializeArray(varName);
    }

    function seedArray(uint[10] memory arrayFixture) private {
        for(uint i = 0; i < arrayFixture.length; ++i) {
            heap.push(varName, arrayFixture[i]);
        }
    }

    // // sift_down is an internal function, temporarily set to public for early testing
    // function testSiftDown() public {
    //     uint[10] memory arrayFixture = [uint(8), uint(27), uint(35), uint(16), uint(20), uint(31), uint(19), uint(7), uint(2), uint(15)];
    //     seedArray(arrayFixture);

    //     heap.sift_down(varName, 0);
    //     assertEq(heap.uintAtIndex(varName, 0), 35);
    //     assertEq(heap.uintAtIndex(varName, 5), 8);
    // }

    function testHeapify() public {
        uint[10] memory arrayFixture = [uint(38), uint(41), uint(27), uint(50), uint(11), uint(10), uint(40), uint(37), uint(34), uint(22)];
        seedArray(arrayFixture);

        heap.heapify(varName);

        assertEq(heap.uintAtIndex(varName, 0), 50);
        assertEq(heap.uintAtIndex(varName, 1), 41);
        assertEq(heap.uintAtIndex(varName, 2), 40);
        assertEq(heap.uintAtIndex(varName, 3), 38);
        assertEq(heap.uintAtIndex(varName, 4), 22);
        assertEq(heap.uintAtIndex(varName, 5), 10);
        assertEq(heap.uintAtIndex(varName, 6), 27);
        assertEq(heap.uintAtIndex(varName, 7), 37);
        assertEq(heap.uintAtIndex(varName, 8), 34);
        assertEq(heap.uintAtIndex(varName, 9), 11);
    }

    function testSort() public {
        testHeapify();
        heap.heap_sort(varName);

        uint v = heap.uintAtIndex(varName, 0);
        for(uint i = 1; i < heapLength; ++i) {
            assertLt(v, heap.uintAtIndex(varName, i));
            v = heap.uintAtIndex(varName, i);
        }
    }

    function testBasicFunctions() public {
        testHeapify();
        assertEq(heap.get_max(varName), 50);
        assertEq(heap.get_size(varName), 10);
        uint max = heap.extract_max(varName);

        assertEq(max, 50);
        assertEq(heap.get_max(varName), 41);
    }

    function testInsert() public {
        testHeapify();
        uint insertedVal = 31;
        heap.insert(varName, insertedVal);
        assertEq(heap.size(varName), 11);
        assertEq(heap.uintAtIndex(varName, 4), insertedVal);
        assertEq(heap.uintAtIndex(varName, heap.size(varName) - 1), 22);
    }

    function testRemove() public {
        testHeapify();
        uint indexToRemove = 3;
        heap.remove_node(varName, indexToRemove);
        assertEq(heap.size(varName), 9);
        assertEq(heap.uintAtIndex(varName, indexToRemove), 37);
    }

}