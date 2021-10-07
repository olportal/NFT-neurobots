pragma solidity =0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestLIME is ERC20 {
    constructor() ERC20("TestLIME", "LIME") {
        _mint(msg.sender, 100000000 * (10**uint256(decimals())));
    }
}

contract TestOLCF is ERC20 {
    constructor() ERC20("TestOLCF", "OLCF") {
        _mint(msg.sender, 100000000 * (10**uint256(decimals())));
    }
}

contract TestUSDC is ERC20 {
    constructor() ERC20("TestUSDC", "USDC"){
        _mint(msg.sender, 100000000 * (10**uint256(decimals())));
    }

    function decimals() public view override returns (uint8) {
        return 6;
    }
}