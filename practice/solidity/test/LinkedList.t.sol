// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/baseStructures/LinkedList.sol";

contract LinkedListTest is Test {
  LinkedList linkedList;
  uint maxListLength = 100;
  function setUp() public {
    linkedList = new LinkedList();
    for(uint i = 0; i < maxListLength; ++i) {
      linkedList.push_front(i);
    }
  }

  function testPushFront() public {
    assertEq(linkedList.value_at(maxListLength - 1), 0); // first item should be most recently pushed to the front
    assertEq(linkedList.value_at(0), maxListLength - 1); // last item should be first pushed to the front
  }

  function testPopFront() public {
    uint listLength = linkedList.size();
    linkedList.pop_front();
    assertEq(linkedList.size(), listLength - 1);
    assertEq(linkedList.value_at(0), listLength - 2);
  }

  function testPushBack(uint val) public {
    uint listLength = linkedList.size();
    linkedList.push_back(val);
    assertEq(linkedList.size(), listLength + 1);
    assertEq(linkedList.value_at(listLength), val);
  }

  function testPopBack() public {
    uint listLength = linkedList.size();
    linkedList.pop_back();
    assertEq(linkedList.size(), listLength - 1);
    assertEq(linkedList.value_at(listLength - 2), 1);
  }

  function testFrontBack() public {
    assertEq(linkedList.front(), maxListLength - 1);
    assertEq(linkedList.back(), 0);
  }

  function testInsert(uint index) public {
    uint valToInsert = 10;
    // vm.assume(index <= maxListLength);
    if(index >= maxListLength) {
      vm.expectRevert(LinkedList.OutOfRange.selector);
      linkedList.value_at(index);
    } else {
      uint oldSize = linkedList.size();
      // get old value at index
      uint oldValAtIndex = linkedList.value_at(index);

      // insert
      linkedList.insert(index, valToInsert);
      // check that size is old size + 1
      assertEq(linkedList.size(), oldSize + 1);
      // check that new value at index is inserted val
      assertEq(linkedList.value_at(index), valToInsert);
      // check that value at index + 1 is old value
      assertEq(linkedList.value_at(index + 1), oldValAtIndex);
    }
  }

  function testErase(uint index) public {
    if(index >= maxListLength) {
      vm.expectRevert(LinkedList.OutOfRange.selector);
      linkedList.value_at(index);
    } else {
      uint oldSize = linkedList.size();
      // get value after index
      uint oldValAfterIndex = linkedList.value_at(index + 1);
      // erase node at index
      linkedList.erase(index);
      // check that new node at index is old node after index
      assertEq(linkedList.value_at(index), oldValAfterIndex);
      assertEq(linkedList.size(), oldSize - 1);
    }
  }

  function testRemoveValue(uint value) public {
    bytes32 loc = linkedList.remove_value(value);
    if(value < maxListLength) {
      assertGt(uint(loc), uint(bytes32(0)));
    } else {
      assertEq32(loc, bytes32(0));
    }
  }
}