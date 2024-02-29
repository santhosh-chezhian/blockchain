// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PatientRecord {
    struct Doctor {
        uint id;
        string name;
        string qualification;
        string workPlace;
    }
    
    struct Patient {
        uint id;
        string name;
        uint age;
        string[] diseases;
    }
    
    struct Medicine {
        uint id;
        string name;
        uint expiryDate;
        string dose;
        uint price;
    }
    
    /*struct DoctorAddress {
        uint id;
        string name;
        string qualification;
        string workPlace;
    }*/
    
    mapping(address => Doctor) public doctors;
    mapping(address => Patient) public patients;
    mapping(uint => Medicine) public medicines;
    //mapping(string => DoctorAddress) public doctorsAddress;
    
    // Events for logging
    event DoctorRegistered(address indexed doctorAddress, uint indexed id, string name);
    event PatientRegistered(address indexed patientAddress, uint indexed id, string name);
    event DiseaseAdded(address indexed patientAddress, string disease);
    event MedicineAdded(uint indexed id, string name);
    event MedicinePrescribed(uint indexed id, address indexed patient, address indexed doctor);
    event PatientAgeUpdated(address indexed patientAddress, uint newAge);
    
    uint public doctorCount;
    uint public patientCount;
    uint public medicineCount;
    
    // Constructor
    constructor() {
        doctorCount = 0;
        patientCount = 0;
        medicineCount = 0;
    }
    
    /**
     * @dev Register a new doctor
     * @param _name Name of the doctor
     * @param _qualification Qualification of the doctor
     * @param _workPlace Address of the hospital/clinic
     */
    function registerDoctor(string memory _name, string memory _qualification, string memory _workPlace, address _doctorAddress) public {
        doctorCount++;
        doctors[_doctorAddress] = Doctor(doctorCount, _name, _qualification, _workPlace);
        emit DoctorRegistered(_doctorAddress, doctorCount, _name);
    }

     /*function registerDoctor(string memory _name, string memory _qualification, string memory _workPlace) public {
        doctorCount++;
        doctors[msg.sender] = Doctor(doctorCount, _name, _qualification, _workPlace);
        emit DoctorRegistered(msg.sender, doctorCount, _name);
    }*/   
    
    /**
     * @dev Register a new patient
     * @param _name Name of the patient
     * @param _age Age of the patient
     */
    function registerPatient(string memory _name, uint _age, address _owner) public {
        patientCount++;
        patients[_owner] = Patient(patientCount, _name, _age, new string[](0));
        emit PatientRegistered(_owner, patientCount, _name);
    }
    
    /**
     * @dev Add a disease for a patient
     * @param _disease Name of the disease
     */
    function addDisease(string memory _disease, address _patientAddress) public {
        patients[_patientAddress].diseases.push(_disease);
        emit DiseaseAdded(_patientAddress, _disease);
    }
    
    /**
     * @dev Add medicine to the ledger
     * @param _name Name of the medicine
     * @param _expiryDate Expiry date of the medicine
     * @param _dose Dose prescribed for the medicine
     * @param _price Price of the medicine
     */
    function addMedicine(string memory _name, uint _expiryDate, string memory _dose, uint _price) public {
        medicineCount++;
        medicines[medicineCount] = Medicine(medicineCount, _name, _expiryDate, _dose, _price);
        emit MedicineAdded(medicineCount, _name);
    }
    
    /**
     * @dev Prescribe medicine to a patient
     * @param _id Id of the medicine
     * @param _patientAddress Address of the patient
     */
    function prescribeMedicine(uint _id, address _patientAddress,address _doctorAddress) public {
        require(doctors[_doctorAddress].id > 0, "Only registered doctors can prescribe medicine");
        require(patients[_patientAddress].id > 0, "Patient does not exist");
        
        patients[_patientAddress].diseases.push(medicines[_id].name);
        emit MedicinePrescribed(_id, _patientAddress, _doctorAddress);
    }
    
    /**
     * @dev Update the age of the patient
     * @param _age New age of the patient
     */
    function updatePatientAge(uint _age, address _patientAddress) public {
        patients[_patientAddress].age = _age;
        emit PatientAgeUpdated(_patientAddress, _age);
    }
    
    /**
     * @dev View patient data
     * @param _patient Address of the patient
     * @return id ID of the patient
     * @return name Name of the patient
     * @return age Age of the patient
     * @return diseases Array of diseases of the patient
     */
    function viewPatientData(address _patient) public view returns (uint, string memory, uint, string[] memory) {
        Patient memory patient = patients[_patient];
        return (patient.id, patient.name, patient.age, patient.diseases);
    }

    /*function viewDoctorData(string memory _doctor) public view returns (uint, string memory, string memory, string memory) {
        DoctorAddress memory doctor = doctorsAddress[_doctor];
        return (doctor.id, doctor.name, doctor.qualification, doctor.workPlace);
    }*/
    
    /**
     * @dev View medicine details
     * @param _id ID of the medicine
     * @return name Name of the medicine
     * @return expiryDate Expiry date of the medicine
     * @return dose Dose prescribed for the medicine
     * @return price Price of the medicine
     */
    function viewMedicineDetails(uint _id) public view returns (string memory, uint, string memory, uint) {
        Medicine memory medicine = medicines[_id];
        return (medicine.name, medicine.expiryDate, medicine.dose, medicine.price);
    }


}
