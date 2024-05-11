// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMarket is Ownable {
    ERC721 public nftContract;
    uint256 public listingPrice = 0.01 ether; // 设置挂单价格
    uint256 public listingDuration = 24 hours; // 设置挂单时长

    mapping(uint256 => uint256) public tokenListingTimes; // 存储每个 NFT 的挂单时间

    constructor(address _nftContract) {
        nftContract = ERC721(_nftContract);
    }

    // 事件，用于通知前端交易状态
    event MarketTransaction(address indexed _buyer, address indexed _seller, uint256 indexed _tokenId);

    // 买卖函数
    function buyNFT(uint256 _tokenId) external payable {
        require(msg.value >= listingPrice, "Insufficient funds");
        address seller = nftContract.ownerOf(_tokenId);
        require(seller != address(0), "Invalid token");
        require(seller != msg.sender, "You cannot buy your own NFT");

        require(block.timestamp < tokenListingTimes[_tokenId] + listingDuration, "Listing expired");

        nftContract.safeTransferFrom(seller, msg.sender, _tokenId);
        payable(owner()).transfer(msg.value);

        emit MarketTransaction(msg.sender, seller, _tokenId);
    }

    // 设置挂单价格
    function setListingPrice(uint256 _price) external onlyOwner {
        listingPrice = _price;
    }

    // 设置挂单时长
    function setListingDuration(uint256 _duration) external onlyOwner {
        listingDuration = _duration;
    }

    // 添加挂单记录
    function addListingTime(uint256 _tokenId) external {
        require(nftContract.ownerOf(_tokenId) == msg.sender, "Only token owner can add listing time");
        tokenListingTimes[_tokenId] = block.timestamp;
    }
}
