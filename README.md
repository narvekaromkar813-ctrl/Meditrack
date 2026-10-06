MediTrack PostgreSQL Project Files
===================================

Files
-----
1. schema.sql  - Creates all five tables, the appointment-date index, trigger function, and trigger.
2. seed.sql    - Inserts fictional sample data into all five tables.
3. queries.sql - Includes SELECT, JOIN, aggregate, subquery, verification, and optional view queries.

How to run in pgAdmin 4
-----------------------
1. Create a database named meditrack.
2. Select meditrack, open Tools > Query Tool.
3. Open schema.sql, execute it first.
4. Open seed.sql, execute it second.
5. Run queries from queries.sql individually as needed.

Important
---------
- schema.sql drops existing project tables before recreating them. This deletes their existing data.
- Run seed.sql only once after a fresh schema setup; rerunning it may cause duplicate unique values or primary-key conflicts.
- Sample patient and prescription data are fictional and for coursework demonstration only.
- The overlap trigger checks for overlapping times, but like most simple triggers it is not a complete concurrency-safe scheduling solution for simultaneous transactions.
- The UPDATE and DELETE examples in queries.sql are commented out so they do not change or remove data accidentally.
