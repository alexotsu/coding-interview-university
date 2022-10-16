pragma solidity >= 0.8.0;

library StorageSlot {

  struct UintList {
    bytes32 head;
    bytes32 tail;
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
