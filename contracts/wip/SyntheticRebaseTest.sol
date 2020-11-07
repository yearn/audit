pragma solidity ^0.5.0;

import "./script2.sol";
import "./SyntheticRebase.sol";

contract SyntheticRebaseTest is script {
    using SafeMath for uint;

    ERC20Like private constant USDT = ERC20Like(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    ERC20Like private constant USDC = ERC20Like(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    ERC20Like private constant TUSD = ERC20Like(0x0000000000085d4780B73119b644AE5ecd22b376);
    ERC20Like private constant DAI = ERC20Like(0x6B175474E89094C44Da98b954EedeAC495271d0F);

    SyntheticRebaseDollar private dollar;

    function setup() public {
        USDT.transfer(0x0F0c4d2D0891E91A3C2b28e0e6292bB6BF3888d0, 10000e6);
    }

	function run() public {
	    run(this.setup).withCaller(0xBE0eB53F46cd790Cd13851d5EFf43D12404d33E8);
		run(this.test).withCaller(0x0F0c4d2D0891E91A3C2b28e0e6292bB6BF3888d0);
	}

	function test() public {
	    dollar = new SyntheticRebaseDollar();
	    fmt.printf("USDT=%.6u\n",abi.encode(USDT.balanceOf(address(this))));
        USDT.approve(address(dollar), USDT.balanceOf(address(this)));
        dollar.deposit(address(USDT), 10000e6);
	    fmt.printf("credit=%.8u\n",abi.encode(dollar.getCredit(address(this), address(USDT))));
	    fmt.printf("totalSupply=%.8u\n",abi.encode(dollar.totalSupply()));
	    fmt.printf("factor=%.4u\n",abi.encode(dollar.factor()));
	    fmt.printf("balanceOf=%.8u\n",abi.encode(dollar.balanceOf(address(this))));
	    fmt.printf("adjusted=%.8u\n",abi.encode(dollar.adjusted(dollar.balanceOf(address(this)))));
	    fmt.printf("base=%.8u\n",abi.encode(dollar.balanceOfBase(address(this))));
	    fmt.printf("credit=%.8u\n",abi.encode(dollar.getCredit(address(this), address(USDT))));
	    fmt.printf("getUserCredit=%.8u\n",abi.encode(dollar.getUserCredit(address(this))));
	    fmt.printf("factor=%.4u\n",abi.encode(dollar.factor()));
	    dollar.withdrawAll(address(USDT));
	    fmt.printf("credit=%.8u\n",abi.encode(dollar.getCredit(address(this), address(USDT))));
	    fmt.printf("base=%.8u\n",abi.encode(dollar.balanceOfBase(address(this))));
	    fmt.printf("base=%.8u\n",abi.encode(dollar.balanceOf(address(this))));
	    fmt.printf("getUserCredit=%.8u\n",abi.encode(dollar.getUserCredit(address(this))));
	    fmt.printf("USDT=%.6u\n",abi.encode(USDT.balanceOf(address(this))));
	}
}
