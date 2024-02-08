// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

contract JobPortal {
    // Structure to represent an applicant
    struct Applicant {
        uint id;                // Unique identifier for the applicant
        string name;            // Name of the applicant
        string laborHistory;    // Labor history of the applicant
        string skills;          // Skills possessed by the applicant
        string availability;    // Availability of the applicant
        uint rating;            // Rating of the applicant
    }

    // Structure to represent a job
    struct Job {
        uint id;                // Unique identifier for the job
        string title;           // Title of the job
        string description;     // Description of the job
    }

    // Mapping to store applicant data with their IDs
    mapping(uint => Applicant) public applicants;
    // Mapping to store job data with their IDs
    mapping(uint => Job) public jobs;

    // Counter to track the total number of applicants
    uint public applicantsCount;
    // Counter to track the total number of jobs
    uint public jobsCount;

    // Constructor to initialize counters
    constructor() {
        applicantsCount = 0;
        jobsCount = 0;
    }

    // Function to add a new applicant
    function addApplicant(string memory _name, string memory _laborHistory, string memory _skills, string memory _availability) public {
        applicantsCount++;
        applicants[applicantsCount] = Applicant(applicantsCount, _name, _laborHistory, _skills, _availability, 0);
    }

    // Function to get details of an applicant by ID
    function getApplicant(uint _id) public view returns (uint, string memory, string memory, string memory, string memory, uint) {
        require(_id <= applicantsCount, "Invalid applicant ID");
        Applicant memory applicant = applicants[_id];
        return (applicant.id, applicant.name, applicant.laborHistory, applicant.skills, applicant.availability, applicant.rating);
    }

    // Function to add a new job
    function addJob(string memory _title, string memory _description) public {
        jobsCount++;
        jobs[jobsCount] = Job(jobsCount, _title, _description);
    }

    // Function to get details of a job by ID
    function getJob(uint _id) public view returns (uint, string memory, string memory) {
        require(_id <= jobsCount, "Invalid job ID");
        Job memory job = jobs[_id];
        return (job.id, job.title, job.description);
    }

    // Function for an applicant to apply for a job
    function applyForJob(uint _applicantId, uint _jobId) public {
        require(_applicantId <= applicantsCount && _jobId <= jobsCount, "Invalid applicant or job ID");
        
        // Assume here we do some validation or processing for the job application
        
        // For simplicity, let's just emit an event indicating the application
        emit JobApplication(_applicantId, _jobId);
    }

    // Function to rate an applicant
    function rateApplicant(uint _applicantId, uint _rating) public {
        require(_applicantId <= applicantsCount, "Invalid applicant ID");
        require(_rating >= 0 && _rating <= 5, "Rating should be between 0 and 5");

        applicants[_applicantId].rating = _rating;
    }

    // Function to get the rating of an applicant by ID
    function getApplicantRating(uint _applicantId) public view returns (uint) {
        require(_applicantId <= applicantsCount, "Invalid applicant ID");
        return applicants[_applicantId].rating;
    }

    // Event to emit when an applicant applies for a job
    event JobApplication(uint indexed applicantId, uint indexed jobId);
}
