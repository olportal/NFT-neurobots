pragma solidity =0.8.6;

import "./tokens/nf-token-metadata.sol";
import "./ownership/ownable.sol";

contract IMeNFT is NFTokenMetadata, Ownable {
    struct ConnectedBuyer {
        bool state;
        address rewardType;
        address rewardReceiver;
        address rewardSender;
    }

    struct NFTData {
        bool manualConfirm;
        address author;
        string name;
        string botAvatar;
        string telegramAddress;
        string phrasesCount;
        string intentionsCount;
        string description;
        string category;
        string lang;
    }

    mapping(uint256 => NFTData) public NFTDatas;
    mapping(uint256 => mapping(uint256 => ConnectedBuyer))
        public ConnectedBuyers;

    event ConnectedBuyerEdited(
        uint256 tokenID,
        uint256 buyerID,
        bool state,
        address rewardType,
        address rewardReceiver,
        address rewardSender
    );

    event NFTDataEdited(
        uint256 tokenID,
        NFTData _NFTData
    );

    event URIEdited(uint256 tokenID, string newUri);

    /**
     * @dev Contract constructor. Sets metadata extension `name` and `symbol`.
     */
    constructor() {
        nftName = "iMe";
        nftSymbol = "IME";
    }

    /**
     * @dev Mints a new NFT.
     * @param _to The address that will own the minted NFT.
     * @param _tokenId of the NFT to be minted by the msg.sender.
     * @param _uri String representing RFC 3986 URI.
     */
    function mint(
        address _to,
        uint256 _tokenId,
        string calldata _uri,
        NFTData calldata _NFTData
    ) external onlyOwner {
        _mint(_to, _tokenId);
        _setTokenUri(_tokenId, _uri);
        NFTDatas[_tokenId] = _NFTData;
    }

    /**
     * @dev This function creates/changes/remove a connected buyer
     * To remove: pass default values
     */
    function editConnectedBuyer(
        uint256 tokenID,
        uint256 buyerID,
        bool state,
        address rewardType,
        address rewardReceiver,
        address rewardSender
    ) external onlyOwner {
        ConnectedBuyers[tokenID][buyerID] = ConnectedBuyer(
            state,
            rewardType,
            rewardReceiver,
            rewardSender
        );

        emit ConnectedBuyerEdited(
            tokenID,
            buyerID,
            state,
            rewardType,
            rewardReceiver,
            rewardSender
        );
    }

    /**
     * @dev Changes a data belonging to a nft
     * @param tokenID The ID of a token
     * @param NFTData The new data to write. Should be passed as an array
     */
    function editNFTData(
        uint256 tokenID,
        NFTData calldata _NFTData
    ) external onlyOwner {
        NFTDatas[tokenID] = _NFTData;

        emit NFTDataEdited(
            tokenID,
            _NFTData
        );
    }

    /**
     * @dev This function changes URI of token
     * @param tokenID The ID of token
     * @param newURI The new URI
     */
    function editURI(uint256 tokenID, string calldata newURI)
        external
        onlyOwner
    {
        _setTokenUri(tokenID, newURI);

        emit URIEdited(tokenID, newURI);
    }
}
