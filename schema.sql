-- MediTrack: Hospital Appointment & Doctor Scheduling System
-- PostgreSQL schema for pgAdmin 4
-- WARNING: This script drops existing MediTrack tables before recreating them.
-- Run only if you want a fresh database structure and are okay deleting existing data.

DROP TABLE IF EXISTS Prescription CASCADE;
DROP TABLE IF EXISTS Appointment CASCADE;
DROP TABLE IF EXISTS Patient CASCADE;
DROP TABLE IF EXISTS Doctor CASCADE;
DROP TABLE IF EXISTS Department CASCADE;

CREATE TABLE Department (
    DepartmentID SERIAL PRIMARY KEY,
    DepartmentName VARCHAR(100) UNIQUE NOT NULL,
    ContactNumber VARCHAR(15),
    Location VARCHAR(100)
);

CREATE TABLE Doctor (
    DoctorID SERIAL PRIMARY KEY,
    DoctorName VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100),
    PhoneNumber VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    DepartmentID INT REFERENCES Department(DepartmentID)
);

CREATE TABLE Patient (
    PatientID SERIAL PRIMARY KEY,
    PatientName VARCHAR(100) NOT NULL,
    Age INT CHECK (Age > 0 AND Age <= 120),
    Gender VARCHAR(20),
    PhoneNumber VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Address TEXT
);

CREATE TABLE Appointment (
    AppointmentID SERIAL PRIMARY KEY,
    PatientID INT NOT NULL REFERENCES Patient(PatientID),
    DoctorID INT NOT NULL REFERENCES Doctor(DoctorID),
    AppointmentDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Status VARCHAR(20) DEFAULT 'Scheduled'
        CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled')),
    Reason TEXT,
    CHECK (EndTime > StartTime)
);

CREATE TABLE Prescription (
    PrescriptionID SERIAL PRIMARY KEY,
    AppointmentID INT NOT NULL REFERENCES Appointment(AppointmentID),
    MedicationName VARCHAR(100) NOT NULL,
    Dosage VARCHAR(100),
    Frequency VARCHAR(100),
    Duration VARCHAR(100),
    Notes TEXT,
    PrescriptionDate DATE DEFAULT CURRENT_DATE
);

-- Index for appointment-date searches
CREATE INDEX idx_appointment_date ON Appointment (AppointmentDate);

-- Prevent overlapping appointments for the same doctor on the same date.
-- Cancelled appointments do not block a time slot.
CREATE OR REPLACE FUNCTION prevent_doctor_overlap()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Status <> 'Cancelled' AND EXISTS (
        SELECT 1
        FROM Appointment existing
        WHERE existing.DoctorID = NEW.DoctorID
          AND existing.AppointmentDate = NEW.AppointmentDate
          AND existing.Status <> 'Cancelled'
          AND existing.AppointmentID <> COALESCE(NEW.AppointmentID, -1)
          AND NEW.StartTime < existing.EndTime
          AND NEW.EndTime > existing.StartTime
    ) THEN
        RAISE EXCEPTION
            'Doctor already has an overlapping appointment.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_doctor_overlap
BEFORE INSERT OR UPDATE ON Appointment
FOR EACH ROW
EXECUTE FUNCTION prevent_doctor_overlap();
