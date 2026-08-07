pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/M01Mocks.sol";

contract OndoM01Test is Test {
    MockInnerToken internal token;
    MockBridgeRegistrar internal registrar;
    MockOndoOFT internal oft;

    address internal user = address(0xBEEF);

    function setUp() public {
        token = new MockInnerToken();
        registrar = new MockBridgeRegistrar();

        oft = registrar.register(token);

        vm.store(
            address(token),
            keccak256(abi.encode(user, uint256(1))),
            bytes32(uint256(100 ether))
        );
    }

    function test_SendRevertsWithoutBurnerRole() public {
        vm.startPrank(user);
        vm.expectRevert(
            abi.encodeWithSelector(
                MockInnerToken.MissingRole.selector,
                token.BURNER_ROLE(),
                address(oft)
            )
        );
        oft.send(10 ether);
        vm.stopPrank();
    }
}
