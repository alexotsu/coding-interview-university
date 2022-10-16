pragma solidity >= 0.8.0;

// - [ ] Implement using linked-list, with tail pointer:
//     - enqueue(value) - adds value at position at tail
//     - dequeue() - returns value and removes least recently added element (front)
//     - empty()

import './LinkedListWithTail.sol';

contract LinkedListQueue is LinkedListWithTail {
  function enqueue(uint value) public {
    push_back(value);
  }

  function dequeue() public {
    pop_front();
  }

  function empty() public override view returns(bool) {
    return uintList.size == 0;
  }
}