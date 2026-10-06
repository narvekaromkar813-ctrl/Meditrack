-- MediTrack sample data
-- Run schema.sql first, then run this file once on a fresh database.
-- Sample records are fictional and for database demonstration only.

INSERT INTO Department (DepartmentName, ContactNumber, Location)
VALUES
    ('Cardiology', '9876543210', 'First Floor'),
    ('Neurology', '9876543211', 'Second Floor'),
    ('Orthopedics', '9876543212', 'Third Floor'),
    ('Dermatology', '9876543213', 'First Floor'),
    ('General Medicine', '9876543214', 'Ground Floor');

INSERT INTO Doctor (DoctorName, Specialization, PhoneNumber, Email, DepartmentID)
VALUES
    ('Dr. Rahul Sharma', 'Heart Specialist', '9000000001', 'rahul@meditrack.com', 1),
    ('Dr. Priya Patel', 'Neurologist', '9000000002', 'priya@meditrack.com', 2),
    ('Dr. Amit Verma', 'Orthopedic Surgeon', '9000000003', 'amit@meditrack.com', 3),
    ('Dr. Neha Shah', 'Skin Specialist', '9000000004', 'neha@meditrack.com', 4),
    ('Dr. Karan Mehta', 'General Physician', '9000000005', 'karan@meditrack.com', 5);

INSERT INTO Patient (PatientName, Age, Gender, PhoneNumber, Email, Address)
VALUES
    ('Aarav Joshi', 25, 'Male', '9100000001', 'aarav@gmail.com', 'Mumbai'),
    ('Sneha Patil', 32, 'Female', '9100000002', 'sneha@gmail.com', 'Thane'),
    ('Rohan Desai', 45, 'Male', '9100000003', 'rohan@gmail.com', 'Navi Mumbai'),
    ('Ananya Shah', 28, 'Female', '9100000004', 'ananya@gmail.com', 'Mulund'),
    ('Vivaan Mehta', 38, 'Male', '9100000005', 'vivaan@gmail.com', 'Dombivli');

INSERT INTO Appointment
    (PatientID, DoctorID, AppointmentDate, StartTime, EndTime, Status, Reason)
VALUES
    (1, 1, DATE '2026-10-05', TIME '09:00', TIME '09:30', 'Scheduled', 'Heart checkup'),
    (2, 2, DATE '2026-10-05', TIME '10:00', TIME '10:30', 'Scheduled', 'Headache'),
    (3, 3, DATE '2026-10-06', TIME '11:00', TIME '11:30', 'Completed', 'Knee pain'),
    (4, 4, DATE '2026-10-06', TIME '12:00', TIME '12:30', 'Scheduled', 'Skin allergy'),
    (5, 5, DATE '2026-10-07', TIME '14:00', TIME '14:30', 'Completed', 'Regular checkup');

INSERT INTO Prescription
    (AppointmentID, MedicationName, Dosage, Frequency, Duration, Notes)
VALUES
    (1, 'Aspirin', '75 mg', 'Once daily', '5 days', 'Take after food'),
    (2, 'Paracetamol', '500 mg', 'Twice daily', '3 days', 'For headache'),
    (3, 'Ibuprofen', '200 mg', 'Twice daily', '5 days', 'Take after food'),
    (4, 'Cetirizine', '10 mg', 'Once daily', '5 days', 'For allergy symptoms'),
    (5, 'Vitamin D3', '1000 IU', 'Once daily', '30 days', 'Take with a meal');

-- Verify inserted sample data
SELECT 'Department' AS table_name, COUNT(*) AS total FROM Department
UNION ALL SELECT 'Doctor', COUNT(*) FROM Doctor
UNION ALL SELECT 'Patient', COUNT(*) FROM Patient
UNION ALL SELECT 'Appointment', COUNT(*) FROM Appointment
UNION ALL SELECT 'Prescription', COUNT(*) FROM Prescription;
