pragma solidity =0.8.6;

import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "../node_modules/@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "./ownership/ownable.sol";

contract IMeMarketPlace is Ownable {
    using SafeERC20 for IERC20;
    using EnumerableSet for EnumerableSet.UintSet;

    struct Disposal {
        string[] tags;
        address offeror;
        string category;
        string description;
        string author;
        uint256 OLCFPrice;
        uint256 deadline;
    }

    IERC20 public LIME;
    IERC20 public OLCF;
    IERC20 public USDC;
    IERC721 public IMeNFT;
    IUniswapV2Router02 public uniswapRouter;
    address public LIMEFeeAddress;
    EnumerableSet.UintSet internal offeredNFTS;
    mapping(uint256 => Disposal) public disposalByID;
    mapping(address => EnumerableSet.UintSet) internal addressToIDs;
    mapping(uint256 => uint256) public periodToPrice;

    constructor(
        IERC20 _LIME,
        IERC20 _OLCF,
        IERC20 _USDC,
        IERC721 _IMeNFT,
        address _LIMEFeeAddress,
        IUniswapV2Router02 _uniswapRouter
    ) {
        LIME = _LIME;
        OLCF = _OLCF;
        USDC = _USDC;
        IMeNFT = _IMeNFT;
        LIMEFeeAddress = _LIMEFeeAddress;
        uniswapRouter = _uniswapRouter;

        periodToPrice[30] = 10000000; // 6 decimals like USDC
        periodToPrice[90] = 27000000; // 6 decimals like USDC
        periodToPrice[180] = 48000000; // 6 decimals like USDC
        periodToPrice[360] = 84000000; // 6 decimals like USDC
    }

    function setLIMEAddress(IERC20 _LIME) external onlyOwner {
        LIME = _LIME;
    }

    function setOCLFAddress(IERC20 _OLCF) external onlyOwner {
        OLCF = _OLCF;
    }

    // price with decimals
    function editPeriodPrice(uint256 period, uint256 price) external onlyOwner {
        periodToPrice[period] = price;
    }

    function changeLIMEFeeAddress(address _LIMEFeeAddress) external onlyOwner {
        LIMEFeeAddress = _LIMEFeeAddress;
    }

    function getDisposalsByAddress(address _address)
        external
        view
        returns (uint256[] memory)
    {
        return addressToIDs[_address].values();
    }

    function getActiveOffers() external view returns (uint256[] memory) {
        return offeredNFTS.values();
    }

    function _USDCPriceToLIME(uint256 USDCPrice) public view returns (uint256){
        address[] memory path = new address[](2);
        path[0] = address(LIME);
        path[1] = address(USDC);
        return uniswapRouter.getAmountsIn(USDCPrice, path)[0];
    }

    // OCLFPrice with decimals
    function offerBot(
        string[] calldata tags,
        uint256 period,
        string calldata category,
        string calldata description,
        string calldata author,
        uint256 OLCFPrice,
        uint256 tokenID
    ) external {
        uint256 _priceUSDC = periodToPrice[period];
        require(_priceUSDC > 0, "No such period");
        uint256 _priceLIME = _USDCPriceToLIME(_priceUSDC);
        LIME.safeTransferFrom(msg.sender, LIMEFeeAddress, _priceLIME);
        IMeNFT.transferFrom(msg.sender, address(this), tokenID);

        disposalByID[tokenID] = Disposal(
            tags,
            msg.sender,
            category,
            description,
            author,
            OLCFPrice,
            block.timestamp + (period * 24 * 60 * 60)
        );
        offeredNFTS.add(tokenID);
        addressToIDs[msg.sender].add(tokenID);
    }

    function buyBot(uint256 tokenID) external {
        require(offeredNFTS.contains(tokenID), "The NFT isn't offered");

        Disposal memory _disposal = disposalByID[tokenID]; //SLOAD for gas optimization

        require(_disposal.deadline > block.timestamp, "The offer is expired");

        OLCF.safeTransferFrom(
            msg.sender,
            _disposal.offeror,
            _disposal.OLCFPrice
        );

        IMeNFT.transferFrom(address(this), msg.sender, tokenID);

        offeredNFTS.remove(tokenID);
        addressToIDs[_disposal.offeror].remove(tokenID);
        delete (disposalByID[tokenID]);
    }

    function removeOffer(uint256 tokenID) external {
        require(offeredNFTS.contains(tokenID), "The NFT isn't offered");

        address _offeror = disposalByID[tokenID].offeror; //SLOAD for gas optimization

        require(_offeror == msg.sender, "The offeror is another address");

        IMeNFT.transferFrom(address(this), _offeror, tokenID);

        offeredNFTS.remove(tokenID);
        addressToIDs[_offeror].remove(tokenID);
        delete (disposalByID[tokenID]);
    }
}
