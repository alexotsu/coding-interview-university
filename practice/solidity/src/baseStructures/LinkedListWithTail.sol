pragma solidity >= 0.8.0;

import './StorageLinkedList.sol';

/// @title Linked List
/// @author Alex Otsu
/// @notice Implementation of a one-way linked list
/// @dev This is probably the least efficient way it could be implemented, would be much more readable to store the ListNode struct in a mapping. Is mostly to get a feel for manipulating storage directly
contract LinkedListWithTail {
  using StorageSlot for *;
  using StorageSlot for StorageSlot.UintListNode;

  StorageSlot.UintList uintList;


  error EmptyList();
  modifier notEmpty {
    if(uintList.size == 0) revert EmptyList();
    _;
  }

  function size() public view returns(uint) {
    return(uintList.size);
  }

  function empty() public virtual view returns(bool) {
    return size() == 0;
  }

  error OutOfRange();

  function node_at(uint index) internal view returns(StorageSlot.UintListNode storage node) {
    if (index >= uintList.size) revert OutOfRange();
    bytes32 next = uintList.head;
    uint i;
    
    while(i != index) {
      next = StorageSlot.getNode(next).next;
      ++i;
    }

    return StorageSlot.getNode(next);
  }

  function value_at(uint index) public view returns(uint) {
    if (index >= uintList.size) revert OutOfRange();
    return node_at(index).value;
  }

  function push_front(uint val) public {
    bytes32 nextLoc;
    if(uintList.size != 0) {
      nextLoc = uintList.head;
    }

    uintList.head = keccak256(abi.encode(uintList));
    
    if(uintList.size == 0) {
      uintList.tail = uintList.head;
    }

    StorageSlot.constructNode(uintList.head, val, nextLoc);

    uintList.size += 1;
  }

  function pop_front() public notEmpty {
    StorageSlot.UintListNode storage node = StorageSlot.getNode(uintList.head);
    bytes32 newLoc = StorageSlot.dereferenceNode(node);
    uintList.head = newLoc;
    uintList.size -= 1;
    if(newLoc == bytes32(0)) {
      uintList.tail = bytes32(0);
    }
  }

  function push_back(uint val) public returns(bytes32 newTail) {
    newTail = insert(uintList.size, val);
    uintList.tail = newTail;
  }

  function pop_back() public notEmpty {
    StorageSlot.UintListNode storage nextToLast = node_at(uintList.size - 2);
    StorageSlot.dereferenceNode(StorageSlot.getNode(nextToLast.next));
    nextToLast.next = bytes32(0);
    uintList.size -= 1;
    
    bytes32 newTail;
    assembly {
      newTail := nextToLast.slot
    }
    uintList.tail = newTail;
  }

  function front() public view notEmpty returns(uint) {
    StorageSlot.UintListNode storage node = StorageSlot.getNode(uintList.head);
    return node.value;
  }

  function back() public view notEmpty returns(uint) {
    StorageSlot.UintListNode storage lastNode = StorageSlot.getNode(uintList.tail);
    return lastNode.value;
  }

  function insert(uint index, uint val) public returns (bytes32 newLoc) {
    // bounds checking. If index == uintList.size, equivalent to push_back(val)
    if (index > uintList.size) revert OutOfRange();

    if (index == 0) { // case where list head needs to be updated
      push_front(val);
    } else { // everywhere else
      // get node before index
      StorageSlot.UintListNode storage beforeIndex = node_at(index - 1);
      // add a new node after beforeIndex
      newLoc = StorageSlot.setNode(beforeIndex, val);
      // increase uintList size
      uintList.size += 1;      
    }
  }

  function erase(uint index) public {
    // bounds checking
    if (index >= uintList.size) revert OutOfRange();
    if (index == 0) { // if the head needs to be updated
      pop_front();
    } else if (index == uintList.size - 1) { // if tail needs to be updated
      pop_back();
    } else {
      // find node before and nodeAtIndex
      StorageSlot.UintListNode storage beforeIndex = node_at(index - 1);
      StorageSlot.UintListNode storage atIndex = StorageSlot.getNode(beforeIndex.next);
      // dereference node and use returned value (atIndex.next) as beforeIndex.next
      beforeIndex.next = StorageSlot.dereferenceNode(atIndex);
      uintList.size -= 1;
    }

  }

  function value_n_from_end(uint n) public view returns(uint) { // returns the value of the node at nth position from the end of the list
    if (n >= uintList.size) revert OutOfRange();
    return value_at((uintList.size - 1) - n);
  }
}