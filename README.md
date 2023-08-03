# formula1-statistics-database

Analyze public formula1 data published on ergast/fastf1 API with Oracle Express/Free edition-

Note: This data CANNOT be used in any kind of commercial application due to how ergast licensing its data.
      You are however free to use this data for your own personal fun and personal development!

Requirements:

- OracleDB and client on Linux operatingsystem like OEL8, client can be any sutable linux distro.
- A working Oracle database >= 19c, could be EE,SE,XE,FREE edition , cloud or on premise.
- Oracle Application Express edition >= 22
- Oracle instant client >= 21c
- Oracle Java 11 JDK 
- Oracle SQLcl >= 23.2 complete installation and future maintenance is done with SQLcl liquibase.

A very easy way to get started is to install the Oracle Developers FREE 23c database that is free for use for us all!
See: https://www.oracle.com/database/free/

To be able to publish data a REST services you also need

Oracle ORDS >= 22.4 installed (Further instructions on this is planned , but mainly you need to publish the f1_rest_access_schema)

# Installation:

Follow the instructions in the README_FIRST.md in the sql subdirectory.

# Getting started with analysing formula 1 data.

See the demo_queries.sql file in the sql/demo subdirectory.

