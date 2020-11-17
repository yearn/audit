pragma solidity ^0.5.0;

import "./script.sol";

interface StrategyLike {
    function forceRebalance(uint) external;
    function getTotalDebtAmount() external returns (uint);
    function getUnderlyingDai() external returns (uint);
    function setStrategist(address) external;
    function strategist() external returns (address);
    function harvest() external;
}

interface ControllerLike {
    function approveStrategy(address,address) external;
    function setStrategy(address,address) external;
    function setVault(address,address) external;
    function withdrawAll(address) external;
    function strategies(address) external view returns (address);
    function approvedStrategies(address, address) external view returns (bool);
    function vaults(address) external view returns (address);
    function strategist(address) external view returns (address);
}

interface VaultLike {
    function balance() external view returns (uint);
    function balanceOf(address) external view returns (uint);
    function token() external view returns (address);
    function earn() external;
    function deposit(uint) external;
    function depositAll() external;
    function setMin(uint) external;
    function withdraw(uint) external;
    function withdrawAll() external;
    function getPricePerFullShare() external view returns (uint);
}

interface ProxyLike {
    function approveStrategy(address) external;
    function strategies(address) external view returns (bool);
}

contract StrategyTest is script {

    StrategyLike private constant STRATEGY = StrategyLike(0x530da5aeF3c8f9CCbc75C97C182D6ee2284B643F);
    ControllerLike private constant CONTROLLER = ControllerLike(0x9E65Ad11b299CA0Abefc2799dDB6314Ef2d91080);
    VaultLike private constant VAULT = VaultLike(0x629c759D1E83eFbF63d84eb3868B564d9521C129);
    ProxyLike private constant PROXY = ProxyLike(0x7A1848e7847F3f5FfB4d8e63BdB9569db535A4f0);
    ERC20Like private constant REWARD = ERC20Like(0xD533a949740bb3306d119CC777fa900bA034cd52);
    ERC20Like private TOKEN;

	function approve() public {
	    TOKEN = ERC20Like(VAULT.token());
	    CONTROLLER.approveStrategy(VAULT.token(),address(STRATEGY));
	    CONTROLLER.setVault(VAULT.token(),address(VAULT));
	    CONTROLLER.setStrategy(VAULT.token(),address(STRATEGY));
	    PROXY.approveStrategy(address(STRATEGY));
	    fmt.printf("APPROVED=%b\n",abi.encode(CONTROLLER.approvedStrategies(VAULT.token(), address(STRATEGY))));
	    fmt.printf("STRATEGY=%a\n",abi.encode(CONTROLLER.strategies(address(TOKEN))));
	    fmt.printf("PROXY=%b\n",abi.encode(PROXY.strategies(address(STRATEGY))));
	}

	function run() public {
		run(this.approve).withCaller(0xFEB4acf3df3cDEA7399794D0869ef76A6EfAff52);
		run(this.deposit).withCaller(0xB5494d8788aB8AEf85291d59c99fB385ca77fF01);
		run(this.earn).withCaller(0xB5494d8788aB8AEf85291d59c99fB385ca77fF01);
		run(this.transfer).withCaller(0x4ce799e6eD8D64536b67dD428565d52A531B3640);
		run(this.harvest).withCaller(0x2D407dDb06311396fE14D4b49da5F0471447d45C);
		run(this.withrdraw).withCaller(0xB5494d8788aB8AEf85291d59c99fB385ca77fF01);
	}

	function deposit() external {
	    fmt.printf("TOKEN=%a\n",abi.encode(TOKEN));
	    fmt.printf("VAULT=%a\n",abi.encode(CONTROLLER.vaults(address(TOKEN))));
	    fmt.printf("STRATEGY=%a\n",abi.encode(CONTROLLER.strategies(address(TOKEN))));
	    fmt.printf("VAULT.balanceOf=%.18u\n",abi.encode(VAULT.balance()));
	    TOKEN.approve(address(VAULT), uint(-1));

	    fmt.printf("TOKEN.balanceOf(address)=%.18u\n",abi.encode(TOKEN.balanceOf(address(this))));
	    VAULT.depositAll();
	    fmt.printf("TOKEN.balanceOf(address)=%.18u\n",abi.encode(TOKEN.balanceOf(address(this))));
	    fmt.printf("TOKEN.balanceOf(VAULT)=%.18u\n",abi.encode(TOKEN.balanceOf(address(VAULT))));
	    fmt.printf("VAULT.balanceOf=%.18u\n",abi.encode(VAULT.balance()));
	    VAULT.earn();
	}

	function earn() external {
	    fmt.printf("VAULT.balanceOf=%.18u\n",abi.encode(VAULT.balance()));
	    fmt.printf("TOKEN.balanceOf(VAULT)=%.18u\n",abi.encode(TOKEN.balanceOf(address(VAULT))));
	    VAULT.earn();
	    fmt.printf("TOKEN.balanceOf(VAULT)=%.18u\n",abi.encode(TOKEN.balanceOf(address(VAULT))));
	    fmt.printf("VAULT.balanceOf=%.18u\n",abi.encode(VAULT.balance()));
	}

	function transfer() external {
	    REWARD.transfer(address(STRATEGY),1e18);
	}

	function harvest() external {
	    fmt.printf("VAULT.balanceOf=%.18u\n",abi.encode(VAULT.balance()));
	    fmt.printf("TOKEN.balanceOf(VAULT)=%.18u\n",abi.encode(TOKEN.balanceOf(address(VAULT))));
	    STRATEGY.harvest();
	    fmt.printf("TOKEN.balanceOf(VAULT)=%.18u\n",abi.encode(TOKEN.balanceOf(address(VAULT))));
	    fmt.printf("VAULT.balanceOf=%.18u\n",abi.encode(VAULT.balance()));
	}

	function withrdraw() external {
	    fmt.printf("VAULT.balanceOf=%.18u\n",abi.encode(VAULT.balance()));
	    fmt.printf("TOKEN.balanceOf(VAULT)=%.18u\n",abi.encode(TOKEN.balanceOf(address(VAULT))));
	    VAULT.withdrawAll();
	    fmt.printf("TOKEN.balanceOf(VAULT)=%.18u\n",abi.encode(TOKEN.balanceOf(address(VAULT))));
	    fmt.printf("VAULT.balanceOf=%.18u\n",abi.encode(VAULT.balance()));
	    fmt.printf("TOKEN.balanceOf(address)=%.18u\n",abi.encode(TOKEN.balanceOf(address(this))));
	}
}
