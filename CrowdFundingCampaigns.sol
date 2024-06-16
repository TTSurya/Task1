// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.18;

contract CrowdFunding{
    // 1. Anyone can create a new campaign by specifying the goal amount (in USD), and the duration.
    // 2. Any user, except for the creator of the campaign, can donate to any campaign using the token.
    // 3. Users can cancel their donations anytime for a particular campaign before the deadline has passed.
    // 4. If after the deadline has passed, the goal has not been reached, the campaign is said to be unsuccessful
    // and donors can get their contributions back. 

    struct Campaign{ // money units = USD
        uint cid;
        address creator;
        uint target; 
        uint raised; 
        uint deadline; // timestamp
    }

    mapping(uint=>mapping(address=>uint)) donations; // campaignid : (address:donation)
    mapping(uint=>Campaign) public LOC; // List of Campaigns
    uint cc = 0; // Campaign count

    function createCampaign(uint _Target, uint _DurationinDays) external{
        require(_Target>0,"Goal amount must be greater than 0");
        require(_DurationinDays>0,"Duration of the campaign must be atleast 1 day");
        LOC[cc] = Campaign({creator:msg.sender, target:_Target, raised:0, cid:cc,
        deadline: ( block.timestamp + _DurationinDays)});
        cc++;
    }

    function donateCampaign(uint _Cid, uint _Donation) external payable{
        require(block.timestamp<)
    }

}