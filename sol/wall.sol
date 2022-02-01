/// SPDX-License-Identifier: AGPL-3.0

// DELEGATECALL-safe multi-user auth

pragma solidity 0.8.11;

contract Walls {
    mapping(address=>mapping(address=>bool)) public gates;
    event Gate(address indexed object, address indexed caller, bool indexed open);
    error Wall(address object, address caller);
    function wall(address caller) view external {
        if (!gates[msg.sender][caller]) revert Wall(msg.sender, caller);
    }
    function gate(address caller, bool open) external {
        gates[msg.sender][caller] = open;
        emit Gate(msg.sender, caller, open);
    }
    function give(address caller) external {
        gates[msg.sender][caller] = true;
        gates[address(this)][caller] = false;
	emit Gate(msg.sender, caller, true);
        emit Gate(address(this), caller, false);
    }
}

abstract contract Walled {
    Walls immutable public walls;
    constructor(Walls w) {
        walls = w;
    }
    modifier _wall_ {
        walls.wall(msg.sender);
        _;
    }
    function gate(address whom, bool open) external
      _wall_ {
        walls.gate(whom, open);
    }
    function give(address whom) external
      _wall_ {
        walls.give(whom);
    }
}