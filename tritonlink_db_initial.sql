DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Class;
DROP TABLE IF EXISTS FACULTY;
DROP TABLE IF EXISTS ThesisCommittee;
DROP TABLE IF EXISTS Degree;
DROP TABLE IF EXISTS Section;
DROP TABLE IF EXISTS Meeting;
DROP TABLE IF EXISTS UndergraduateStudent;
DROP TABLE IF EXISTS MS;
DROP TABLE IF EXISTS PhdCandidate;
DROP TABLE IF EXISTS PhdPreCandidate;
DROP TABLE IF EXISTS BachelorMS;
DROP TABLE IF EXISTS Period;
DROP TABLE IF EXISTS Attendance;
DROP TABLE IF EXISTS Prohibation;
DROP TABLE IF EXISTS PreDegree;
DROP TABLE IF EXISTS DegreeEarned;
DROP TABLE IF EXISTS Teach;
DROP TABLE IF EXISTS Prerequisite;
DROP TABLE IF EXISTS Waitlist;
DROP TABLE IF EXISTS EnrolledList;
DROP TABLE IF EXISTS GradeHistory;
DROP TABLE IF EXISTS CourseConcentration;
DROP TABLE IF EXISTS CourseCategory;
DROP TABLE IF EXISTS CourseBelongToCategory;
DROP TABLE IF EXISTS CourseBelongToConcentration;
DROP TABLE IF EXISTS Club;
DROP TABLE IF EXISTS ClubMember;
DROP TABLE IF EXISTS CoursePreName;



CREATE TABLE Student(
	student_num CHAR(30) PRIMARY KEY,
	first_name CHAR(20) NOT NULL,
	last_name CHAR(20) NOT NULL,
	middle_name CHAR(20),
	SSN INTEGER NOT NULL UNIQUE,
	enrolled BOOLEAN NOT NULL,
	residency TEXT NOT NULL
);

CREATE TABLE Department(
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL
);

CREATE TABLE Degree(
	id SERIAL,
	type CHAR(20) NOT NULL,
	name CHAR(50) NOT NULL,
	required_units INTEGER NOT NULL,
	PRIMARY KEY(type, name)
);

CREATE TABLE Period(
	id SERIAL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	PRIMARY KEY(start_date, end_date)
);

CREATE TABLE PreDegree(
	id SERIAL,
	type CHAR(20) NOT NULL,
	name CHAR(50) NOT NULL,
	UNIQUE(name, type),
	PRIMARY KEY(id)
);

CREATE TABLE Club(
	id SERIAL PRIMARY KEY,
	club_name CHAR(50) UNIQUE NOT NULL
);


CREATE TABLE Course(
	id SERIAL PRIMARY KEY,
	course_name CHAR(20) UNIQUE NOT NULL,
	min_units INTEGER NOT NULL,
	max_units INTEGER NOT NULL,
	can_take_by_letter BOOLEAN NOT NULL,
	can_take_by_SU BOOLEAN NOT NULL,
	department INTEGER NOT NULL REFERENCES Department(id),
	need_consent BOOLEAN NOT NULL,
	need_lab BOOLEAN NOT NULL 
);

CREATE TABLE Class(
	id SERIAL,
	course_id INTEGER NOT NULL REFERENCES Course(id),
	year INTEGER NOT NULL,
	quarter CHAR(20) NOT NULL,
	title TEXT NOT NULL,
	PRIMARY KEY(course_id, year, quarter)
);

CREATE TABLE FACULTY(
	name CHAR(30) PRIMARY KEY,
	department INTEGER NOT NULL REFERENCES Department(id),
	title CHAR(20)
);


CREATE TABLE ThesisCommittee(
	student_num CHAR(30) NOT NULL REFERENCES Student(student_num),
	faculty_name CHAR(30) NOT NULL REFERENCES FACULTY(name),
	PRIMARY KEY(student_num, faculty_name)
);

CREATE TABLE Section(
	section_num INTEGER PRIMARY KEY,
	class_id INTEGER NOT NULL REFERENCES Class(id),
	student_num_limit INTEGER NOT NULL,
	Instructor_id CHAR(30) NOT NULL REFERENCES FACULTY(name)
);

CREATE TABLE Meeting(
	section_num INTEGER NOT NULL REFERENCES Section(section_num),
	type CHAR(20) NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	meeting_days CHAR(10) NOT NULL,
	meeting_time_start CHAR(20) NOT NULL,
	meeting_time_end CHAR(20) NOT NULL,
	address TEXT NOT NULL,
	is_mandatory BOOLEAN NOT NULL,
	PRIMARY KEY(section_num,type,start_date,end_date,meeting_days,meeting_time_start,meeting_time_end)
);

CREATE TABLE UndergraduateStudent(
	student_num CHAR(30) PRIMARY KEY REFERENCES Student(student_num),
	college CHAR(10),
	major CHAR(50) NOT NULL,
	minor CHAR(50)
);

CREATE TABLE MS(
	student_num CHAR(30) PRIMARY KEY REFERENCES Student(student_num),
	department INTEGER NOT NULL REFERENCES Department(id)
);

CREATE TABLE PhdCandidate(
	student_num CHAR(30) PRIMARY KEY REFERENCES Student(student_num),
	department INTEGER NOT NULL REFERENCES Department(id),
	advisor_id CHAR(30) NOT NULL REFERENCES FACULTY(name)
);

CREATE TABLE PhdPreCandidate(
	student_num CHAR(30) PRIMARY KEY REFERENCES Student(student_num),
	department INTEGER NOT NULL REFERENCES Department(id)
);

CREATE TABLE BachelorMS(
	student_num CHAR(30) PRIMARY KEY REFERENCES Student(student_num),
	department INTEGER NOT NULL REFERENCES Department(id)
);

CREATE TABLE Attendance(
	student_num CHAR(30) NOT NULL REFERENCES Student(student_num),
	period_id INTEGER NOT NULL REFERENCES Period(id),
	PRIMARY KEY(student_num, period_id)
);

CREATE TABLE Prohibation(
	student_num CHAR(30) NOT NULL REFERENCES Student(student_num),
	reason TEXT NOT NULL,
	start_time char(50) NOT NULL,
	end_time char(50) NOT NULL,
	PRIMARY KEY(student_num, start_time)
);

CREATE TABLE DegreeEarned(
	student_num CHAR(30) NOT NULL REFERENCES Student(student_num),
	degree_id INTEGER NOT NULL REFERENCES PreDegree(id),
	PRIMARY KEY(student_num, degree_id)
);

CREATE TABLE Teach(
	advisor_id CHAR(30) NOT NULL REFERENCES FACULTY(name),
	class_id INTEGER NOT NULL REFERENCES Class(id),
	PRIMARY KEY(advisor_id, class_id)
);

CREATE TABLE Prerequisite(
	pre_course_id INTEGER NOT NULL REFERENCES Course(id),
	target_course_id INTEGER NOT NULL REFERENCES Course(id)
);


CREATE TABLE Waitlist(
	student_num CHAR(30) NOT NULL REFERENCES Student(student_num),
	section_num INTEGER NOT NULL REFERENCES Section(section_num),
	position INTEGER NOT NULL,
	PRIMARY KEY(student_num, section_num)
);

CREATE TABLE EnrolledList(
	student_num CHAR(30) NOT NULL REFERENCES Student(student_num),
	section_num INTEGER NOT NULL REFERENCES Section(section_num),
	grade CHAR(5),
	grade_option CHAR(10) NOT NULL,
	units INTEGER NOT NULL,
	PRIMARY KEY(student_num, section_num)
);

CREATE TABLE GradeHistory(
	student_num CHAR(30) NOT NULL REFERENCES Student(student_num),
	section_num INTEGER NOT NULL REFERENCES Section(section_num),
	grade CHAR(5),
	grade_option CHAR(10) NOT NULL,
	PRIMARY KEY(student_num, section_num)
);

CREATE TABLE CourseConcentration(
	degree_id INTEGER REFERENCES Degree(id),
	concentration_name char(50) NOT NULL,
	required_units INTEGER NOT NULL,
	mini_gpa FLOAT NOT NULL,
	PRIMARY KEY(concentration_name)
);

CREATE TABLE CourseCategory(
	degree_id INTEGER REFERENCES Degree(id),
	category_name CHAR(50) NOT NULL,
	required_units INTEGER NOT NULL,
	mini_gpa FLOAT NOT NULL,
	PRIMARY KEY(category_name)
);

CREATE TABLE CourseBelongToCategory(
	category_name char(50) NOT NULL REFERENCES CourseCategory(category_name),
	course_id INTEGER NOT NULL REFERENCES Course(id),
	PRIMARY KEY(category_name, course_id)
);

CREATE TABLE CourseBelongToConcentration(
	concentration_name char(50) NOT NULL REFERENCES CourseConcentration(concentration_name),
	course_id INTEGER NOT NULL REFERENCES Course(id),
	PRIMARY KEY(concentration_name, course_id)
);

CREATE TABLE ClubMember(
	club_id INTEGER NOT NULL REFERENCES Club(id),
	student_num CHAR(30) NOT NULL REFERENCES Student(student_num),
	PRIMARY KEY(club_id, student_num)
);

CREATE TABLE CoursePreName(
	Course_id INTEGER NOT NULL REFERENCES Course(id),
	name CHAR(20) NOT NULL,
	PRIMARY KEY(Course_id, name) 
);