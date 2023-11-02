// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Dappcord is ERC721{
	uint256 public totalSupply;
	uint256 public totalChannels; //default is = 0, same as totalChannels = 0;
	address public owner;

	struct Channel {
		uint256 id;
		string name;
		uint256 cost;
	}

	mapping(uint256 => Channel) public channels; //Saving this mapping to the variable 'channels'
	mapping(uint256 => mapping(address => bool)) public hasJoined; //uint256 is id# for mapping 'hasJoined', and it's bool = faulse by default and address goes into 'mapping' with this id only if address => bool == true (in mint function)
	//channels[uint256] = Channel(attributes); hasJoined[uint256][address] = bool(latest mapping attributes, which are either TRUE or FALSE) 
	modifier onlyOwner(){
		require(msg.sender == owner);
		_; //represents function body, tells: run this requirement statement before any code in function
	}

	constructor(string memory _name, string memory _symbol)
		ERC721(_name, _symbol)
	{
		owner = msg.sender;
	}

	function createChannel(string memory _name, uint256 _cost) public onlyOwner{
		totalChannels++;
		channels[totalChannels] = Channel(totalChannels, _name, _cost);
	}
//comment
	function mint(uint256 _id) public payable {
		require(_id != 0);
		require(_id <= totalChannels);
		require(hasJoined[_id][msg.sender] == false); //disable mapping of _id with msg.sender before creating such a mapping from scratch to avoid double joining of channel
		require(msg.value >= channels[_id].cost);

		//Join channel and Mint NFT
		hasJoined[_id][msg.sender] = true; 
		// Mint NFT
		totalSupply++;
		_safeMint(msg.sender, totalSupply);
	}

	function getChannel(uint256 _id) public view returns (Channel memory) {
		return channels[_id];
	}


	function withdraw() public onlyOwner {
		(bool success, ) = owner.call{value: address(this).balance}("");
		require(success);
	}

}
