SELECT *
FROM prescriber;

SELECT *
FROM prescription;

SELECT *
FROM drug;
-- 1. 
    --a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
SELECT npi, MAX(total_claim_count)
FROM prescription
GROUP BY npi
ORDER BY MAX(total_claim_count) DESC
LIMIT 1;
		-- npi 1912011792	total # of claims: 4538
	--  b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.
SELECT prescriber.nppes_provider_first_name, prescriber.nppes_provider_last_org_name,  prescriber.specialty_description, SUM(prescription.total_claim_count)
FROM prescriber
RIGHT JOIN prescription ON prescription.npi = prescriber.npi
GROUP BY prescriber.nppes_provider_first_name, 
    	 prescriber.nppes_provider_last_org_name, 
    	 prescriber.specialty_description,
		 total_claim_count
ORDER BY total_claim_count DESC
LIMIT 1;
		-- "DAVID"	"COFFEY"	"Family Practice"	total claims - 4538

--2. 
    -- a. Which specialty had the most total number of claims (totaled over all drugs)?
SELECT prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claim_count
FROM prescriber
RIGHT JOIN prescription ON prescription.npi = prescriber.npi
GROUP BY prescriber.specialty_description
ORDER BY total_claim_count DESC
LIMIT 1;
		-- "Family Practice"	total claims 9752347
	-- b. Which specialty had the most total number of claims for opioids?
SELECT prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claim_count 
FROM prescriber
JOIN prescription ON prescription.npi = prescriber.npi
JOIN drug ON drug.drug_name = prescription.drug_name
WHERE opioid_drug_flag LIKE 'Y' 
GROUP BY prescriber.specialty_description
ORDER BY total_claim_count DESC
LIMIT 1;
		-- "Nurse Practitioner"	CLAIM COUNT 900845
		
	--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?
SELECT prescriber.specialty_description
FROM prescriber 
LEFT JOIN prescription ON prescription.npi = prescriber.npi
WHERE prescription.npi IS NULL;

	-- 	d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?
SELECT prescriber.specialty_description, SUM(prescription.total_claim_count) AS total_claim_count 
FROM prescriber
JOIN prescription ON prescription.npi = prescriber.npi
JOIN drug ON drug.drug_name = prescription.drug_name
WHERE opioid_drug_flag LIKE 'Y'
GROUP BY prescriber.specialty_description
ORDER BY total_claim_count DESC


