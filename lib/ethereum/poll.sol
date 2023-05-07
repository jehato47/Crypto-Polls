// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PollApp {
    struct Poll {
        string question;
        string[] choices;
        mapping(uint => uint) votes;
        uint totalVotes;
    }

    address public owner;
    uint public pollCount;
    mapping(uint => Poll) public polls;

    event PollCreated(uint pollId);
    event PollVoted(uint pollId, uint choiceId, address voter);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createPoll(string memory _question, string[] memory _choices) public onlyOwner returns (uint pollId) {
        pollCount++;
        pollId = pollCount;
        polls[pollId].question = _question;
        polls[pollId].choices = _choices;

        emit PollCreated(pollId);
    }

    function vote(uint _pollId, uint _choiceId) public {
        require(_pollId > 0 && _pollId <= pollCount, "Invalid poll ID.");
        require(_choiceId < polls[_pollId].choices.length, "Invalid choice ID.");

        polls[_pollId].votes[_choiceId]++;
        polls[_pollId].totalVotes++;

        emit PollVoted(_pollId, _choiceId, msg.sender);
    }

    function getPoll(uint _pollId) public view returns (string memory question, string[] memory choices, uint[] memory votes, uint totalVotes) {
        require(_pollId > 0 && _pollId <= pollCount, "Invalid poll ID.");

        Poll storage poll = polls[_pollId];
        question = poll.question;
        choices = poll.choices;
        totalVotes = poll.totalVotes;

        votes = new uint[](choices.length);
        for (uint i = 0; i < choices.length; i++) {
            votes[i] = poll.votes[i];
        }
    }
}
