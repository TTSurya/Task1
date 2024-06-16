// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleVotingSystem{
    // 1.Allow users to vote for a candidate
    // 2.Keep track of vote count for each candidate
    // 3.Determine Winner

    uint public id=0;
    uint public constant max_candidates = 5; //Max #Candidates that can take part

    struct Candidate{
        uint cid;
        string name;
        uint voteCount;
    }

    mapping(address => bool) hasVoted; // To ensure same person doesn't vote more than once

    Candidate[max_candidates] public LOC; // Static array for List of Candidates

    function registerCandidate(string memory _Name) public {
        require(id<max_candidates, "Max candidates reached");
        LOC[id] = Candidate(id,_Name,0);
        id++;
    }

    function vote(uint _cid) public {
        require(0 <= _cid && _cid < max_candidates, "Invalid Candidate ID");
        // require(!hasVoted[msg.sender], "Your Vote has already been cast!");
        // hasVoted[msg.sender] = true;
        LOC[_cid].voteCount++;
    }

    function determineWinner() public view returns(string memory _Conclusion){
        // Winner Winner Chicken Dinner
        // Winner is the one with max votes
        bool tie = false;
        uint winner_voteCount = 0;
        uint winner_cid = max_candidates;
        for (uint i=0;i<id;i++){ // At this point, #Candidates registered = id
            if (LOC[i].voteCount>winner_voteCount){
                winner_voteCount=LOC[i].voteCount;
                winner_cid = LOC[i].cid; // or just i
                tie = false;
            }
            else if (LOC[i].voteCount==winner_voteCount){
                tie = true;
            }
        }
        if (winner_cid==max_candidates){
            _Conclusion = "No one has cast their vote yet!";
        }
        else if (tie){
            bool isFirst = true;
            bytes memory tempBytes;
            for (uint i=0;i<id;i++){
                if (LOC[i].voteCount==winner_voteCount){
                    if (!isFirst){
                        tempBytes = abi.encodePacked(tempBytes,",");
                    }
                    else {
                        isFirst = false;
                    }
                    tempBytes = abi.encodePacked(tempBytes,bytes(LOC[i].name));
                }
            }
            _Conclusion = string(abi.encodePacked("There has been a tie between the candidates ",string(tempBytes)));
        }
        else{
            _Conclusion = string(abi.encodePacked(LOC[winner_cid].name," has won the contest!"));
        }
    }


}