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
        string imageURI;
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
        bool manualConfirm,
        address author,
        string name,
        string botAvatar,
        string telegramAddress
    );

    event URIEdited(uint256 tokenID, string newUri);

    /**
     * @dev Contract constructor. Sets metadata extension `name` and `symbol`.
     */
    constructor() {
        nftName = "IME";
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
        bool manualConfirm,
        address author,
        string calldata name,
        string calldata botAvatar,
        string calldata telegramAddress,
        string calldata phrasesCount,
        string calldata intentionsCount,
        string calldata imageURI,
        string calldata description,
        string calldata category,
        string calldata lang
    ) external onlyOwner {
        _mint(_to, _tokenId);
        _setTokenUri(_tokenId, _uri);
        NFTDatas[_tokenId] = NFTData(
            manualConfirm,
            author,
            name,
            botAvatar,
            telegramAddress,
            phrasesCount,
            intentionsCount,
            mageURI,
            description,
            category,
            lang
        );
    }

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

    function editNFTData(
        uint256 tokenID,
        bool manualConfirm,
        address author,
        string calldata name,
        string calldata botAvatar,
        string calldata telegramAddress,
        string calldata phrasesCount,
        string calldata intentionsCount,
        string calldata imageURI,
        string calldata description,
        string calldata category,
        string calldata lang
    ) external onlyOwner {
        NFTDatas[tokenID] = NFTData(
            manualConfirm,
            author,
            name,
            botAvatar,
            telegramAddress,
            phrasesCount,
            intentionsCount,
            mageURI,
            description,
            category,
            lang
        );

        emit NFTDataEdited(
            tokenID,
            manualConfirm,
            author,
            name,
            botAvatar,
            telegramAddress,
            phrasesCount,
            intentionsCount,
            mageURI,
            description,
            category,
            lang
        );
    }

    function editURI(uint256 tokenID, string calldata newURI)
        external
        onlyOwner
    {
        _setTokenUri(tokenID, newURI);

        emit URIEdited(tokenID, newURI);
    }
}
