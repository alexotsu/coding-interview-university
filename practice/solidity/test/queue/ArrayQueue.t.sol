// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/queue/ArrayQueue.sol";

contract TestArrayQueue is Test {
  ArrayQueue queue;
  string varName = 'arr';
  function setUp() public {
    queue = new ArrayQueue();
    bytes32 loc = queue.initializeArray(varName);
    seedArray(10);
  }

  function seedArray(uint size) private returns(uint i) {
    for(i; i < size; ++i) {
      queue.push(varName, i);
    }
  }

  function testEnqueue() public {
    for(uint i = 0; i < 10; ++i) {
      assertEq(queue.atIndex(varName, i), i);
    }
  }

  function testDequeue() public {
    queue.deleteIndex(varName, 0);
    assertEq(queue.size(varName), 9);
    assertEq(queue.atIndex(varName, 0), 1);
  }
}