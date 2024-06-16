// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract AadharStorage{
    // 1.Storing user's aadhar details(name,dob,address,wallet address)
    // 2.Make it inaccessible to other users

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require( msg.sender == owner , "This function can only be executed by the Contract Owner");
        _; // Funciton body continues from here
    }

    struct AadharDetails{
        string name;
        string dob; // dd-mm-yyyy
        string addressInfo;
        address walletAddress;
        bool isRegistered;
    }

    mapping(address => AadharDetails) private userDetails; // Generate getter and setter methods

    function isValidDob(string memory _Dob) private pure returns(bool){
        bytes memory dob = bytes(_Dob);
        if (dob.length != 10){return false;}
        for (uint i=0;i<10;i++){
            if (i==2 || i==5){
                if (dob[i]!='-'){return false;}
            }
            else{
                if (dob[i]>'9' || dob[i]<'0') {return false;}
            }
        }
        return true;
    }

    function storeAadharDetails(string memory _Name, string memory _Dob, string memory _AddressInfo) public {
        require(!userDetails[msg.sender].isRegistered, "User is already registered");
        require(isValidDob(_Dob),"Please mention Date of Birth in dd-mm-yyyy format");
        userDetails[msg.sender] = AadharDetails(_Name,_Dob,_AddressInfo,msg.sender,true);
    }

    function getAadharDetails() view public returns(string memory, string memory, string memory, address) {
        require(userDetails[msg.sender].isRegistered, "User is not registered");
        AadharDetails memory user = userDetails[msg.sender];
        return (user.name, user.dob, user.addressInfo, user.walletAddress);
    }

    function getAadharDetails(address _WalletAddress) view public onlyOwner returns(string memory, string memory, string memory, address) {
        require(userDetails[_WalletAddress].isRegistered, "User is not registered");
        AadharDetails memory user = userDetails[_WalletAddress];
        return (user.name, user.dob, user.addressInfo, user.walletAddress);
    }

}