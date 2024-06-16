// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.18;

contract CrowdFunding{
    // 1. Anyone can create a new campaign by specifying the goal amount (in USD), and the duration.
    // 2. Any user, except for the creator of the campaign, can donate to any campaign using the token.
    // 3. Users can cancel their donations anytime for a particular campaign before the deadline has passed.
    // 4. If after the deadline has passed, the goal has not been reached, the campaign is said to be unsuccessful
    // and donors can get their contributions back. 

    struct Campaign{ // money units = Wei // convert to ETH later
        uint cid;
        address creator;
        uint target; 
        uint raised; 
        uint deadline; // timestamp
    }

    mapping(uint=>mapping(address=>uint)) public donations; // campaignid : (address:donation)
    mapping(uint=>Campaign) public LOC; // List of Campaigns
    uint public cc = 0; // Campaign count

    function createCampaign(uint _Target, uint _DurationinDays) external{
        require(_Target>0,"Goal amount must be greater than 0");
        require(_DurationinDays>0,"Duration of the campaign must be atleast 1 day");
        LOC[cc] = Campaign({creator:msg.sender, target:_Target, raised:0, cid:cc,
        deadline: (block.timestamp + _DurationinDays)});
        cc++;
    }

    function donateToCampaign(uint _Cid) external payable{
        require(_Cid>=0,"Invalid Campaign ID"); // Not reqd since _Cid is uint
        require(block.timestamp<LOC[_Cid].deadline,"Deadline has passed!");
        require(msg.sender!=LOC[_Cid].creator,"Creator cannot donate to the Campaign");
        require(msg.value>0,"Donation must be greater than 0");
        donations[_Cid][msg.sender] += msg.value;
        LOC[_Cid].raised += msg.value;
    }

    function cancelDonation(uint _Cid) external{
        uint donationAmt = donations[_Cid][msg.sender];
        require(donationAmt>0,"You have not donated to this Campaign");
        require(block.timestamp<LOC[_Cid].deadline,"Deadline has passed!");
        LOC[_Cid].raised -= donationAmt;
        donations[_Cid][msg.sender] = 0;
        payable(msg.sender).transfer(donationAmt);
    }

    function applyForRefund(uint _Cid) external {
        uint donationAmt = donations[_Cid][msg.sender];
        require(donationAmt>0,"You have not donated to this Campaign");
        require(block.timestamp>=LOC[_Cid].deadline,"Deadline has not passed yet, you can try cancelling your donation!");
        require(LOC[_Cid].raised<LOC[_Cid].target,"Campaign was successful! Refunds not applicable");
        LOC[_Cid].raised -= donationAmt;
        donations[_Cid][msg.sender] = 0;
        payable(msg.sender).transfer(donationAmt);
    }


}
