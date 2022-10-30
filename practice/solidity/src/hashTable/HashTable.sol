pragma solidity >= 0.8.0;

// - [ ] Implement with array using linear probing
//     - hash(k, m) - m is size of hash table
//     - add(key, value) - if key already exists, update value
//     - exists(key)
//     - get(key)
//     - remove(key)

contract HashTable {
  uint constant m = 100;
  // initializes array of arrays of size _m_, our hash table
  uint[][m] public keys;

  // returns key for a given value. Instructions to add directly to a value seems to defeat the purpose of a hash table so doing this instead.
  function hash(uint value) public pure returns(uint k) {
    // makes it so that keys[0] doesn't get overrepresented, since k % m == 0 whenever k < m.
    if(value < m && k != 0) k = m % value;
    k = value % m;
  }

  function add(uint value) public returns(uint k) {
    k = hash(value);
    keys[k].push(value);
  }

  function exists(uint key) public view returns(bool) {
    return keys[key].length > 0;
  }

  error noValue();
  function get(uint key) public view returns(uint[] memory) {
    if(!exists(key)) revert noValue();
    return keys[key];
  }

  function remove(uint key) public {
    if(!exists(key)) revert noValue();
    delete keys[key];
  }
  
}