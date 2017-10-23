# PostgreSQL 9.6 Test Database 

This will configure a VM appropriate for testing VRAM with PostgreSQL 9.6

## Supporting Files

The sample-data.sql file may be large, so maintain outside of git.

* TODO: consider LFS for sample-data

* To create sample-data as a copy of an existing database:

        pg_dump -Upostgres <database> > sample-data.sql

## How To Build VM

1. Build the PostgreSQL VM:

        vagrant up
        # this just created a new VM with PostgreSQL running at 192.168.33.10:5432
        # this will also create a database called `sample`
      
2. The database can be accessed on ipaddress 192.168.33.10:5432
