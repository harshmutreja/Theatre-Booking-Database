# Theatre-Booking-Database
A PostgreSQL database for a theatre and drama academy. It covers show ticketing, student enrolment in courses and classes, and staff records.

What it includes
11 tables covering customers, shows, show events, bookings, students, courses, classes and staff.
Keys and constraints: primary and foreign keys, composite keys for many-to-many links, and checks for ticket limits (1 to 10), course levels, grades and salaries.
Sample data: fictional shows, customers, students, staff and courses.
Example queries: joins across three or four tables, aggregation for ticket totals, a union across two staff tables, and filtered date searches.

Design notes
Staff are split into tutors and guest actors, since they have different pay structures (annual salary against a fee per class).
Show events are separate from shows, so one show can run on many dates and times.
Bookings link a customer to a show event, with a ticket quantity.
