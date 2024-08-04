import { ethers } from "ethers";

document.addEventListener('DOMContentLoaded', async () => {
    // 检查MetaMask是否安装
    if (!(window as any).ethereum) {
        alert("Please install MetaMask!");
        return;
    }

    // 创建Provider和Signer
    const provider = new ethers.providers.Web3Provider((window as any).ethereum);
    const signer = provider.getSigner();

    // 合约地址和ABI
    const contractAddress = "YOUR_CONTRACT_ADDRESS";
    const abi = [
        "function checkTime() public view returns (uint256)"
    ];

    // 创建合约实例
    const contract = new ethers.Contract(contractAddress, abi, signer);

    // 获取按钮和显示元素
    const checkTimeButton = document.getElementById('checkTimeButton') as HTMLButtonElement;
    const timeDisplay = document.getElementById('timeDisplay') as HTMLParagraphElement;

    // 按钮点击事件
    checkTimeButton.addEventListener('click', async () => {
        try {
            const time = await contract.checkTime();
            timeDisplay.innerText = `Current Time: ${time}`;
        } catch (error) {
            console.error(error);
        }
    });
});
