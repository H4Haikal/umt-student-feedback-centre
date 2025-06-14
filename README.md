# UMT Student Feedback Crowdsourcing Web App

## 📘 Project Overview

This is a web-based application project, developed for students and staff. The system allows students to submit feedback and engage in forum discussions, while staff can view, analyze, and respond to feedbacks.

The platform supports transparency, peer-to-peer interaction, and helps university staff prioritize and respond to the most important student issues.

---

## 🔧 Technologies Used

- Java Servlets & JSP
- MySQL Database
- HTML5, CSS and JavaScript
- Chart.js for visual charts
- JSTL for dynamic JSP content

---

## 🧱 Modules

### 1. User Module
- Login and registration
- Role-based access (student, staff or admin)

### 2. Feedback Module
- Students can post feedback in various categories (Lecturer, Facility, etc.)
- Students can upvote feedback submitted by others

### 3. Report Module (Staff only)
this allows staff to generate report that highlight the most upvote feedback, based on category or the most urgent feedback
- View feedback summary (Pending, Reviewed, Resolved)
- Pie chart: feedback by category
- Bar chart: feedback by status
- Table: top 5 most upvoted feedbacks

### 4. Forum Module
- Students and staff can post and comment on discussion topics

---

## 🗃️ Database Structure

Database: `crowdsourcing_db`

Includes tables:
- `users`
- `categories`
- `feedback`
- `upvotes`
- `reports`
- `report_feedback`
- `forum_posts`
- `comments`



---

## How to Run

1. Clone the project to your local system.
2. Import it into NetBeans or Eclipse (with Tomcat).
3. Import the provided SQL file into MySQL.
4. Update database connection credentials in the Servlet.
5. Run the project and visit: `http://localhost:8080/`

---

## 👨‍💻 Team Members

- Haris (Feedback Module)
- Haikal (User + Forum Module)
- Ahmad(report generation module)

---

## 📅 Completed On

June 13, 2025

---

## 📂 License

This project is for academic use only at University Malaysia Terengganu (UMT).
