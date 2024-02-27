// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    // Define the contract owner and the state of the election
    address public owner;
    enum ElectionState { NOT_STARTED, ONGOING, ENDED }
    ElectionState public electionState;

    // Define the Candidate struct to store candidate details
    struct Candidate {
        uint id;
        string name;
        string proposal;
        uint voteCount;
        address ethAddress; // Add Ethereum address field
    }

    // Define the Voter struct to store voter details
    struct Voter {
        string name;
        address delegate;
        uint vote;
        bool voted;
    }

    // Define mappings to store candidates and voters
    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;

    // Define variables to track the count of candidates and voters
    uint public candidatesCount;
    uint public votersCount;

    // Define events for contract state changes
    event CandidateAdded(uint indexed id, string name, string proposal);
    event VoterAdded(address indexed voter);
    event VoteCast(address indexed voter, uint candidateId);
    event ElectionStarted(address indexed admin);
    event ElectionEnded(address indexed admin);
    event DelegateVote(address indexed voter, address indexed delegate);
    event ElectionWinner(uint indexed candidateId, string name, uint voteCount);

    // Contract constructor to set initial state and owner
    constructor() {
        owner = msg.sender;
        electionState = ElectionState.NOT_STARTED;
    }

    // Modifier to restrict access to only the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can perform this operation");
        _;
    }

    // Modifier to restrict operations to the duration of the election
    modifier onlyDuringElection() {
        require(electionState == ElectionState.ONGOING, "Election is not ongoing");
        _;
    }

    // Modifier to restrict operations before the election starts
    modifier onlyBeforeElection() {
        require(electionState == ElectionState.NOT_STARTED, "Election has already started");
        _;
    }

    // Modifier to restrict operations after the election ends
    modifier onlyAfterElection() {
        require(electionState == ElectionState.ENDED, "Election has not ended yet");
        _;
    }

    // Function to add a new candidate to the election
    function addCandidate(string memory _name, string memory _proposal) public onlyOwner onlyBeforeElection {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, _proposal, 0, owner); // Change to use owner's address
        emit CandidateAdded(candidatesCount, _name, _proposal);
    }

    // Function to add a new voter to the election
    function addVoter(string memory _name, address _voterAddress) public onlyOwner onlyBeforeElection {
        require(voters[_voterAddress].voted == false, "Voter has already voted");
        require(owner == owner, "Only the owner can add voters");
        votersCount++;
        voters[_voterAddress] = Voter(_name, address(0), 0, false);
        emit VoterAdded(_voterAddress);
    }

    // Function to start the election
    function startElection(address _owner) public onlyBeforeElection {
        owner = _owner;
        electionState = ElectionState.ONGOING;
        emit ElectionStarted(_owner);
    }

    // Function for a voter to cast their vote for a candidate
    function castVote(uint _candidateId, address _voterAddress) public onlyDuringElection {
        Voter storage sender = voters[_voterAddress];
        require(!sender.voted, "You have already voted");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        sender.voted = true;
        sender.vote = _candidateId;
        candidates[_candidateId].voteCount++;
        emit VoteCast(_voterAddress, _candidateId);
    }

    // Function for a voter to delegate their vote to another address
    function delegateVote(address _delegate, address _voterAddress) public onlyDuringElection {
        require(_delegate != address(0), "Invalid delegate address");
        require(msg.sender != _delegate, "You cannot delegate your vote to yourself");
        Voter storage sender = voters[_voterAddress];
        require(!sender.voted, "You have already voted");
        while (voters[_delegate].delegate != address(0)) {
            _delegate = voters[_delegate].delegate;
            require(_delegate != _voterAddress, "Loop in delegation detected");
        }
        sender.voted = true;
        sender.delegate = _delegate;
        Voter storage delegateTo = voters[_delegate];
        if (delegateTo.voted) {
            candidates[delegateTo.vote].voteCount++;
        }
        emit DelegateVote(_voterAddress, _delegate);
    }    

    // Function to end the election
    function endElection() public onlyOwner onlyDuringElection {
        electionState = ElectionState.ENDED;
        emit ElectionEnded(owner);
    }

    // Function to determine the winner of the election
    function showWinner() public view onlyAfterElection returns (uint, string memory, uint) {
        uint winningVoteCount = 0;
        uint winningCandidateId;
        for (uint i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidateId = i;
            }
        }
        return (candidates[winningCandidateId].id, candidates[winningCandidateId].name, candidates[winningCandidateId].voteCount);
    }
}
