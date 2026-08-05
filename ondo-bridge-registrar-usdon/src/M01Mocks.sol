// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockInnerToken {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    mapping(bytes32 => mapping(address => bool)) public hasRole;
    mapping(address => uint256) public balanceOf;

    error MissingRole(bytes32 role, address account);

    function grantRole(bytes32 role, address account) external {
        hasRole[role][account] = true;
    }

    function mint(address to, uint256 amount) external {
        if (!hasRole[MINTER_ROLE][msg.sender]) {
            revert MissingRole(MINTER_ROLE, msg.sender);
        }
        balanceOf[to] += amount;
    }

    function burn(address from, uint256 amount) external {
        if (!hasRole[BURNER_ROLE][msg.sender]) {
            revert MissingRole(BURNER_ROLE, msg.sender);
        }
        balanceOf[from] -= amount;
    }
}

contract MockOndoOFT {
    MockInnerToken public immutable innerToken;

    constructor(MockInnerToken _innerToken) {
        innerToken = _innerToken;
    }

    function send(uint256 amountLD) external {
        _debit(msg.sender, amountLD);
    }

    function _debit(address from, uint256 amountLD) internal {
        innerToken.burn(from, amountLD);
    }
}

contract MockBridgeRegistrar {
    function register(MockInnerToken token) external returns (MockOndoOFT oft) {
        oft = new MockOndoOFT(token);
        token.grantRole(token.MINTER_ROLE(), address(oft));
        // Vulnerability: BURNER_ROLE is not granted here.
    }
}
