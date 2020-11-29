pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./script.sol";

interface IERC20 {
    function transfer(address recipient, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    function balanceOf(address account) external view returns (uint);
}

interface uni {
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
}


contract REPL is script {

	function run() public {
	    run(this.swap).withCaller(0x2D407dDb06311396fE14D4b49da5F0471447d45C);
	}

    function repl() external {

        uint t = block.timestamp + uint(180000);
        fmt.printf("t=%u\n", abi.encode(t));
        fmt.printf("values=%x\n",abi.encodePacked(address(0x2D407dDb06311396fE14D4b49da5F0471447d45C),uint(11832159566199232084134)));
    }

    uni constant private UNI = uni(0x9e3FCc46ef41Eb5c20f404c4c35848DeB34044fc);
    IERC20 constant private DWAP = IERC20(0x846D152216146c77C81aF3A1657790eD8bA69281);

    function swap() external {
        uint balance = DWAP.balanceOf(address(this));
        DWAP.transfer(address(UNI), balance);
        UNI.skim(address(this));
        balance = DWAP.balanceOf(address(this));
        fmt.printf("b=%.18u\n", abi.encode(balance));
    }
}
