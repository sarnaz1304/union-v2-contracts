pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {UUPSProxy} from "union-v1.5-contracts/UUPSProxy.sol";
import {AssetManagerMock} from "union-v1.5-contracts/mocks/AssetManagerMock.sol";
import {UnionTokenMock} from "union-v1.5-contracts/mocks/UnionTokenMock.sol";
import {FaucetERC20} from "union-v1.5-contracts/mocks/FaucetERC20.sol";
import {ComptrollerMock} from "union-v1.5-contracts/mocks/ComptrollerMock.sol";
import {UTokenMock} from "union-v1.5-contracts/mocks/UTokenMock.sol";

contract TestWrapper is Test {
    AssetManagerMock public assetManagerMock;
    UnionTokenMock public unionTokenMock;
    FaucetERC20 public daiMock;
    ComptrollerMock public comptrollerMock;
    UTokenMock public uTokenMock;

    function deployProxy(address implementation, bytes memory signature) public returns (address) {
        UUPSProxy proxy = new UUPSProxy(implementation, address(0), signature);
        return address(proxy);
    }

    function deployMocks() public {
        assetManagerMock = new AssetManagerMock();
        unionTokenMock = new UnionTokenMock("UnionMock", "UNM");
        daiMock = new FaucetERC20("MockDAI", "MDAI");
        comptrollerMock = new ComptrollerMock();
        uTokenMock = new UTokenMock();
    }
}