pragma solidity >= 0.8.0;

// - [ ] Implement using fixed-sized array:
//     - enqueue(value) - adds item at end of available storage
//     - dequeue() - returns value and removes least recently added element
//     - empty()
//     - full() // irrelevant

import './PointerArray.sol';

contract ArrayQueue is Store {
  function enqueue(string memory varName, uint value) public {
    push(varName, value);
  }

  function dequeue(string memory varName) public {
    deleteIndex(varName, 0);
  }

  function empty(string memory varName) public view returns(bool _empty) {
    _empty = isEmpty(varName);
  }

}