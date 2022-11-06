pragma solidity >=0.8.0;



contract BitPractice {
// from https://www.techiedelight.com/bit-hacks-part-1-basic/
// Problem 1. Check if an integer is even or odd
    function isOdd(uint val) public pure returns(bool _isOdd) {
        assembly {
            _isOdd := eq(and(val, 0x1), 0x1)
        }
    }

// Problem 2. Detect if two integers have opposite signs or not
    function detectDifferentSigns(int val1, int val2) public pure returns(bool areDifferent) {
        assembly {
            let comp := xor(val1, val2)
            areDifferent := shr(255, comp)
        }
    }

// Problem 3. Add 1 to an integer
    function addOne(int val) public pure returns(int newVal) {
        assembly {
            // 0xffff... is -1 in 2's complement
            newVal := mul(not(val), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
        }
    }

// Problem 4. Swap two numbers without using any third variable
    function swapNumbers(uint a, uint b) public pure returns(uint newA, uint newB) {
        if(a == b) return(a, b);
        assembly {
            newA := xor(a, b)
            newB := xor(newA, b)
            newA := xor(newA, newB)
        }
    }

// Find the absolute value of an integer without branching)
    function abs(int a) public pure returns(int _abs) {
        assembly {
            let mask := mul(shr(255, a), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
            _abs := xor(add(a, mask), mask)
        }
    }

}