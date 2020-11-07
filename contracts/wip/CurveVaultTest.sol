pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./script.sol";

interface CurveVaultLike {
   function depositAll() external;
   function update() external;
   function claim() external;
   function CRV() external view returns (address);
   function rewards() external view returns (address);
}

contract CurveVaultTest is script {

    CurveVaultLike constant private CRV = CurveVaultLike(0x8e54FF42bfCE5Da59abA53b78dad3643Bf4937CA);

	function run() public {
	    run(this.deposit).withCaller(0x4ce799e6eD8D64536b67dD428565d52A531B3640);
	    run(this.reward).withCaller(0x317aE07510d655e3bD355D8612e8Dc7C1538dCeF);
	    run(this.claim).withCaller(0x4ce799e6eD8D64536b67dD428565d52A531B3640);
	}

    function deposit() external {
        ERC20Like crv = ERC20Like(CRV.CRV());
        fmt.printf("crv.balanceOf()=%.18u\n",abi.encode(crv.balanceOf(address(this))));
        crv.approve(address(CRV), crv.balanceOf(address(this)));
        CRV.depositAll();
        fmt.printf("crv.balanceOf()=%.18u\n",abi.encode(crv.balanceOf(address(this))));
    }

    function reward() external {
        ERC20Like p = ERC20Like(CRV.rewards());
        p.transfer(address(CRV), p.balanceOf(address(this)));
        CRV.update();
    }

    function claim() external {
        ERC20Like p = ERC20Like(CRV.rewards());
        fmt.printf("3p.balanceOf()=%.18u\n",abi.encode(p.balanceOf(address(this))));
        CRV.claim();
        fmt.printf("3p.balanceOf()=%.18u\n",abi.encode(p.balanceOf(address(this))));
    }
}
