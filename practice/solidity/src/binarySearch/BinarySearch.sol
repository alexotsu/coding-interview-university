pragma solidity >= 0.8.0;

// Find midpoint of array
// - if odd number of items in array, will round down. Need to account for the array item it missed
// - Maybe preferred behavior is just rounding up?


// _ _ _ _ _


// _ _ _ _ _ _ _ _ _ _ 
// 0 1 2 3 4 5 6 7 8 9

contract BinarySearch {
  // assumes sorted array
  // returns a bool specifying the value was found in case index == 0
  error emptyArray();
  function search(uint[] calldata arr, uint val) public pure returns(bool found, uint index, uint runs) {
    if(arr.length == 0) revert emptyArray();
    if(arr.length == 1 && arr[0] == val) {
      return(true, 0, 1); // hard-coding an edge success case.
    }
    bool searchLower; // if this is true, search the lower half of the section
    uint lowindex; // should be index 0
    uint midindex = arr.length / 2;
    uint highindex = arr.length - 1;
    while(lowindex != highindex) {
      ++runs;
      if(arr[midindex] == val) return(true, midindex, runs);
      searchLower = arr[midindex] > val; // search lower half if val is smaller than val@midindex
      if(searchLower) {
        highindex = midindex; // new upper bound is the old midindex
        midindex = (midindex + lowindex) / 2;
      } else {
        lowindex = midindex; // new lower bound is the old midindex
        midindex = roundUp(midindex + highindex);
      }
    }
    return(false, 0, runs);
  }

  function roundUp(uint arrLen) private pure returns(uint roundedVal) {
    if(arrLen % 2 == 1) {
      roundedVal = (arrLen + 1)/2;
    } else {
      roundedVal = arrLen / 2;
    }
    // roundedVal = arrLen % 2 == 1 ? (arrLen + 1)/2 : arrLen / 2;
  }
}