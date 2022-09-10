// SPDX-License-Identifier: MIT

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                                           %                                                        //
//                                                         %%%%                                                       //
//                                                        %%%%                                                        //
//                                                      %%%%%%              *                                         //
//                                                    %%%%%%%%          *%%%%%                                        //
//                                                  %%%%   %%%%%    %%%%%%%%%%                                        //
//                                                %%%%       %%%%%%%%%%=   %%%                                        //
//                                              %%%%                       %%%                                        //
//                                  %%%%%%%#  %%%%%                       :%%%                                        //
//                                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%          *%%%                                        //
//                                 =%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*    +%%%                                        //
//                                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%=%%%%      .+:                               //
//                                #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*                             //
//                              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                             //
//                            %%%%%%%%%%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                             //
//                          %%%%%%%%%%        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                             //
//                         %%%%%%%%%%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                              //
//                       %%%%%%%%%%%      %  +%%%%%%%%%%%%%%%%%%%%%%%%.  #%%%%%%%%%%%%%%                              //
//                      %%%%%%%%%%%%    %%%%%%%%%%%%%%%%%%%%%%%%%%%.       -%%%%%%%%%%%%                              //
//                     %%%%%%%%%%%%%      -%%%%%%%%%%%%%%%%%%%%%%%          %%%%%%%%%%%%-                             //
//                    %%%%%%%%%%%%%%         %%%%%%%%%%%%%%%%%%%%#     %%% %%%%%%%%%%%%%%                             //
//                   #%%%%%%%%%%%%%%*        %%%%%%%%%%%%%%%%%%%%     %%%%%%%%%%%%%%%%%%%%                            //
//                   %%%%%%%%%%%%%%%%%       %%%%%%%%%%%%%%%%%%%%       %%%%%%%%%%%%%%%%%%%                           //
//                  %%%%%%%%%%%%%%%%%%%%%*+%%%%%%%%%%%%%%%%%%%%%%#         %%%%%%%%%%%%%%%%%                          //
//                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         -%%%%%%%%%%%%%%%%                          //
//                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#       %%%%%%%%%%%%%%%%%%                         //
//                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%   %%%   +%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                         //
//                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.                        //
//                 %%%%%%%%%%%%%%%%%%%%%%  %%              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                        //
//                 %%%%%%%%%%%%%%%%%%%%%%                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                        //
//                 %%%%%%%%%%%%%%%%%%%%%%%+    +%%+   =              %%%%%%%%%%%%%%%%%%%%%%%%%                        //
//                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%              %%%%%%%%%%%%%%%%%%%%%%%%%                        //
//                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            #%%%%%%%%%%%%%%%%%%%%%%%%%                        //
//                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%+        %%%%%%%%%%%%%%%%%%%%%%%%%%                         //
//                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                         //
//                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%+                         //
//                   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                          //
//                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                           //
//                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*                           //
//                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                            //
//                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                             //
//                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*                              //
//                          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                //
//                           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                 //
//                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                   //
//                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                     //
//                                 #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                       //
//                                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                          //
//                                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                          //
//                          %      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                          //
//                         %%%    =%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                         //
//                        %%%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%=  %%%%                                         //
//                        %%%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        %                                         //
//                        %%%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         %                                         //
//                         %%%  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       *%%                                        //
//                         *%%%=%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  %% =      +%%                                        //
//                           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             %%                                         //
//                             =%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     %%%%%%%%                                          //
//                                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                              //
//                                                                                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

//import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MccmNFT is ERC721Enumerable, Ownable, ReentrancyGuard {
    //using SafeMath for uint256;
    using Strings for uint256;

    bool public _isSaleActive = false; //是否開賣?
    bool public _revealed = false; //抽到的是否為 false：盲盒

    // Constants
    uint256 public constant MAX_SUPPLY = 6666; //能挖到的總數量
    //uint256 public immutable MAX_SUPPLY = 6666;

    //uint256 public immutable NumberOfTeamMint = 369;
    //address TeamAddress = 0x442Ba24778bdaFA9682Ec3ec2A1733a2E9fd6702;

    uint256 public mintPrice = 0.003 ether;
    uint256 public maxMint = 400; //一次能挖的NFT數

    // Starting index for Minted 這個先保留，再試一下第一個MINT是否還是有問題
    //uint256 public mintedMutantsStartingIndex;

    string baseURI;
    string public notRevealedUri;
    string public baseExtension = ".json";

    mapping(uint256 => string) private _tokenURIs;
    mapping(address => uint256) public addressMintMccmBalance;

    //constructor(string memory initBaseURI, string memory initNotRevealedUri)
    constructor() ERC721("Moom club", "MC") {
        //setBaseURI(initBaseURI);
        //setNotRevealedURI(initNotRevealedUri);
        //The team will mint the first 369 MCCMs
        // require(mintPrice * NumberOfTeam <= msg.value, "Not enough ether sent");
        // for (uint256 i = 0; i < NumberOfTeam; i++) {
        //     uint256 mintIndex = totalSupply();
        //     if (totalSupply() < MAX_SUPPLY) {
        //         addressMintMccmBalance[TeamAddress]++;
        //         _safeMint(TeamAddress, mintIndex);
        //     }
        // }
    }

    // constructor(
    //     uint256 maxBatchSize_, //  一批最大購買量?
    //     uint256 collectionSize_ //??
    // )
    //     //uint256 amountForAuctionAndDev_,  //拍賣跟mint的加總
    //     //uint256 amountForDevs_     //mint量
    //     //寫在這邊的參數，在depoly的時候要一起輸入
    //     ERC721A("Moom club ERC721A", "MC", maxMint, MAX_SUPPLY)
    // {
    //     maxPerAddressDuringMint = maxMint;
    //     //amountForAuctionAndDev = amountForAuctionAndDev_; //amount數量 Auction 拍賣  Batch批次
    //     amountForDevs = amountForDevs_;
    //     require(
    //         amountForAuctionAndDev_ <= MAX_SUPPLY,
    //         "larger collection size needed"
    //     );
    // }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is another contract");
        _;
    }

    function mintMccmMeta(uint256 tokenQuantity)
        public
        payable
        nonReentrant
        callerIsUser
    {
        //給用戶搶NFT用的   nonReentrant無聊猿的，避免重送攻擊  callerIsUser：不讓其它合約來存取
        require(totalSupply() + (tokenQuantity) <= MAX_SUPPLY, "Sold Out!");
        require(_isSaleActive, "Sale must be active to mint Mccm"); //還沒開賣
        require(
            tokenQuantity > 0 && tokenQuantity <= maxMint,
            "Exceeded the maximum purchase quantity"
        );
        require(
            mintPrice * (tokenQuantity) <= msg.value,
            "Not enough ether sent"
        );
        _mintMccmMeta(tokenQuantity);
    }

    function _mintMccmMeta(uint256 tokenQuantity) internal {
        for (uint256 i = 0; i < tokenQuantity; i++) {
            uint256 mintIndex = totalSupply();
            if (totalSupply() < MAX_SUPPLY) {
                addressMintMccmBalance[msg.sender]++;
                _safeMint(msg.sender, mintIndex);
            }
        }
    }

    // function refundIfOver(uint256 price) private {
    //     require(msg.value >= price, "Need to send more ETH.");
    //     if (msg.value > price) {
    //         payable(msg.sender).transfer(msg.value - price);
    //     }
    // }

    //挖NFT的精隨，從0.1.2.3..66666，再去拼網址
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (_revealed == false) {
            return notRevealedUri;
        }

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return
            string(abi.encodePacked(base, tokenId.toString(), baseExtension));
        //string(abi.encodePacked(baseTokenUri, String.toStringtokenId.toString(tokenId_), "json"));
    }

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    //only owner
    function flipSaleActive() public onlyOwner {
        _isSaleActive = !_isSaleActive;
    }

    function flipReveal() public onlyOwner {
        _revealed = !_revealed;
    }

    function setMintPrice(uint256 _mintPrice) public onlyOwner {
        mintPrice = _mintPrice;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    function setMaxMint(uint256 _maxMint) public onlyOwner {
        maxMint = _maxMint;
    }

    function withdraw(address to) public onlyOwner nonReentrant {
        //提領的功能，全部轉走
        uint256 balance = address(this).balance;
        payable(to).transfer(balance);
    }

    // function withdraw() external onlyOwner {
    //     //無聊猿的，可以試試怎麼轉
    //     uint256 balance = address(this).balance;
    //     Address.sendValue(payable(owner()), balance);
    // }

    function ContractBalance() public view returns (uint256) {
        //查合約餘額
        uint256 balance = address(this).balance;
        return balance;
    }

    // function TestWithdraw(address to, uint256 momey) public {  //自選金額的提領功能，上線不能用，沒有onlyOwner保護，到時候寫死在多簽錢包地址
    //     uint256 balance = address(this).balance;
    //     require(balance >= momey, "Insufficient balance");
    //     payable(to).transfer(momey);
    // }
}
