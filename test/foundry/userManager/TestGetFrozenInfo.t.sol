pragma solidity ^0.8.0;

import {TestUserManagerBase} from "./TestUserManagerBase.sol";
import {UserManager} from "union-v2-contracts/user/UserManager.sol";

contract TestGetFrozenInfo is TestUserManagerBase {
    uint96 stakeAmount = 100 ether;

    function setUp() public override {
        super.setUp();
        vm.startPrank(ADMIN);
        userManager.addMember(address(this));
        vm.stopPrank();

        comptrollerMock.setUserManager(address(userManager));

        userManager.stake(stakeAmount);
        userManager.updateTrust(ACCOUNT, stakeAmount);
    }

    function testGetStakeInfo() public {
        uint96 lockAmount = 10 ether;
        uint256 creditLimit = userManager.getCreditLimit(ACCOUNT);

        uint256 globalStakedBefore = userManager.globalTotalStaked();
        uint256 totalFrozenBefore = userManager.totalFrozen();

        vm.assume(lockAmount <= creditLimit);
        skip(11); // 10 more blocks
        vm.startPrank(address(userManager.uToken()));
        userManager.updateLocked(ACCOUNT, lockAmount, true);
        vm.stopPrank();
        skip(21); // another 10 blocks
        (, uint256 effectiveStaked, uint256 effectiveLocked, ) = userManager.getStakeInfo(address(this));
        assertEq(effectiveStaked, stakeAmount);
        // lockAmount/2 because only locked for half of the duration
        assertEq(effectiveLocked, lockAmount / 2);

        uint256 globalStakedAfter = userManager.globalTotalStaked();
        uint256 totalFrozenAfter = userManager.totalFrozen();
        assertEq(globalStakedBefore - globalStakedAfter, totalFrozenAfter - totalFrozenBefore);
    }
}
