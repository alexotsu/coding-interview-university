// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/hashTable/HashTable.sol";

contract HashTableTest is Test {
  HashTable hashTable;
  function setUp() public {
    hashTable = new HashTable();
  }

  function testAdd(uint val) public {
    uint _hash = hashTable.add(val);
    assertTrue(hashTable.exists(_hash));
  }

  function testGet(uint val) public {
    uint k = hashTable.add(val);
    uint[] memory vals = hashTable.get(k);
    assertEq(vals.length, 1);
    assertEq(vals[0], val);
  }

  function testRemove(uint val) public {
    uint k = hashTable.add(val);
    hashTable.remove(k);
    vm.expectRevert(HashTable.noValue.selector);
    hashTable.get(k);
  }
}