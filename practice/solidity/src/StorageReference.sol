pragma solidity ^0.8.7;

library StoragePure {

    function makeAddressPointer(string memory varName) internal pure returns(bytes32) {
        return keccak256(abi.encode(varName));
    }

    function get(bytes32 pointer) internal view returns(address addr) {
        assembly {
            addr := sload(pointer)
        }
    }

    function set(bytes32 pointer, address toSet) internal {
        assembly {
            sstore(pointer, toSet)
        }
    }
}

contract StorePure {
    using StoragePure for *;

    
    function setVar(string memory varName, address addr) public returns(bytes32) {
        bytes32 addressPointer = StoragePure.makeAddressPointer(varName);
        StoragePure.set(addressPointer, addr);
        return addressPointer;
    }

    function getVarVal(bytes32 pointer) public view returns(address) {
        return StoragePure.get(pointer);
    }
    
}



library StorageStorage {
    struct Address {
        address data;
    }

    function makePtr(bytes32 location) internal pure returns(Address storage data) {
        assembly {
            data.slot := location
        }
    }

    function ptr(string memory varName) public pure returns(Address storage data) {
        bytes32 typehash = keccak256('address');
        bytes32 location = keccak256(abi.encodePacked(typehash, varName));
        return makePtr(location);
    }

    function get(Address storage input) public view returns(address) {
        return input.data;
    }

    function set(Address storage input, address setTo) public returns(bytes32 location) {
        input.data = setTo;
        assembly {
            location := input.slot
        }
    }
}

contract StoreStore {
    using StorageStorage for *;
    StorageStorage.Address a = StorageStorage.ptr('a');
    // bytes32 ptr = StorageStorage.set(a, address(this));
    function setVar(string memory varName, address setTo) public {
        StorageStorage.Address storage a = StorageStorage.ptr(varName);
        StorageStorage.set(a, setTo);
    }

    function getVar(string memory varName) public view returns(address) {
        StorageStorage.Address storage a = StorageStorage.ptr(varName);
        return StorageStorage.get(a);
    }
}

library StorageInline {
    struct Address {
        address data;
    }

    function makePtr(bytes32 location) internal pure returns(Address storage data) {
        assembly {
            data.slot := location
        }
    }

    function ptr(string memory varName) public pure returns(Address storage data) {
        bytes32 typehash = keccak256('address');
        bytes32 location = keccak256(abi.encodePacked(typehash, varName));
        return makePtr(location);
    }

    function get(string memory varName) public view returns(address) {
        Address storage a = ptr(varName);
        return a.data;
    }

    function set(string memory varName, address setTo) public returns(bytes32 location) {
        Address storage a = ptr(varName);
        a.data = setTo;
        assembly {
            location := a.slot
        }
    }
}

contract StoreInline {
    using StorageInline for string;
    function setVar(string memory val) public returns(bytes32) {
        return val.set(address(this));
    }

    function getVar(string memory val) public view returns(address) {
        return val.get();
    }
}