// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/LinkedListQueue.sol";

contract LinkedListQueueTest is Test {
  LinkedListQueue queue;
  uint maxListLength = 100;
  function setUp() public {
    queue = new LinkedListQueue();
    for(uint i = 0; i < maxListLength; ++i) {
      queue.enqueue(i);
    }
  }
  function testEnqueue(uint value) public {
    assertEq(queue.back(), maxListLength - 1);
  }

  function testDequeue() public {
    queue.dequeue();
    assertEq(queue.front(), 1);
  }
}