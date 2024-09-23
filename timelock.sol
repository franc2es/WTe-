import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";


contract swap is AutomationCompatibleInterface{
    // 公共交换变量（添加类型和名称）
    uint256 public immutable interval;
    uint256 public lastTimeStamp;

    constructor(uint256 updateInterval) {
        interval = updateInterval;
        lastTimeStamp = block.timestamp;
    }

event ComeToList(address nftContract, uint256 tokenId, uint256 amount);
//它将通知外部系统准备挂单

 function startTime(address nftContract, uint256 tokenId, uint256 listingAmount) external {
        lastTimeStamp = block.timestamp; // 设置当前的时间戳
        emit ComeToList(nftContract, tokenId, listingAmount); // 触发事件
    }

function checkUpkeep(
    bytes calldata /* checkData */
) external view override returns (bool upkeepNeeded, bytes memory /* performData */) {
    upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
}
//在调用checkupKeep后自动调用以下自设功能
function performUpkeep(bytes calldata /* performData */) external override {
    if ((block.timestamp - lastTimeStamp) > interval) {
        lastTimeStamp = block.timestamp;
        //require(queuedTransactions[txHash],'Timelock')；//检查交易是否在队列里头（前版本）
        emit ComeToList(nftContract, tokenId, listingAmount);//执行挂单操作，调用脚本里函数功能
    }
}
}
