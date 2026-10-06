-- MediTrack query collection
-- Run these queries individually in pgAdmin Query Tool as needed.

-- 1. Confirm current database
SELECT current_database();

-- 2. List tables
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- 3. View all departments
SELECT * FROM Department;

-- 4. View all doctors
SELECT * FROM Doctor;

-- 5. View all patients
SELECT * FROM Patient;

-- 6. View all appointments
SELECT * FROM Appointment;

-- 7. View all prescriptions
SELECT * FROM Prescription;

-- 8. Appointment report: patient, doctor, department
SELECT
    a.AppointmentID, p.PatientName, d.DoctorName, dep.DepartmentName,
    a.AppointmentDate, a.StartTime, a.EndTime, a.Status, a.Reason
FROM Appointment a
JOIN Patient p ON a.PatientID = p.PatientID
JOIN Doctor d ON a.DoctorID = d.DoctorID
JOIN Department dep ON d.DepartmentID = dep.DepartmentID
ORDER BY a.AppointmentDate, a.StartTime;

-- 9. Prescription report with patient and doctor
SELECT
    p.PatientName, d.DoctorName, a.AppointmentDate,
    pr.MedicationName, pr.Dosage, pr.Frequency, pr.Duration, pr.Notes
FROM Prescription pr
JOIN Appointment a ON pr.AppointmentID = a.AppointmentID
JOIN Patient p ON a.PatientID = p.PatientID
JOIN Doctor d ON a.DoctorID = d.DoctorID
ORDER BY a.AppointmentDate;

-- 10. Count appointments per doctor, including doctors with zero
SELECT d.DoctorName, d.Specialization,
       COUNT(a.AppointmentID) AS TotalAppointments
FROM Doctor d
LEFT JOIN Appointment a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, d.DoctorName, d.Specialization
ORDER BY TotalAppointments DESC;

-- 11. Count appointments by department
SELECT dep.DepartmentName, COUNT(a.AppointmentID) AS TotalAppointments
FROM Department dep
LEFT JOIN Doctor d ON dep.DepartmentID = d.DepartmentID
LEFT JOIN Appointment a ON d.DoctorID = a.DoctorID
GROUP BY dep.DepartmentID, dep.DepartmentName
ORDER BY TotalAppointments DESC;

-- 12. Subquery: patients who have appointments
SELECT PatientID, PatientName, PhoneNumber, Email
FROM Patient
WHERE PatientID IN (SELECT PatientID FROM Appointment);

-- 13. Subquery: doctors with more than one appointment
SELECT DoctorName, Specialization
FROM Doctor
WHERE DoctorID IN (
    SELECT DoctorID
    FROM Appointment
    GROUP BY DoctorID
    HAVING COUNT(*) > 1
);

-- 14. Appointments on a chosen date (change the date if needed)
SELECT *
FROM Appointment
WHERE AppointmentDate = DATE '2026-10-05'
ORDER BY StartTime;

-- 15. Scheduled appointments only
SELECT *
FROM Appointment
WHERE Status = 'Scheduled'
ORDER BY AppointmentDate, StartTime;

-- 16. Index verification
SELECT indexname
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'appointment';

-- 17. Trigger verification
SELECT trigger_name
FROM information_schema.triggers
WHERE event_object_schema = 'public'
  AND event_object_table = 'appointment';

-- 18. Foreign-key relationship verification
SELECT
    tc.table_name AS child_table,
    kcu.column_name AS foreign_key,
    ccu.table_name AS parent_table,
    ccu.column_name AS referenced_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
  ON tc.constraint_name = kcu.constraint_name
 AND tc.constraint_schema = kcu.constraint_schema
JOIN information_schema.constraint_column_usage ccu
  ON ccu.constraint_name = tc.constraint_name
 AND ccu.constraint_schema = tc.constraint_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name;

-- 19. Count rows in all five tables
SELECT 'Department' AS table_name, COUNT(*) AS total FROM Department
UNION ALL SELECT 'Doctor', COUNT(*) FROM Doctor
UNION ALL SELECT 'Patient', COUNT(*) FROM Patient
UNION ALL SELECT 'Appointment', COUNT(*) FROM Appointment
UNION ALL SELECT 'Prescription', COUNT(*) FROM Prescription;

-- 20. CRUD example: UPDATE (example changes a patient's address)
-- Uncomment and change the ID/value before running.
-- UPDATE Patient SET Address = 'Thane West' WHERE PatientID = 1;

-- 21. CRUD example: DELETE (use a test record only; check references first)
-- This is commented out to protect existing data.
-- DELETE FROM Patient WHERE PatientID = 999;

-- 22. Optional view for a reusable appointment report
-- Run this statement once if you want a database view.
CREATE OR REPLACE VIEW vw_appointment_report AS
SELECT
    a.AppointmentID, p.PatientName, d.DoctorName, dep.DepartmentName,
    a.AppointmentDate, a.StartTime, a.EndTime, a.Status, a.Reason
FROM Appointment a
JOIN Patient p ON a.PatientID = p.PatientID
JOIN Doctor d ON a.DoctorID = d.DoctorID
JOIN Department dep ON d.DepartmentID = dep.DepartmentID;

-- View the report
SELECT * FROM vw_appointment_report
ORDER BY AppointmentDate, StartTime;
