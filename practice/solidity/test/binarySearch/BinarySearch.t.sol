// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/binaryTrees/BinarySearch.sol";

contract BinarySearchTest is Test {
  BinarySearch binarySearch;
  function setUp() public {
    binarySearch = new BinarySearch();
  }

  function populateArray(uint max) internal view returns(uint[] memory){
    uint[] memory arr = new uint[](max);
    for(uint i = 0; i < max; ++i) {
      arr[i] = i;
    }
    return arr;
  }

  function testSearch(uint max, uint searchVal) public {
    vm.assume(max > 0 && max < 50);
    vm.assume(searchVal < max * 2);
    uint[] memory arr = populateArray(max);
    (bool success, uint index, uint runs) = binarySearch.search(arr, searchVal);
    if(max <= searchVal) {
      // should return false for `found` because max should not be in the set.
      assertFalse(success);
    } else {
      // should return true and also the index, which would be val - 1
      assertTrue(success, "did not return true");
      assertEq(searchVal, index);
      // console log the # of runs to sanity check
      console.log(runs);
    }
  }
}