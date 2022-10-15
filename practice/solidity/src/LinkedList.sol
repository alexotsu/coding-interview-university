pragma solidity >= 0.8.0;

  // - [ ] Implement (I did with tail pointer & without):
  //     - [x] size() - returns number of data elements in list
  //     - [x] empty() - bool returns true if empty
  //     - [x] value_at(index) - returns the value of the nth item (starting at 0 for first)
  //     - [x] push_front(value) - adds an item to the front of the list
  //     - [x] pop_front() - remove front item and return its value
  //     - [x] push_back(value) - adds an item at the end
  //     - [x] pop_back() - removes end item and returns its value
  //     - [x] front() - get value of front item
  //     - [x] back() - get value of end item
  //     - [x] insert(index, value) - insert value at index, so current item at that index is pointed to by new item at index
  //     - [x] erase(index) - removes node at given index
  //     - [x] value_n_from_end(n) - returns the value of the node at nth position from the end of the list
  //     - [ ] reverse() - reverses the list
  //     - [ ] remove_value(value) - removes the first item in the list with this value

library StorageSlot {

  struct UintList {
    bytes32 head;
    uint size;
  }

  struct UintListNode {
    bool initialized;
    uint value;
    bytes32 next; // in-storage location
  }

  function getNode(bytes32 loc) internal pure returns(UintListNode storage node) {
    assembly {
      node.slot := loc
    }
  }

  function setNode(UintListNode storage node, uint val) internal returns(bytes32 newNodeLoc) {
    bytes32 nextLoc = keccak256(abi.encode(node));
    UintListNode storage newNode = constructNode(nextLoc, val, node.next);
    node.next = nextLoc;
    assembly {
      newNodeLoc := newNode.slot
    }
  }

  function constructNode(bytes32 loc, uint val, bytes32 next) internal returns(UintListNode storage newNode) {
    newNode = getNode(loc);
    require(newNode.initialized == false, "error: node already initialized"); // need to remember to delete `initialized` upon removing node
    newNode.initialized = true;
    newNode.value = val;
    newNode.next = next;
  }

  function dereferenceNode(UintListNode storage node) internal returns(bytes32 next) {
    node.initialized = false;
    next = node.next;
  }

}


/// @title Linked List
/// @author Alex Otsu
/// @notice Implementation of a one-way linked list
/// @dev This is probably the least efficient way it could be implemented, would be much more readable to store the ListNode struct in a mapping. Is mostly to get a feel for manipulating storage directly
contract LinkedList {
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

  function empty() public view returns(bool) {
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
    StorageSlot.constructNode(uintList.head, val, nextLoc);
    uintList.size += 1;
  }

  function pop_front() public notEmpty {
    StorageSlot.UintListNode storage node = StorageSlot.getNode(uintList.head);
    bytes32 newLoc = StorageSlot.dereferenceNode(node);
    uintList.head = newLoc;
    uintList.size -= 1;
  }

  function push_back(uint val) public {
    insert(uintList.size, val);
  }

  function pop_back() public notEmpty {
    StorageSlot.UintListNode storage nextToLast = node_at(uintList.size - 2);
    StorageSlot.dereferenceNode(StorageSlot.getNode(nextToLast.next));
    nextToLast.next = bytes32(0);
    uintList.size -= 1;
  }

  function front() public view notEmpty returns(uint) {
    StorageSlot.UintListNode storage node = StorageSlot.getNode(uintList.head);
    return node.value;
  }

  function back() public view notEmpty returns(uint) {
    StorageSlot.UintListNode storage lastNode = node_at(uintList.size - 1);
    return lastNode.value;
  }

  function insert(uint index, uint val) public {
    // bounds checking. If index == uintList.size, equivalent to push_back(val)
    if (index > uintList.size) revert OutOfRange();

    if (index == 0) { // case where list head needs to be updated
      push_front(val);
    } else { // everywhere else
      // get node before index
      StorageSlot.UintListNode storage beforeIndex = node_at(index - 1);
      // add a new node after beforeIndex
      StorageSlot.setNode(beforeIndex, val);
      // increase uintList size
      uintList.size += 1;
    }
  }

  function erase(uint index) public {
    // bounds checking
    if (index >= uintList.size) revert OutOfRange();
    if (index == 0) { // if the head needs to be updated
      pop_front();
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

  function remove_value(uint value) public returns(bytes32) {
    // store previous and current nodes
    // if value == currentNode.value, dereference currentNode and use return value as previousNode.next
    bytes32 prevNodePointer = uintList.head;

    if(StorageSlot.getNode(prevNodePointer).value == value) {
      pop_front();
    }
    uint i;
    while(i < uintList.size) {
      bytes32 currNodePointer = StorageSlot.getNode(prevNodePointer).next;
      // second check is for the edge case where the value being searched for == 0 and there is no 0 present. 
      if(StorageSlot.getNode(currNodePointer).value == value && StorageSlot.getNode(currNodePointer).initialized) {
        uintList.size -= 1;
        StorageSlot.getNode(prevNodePointer).next = StorageSlot.dereferenceNode(StorageSlot.getNode(currNodePointer));
        return prevNodePointer;
      }
      prevNodePointer = currNodePointer;
      ++i;
    }
    // return bytes32(0) if value not found
    return bytes32(0);
  }
}