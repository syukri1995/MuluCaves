# CSC584 — Tourism Web App: Full Project Plan
**Assignment: Tourism in Malaysia | Semester March 2026 – August 2026**
**Tourism Spot: Mulu Caves, Sarawak**

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack](#2-tech-stack)
3. [Project Folder Structure](#3-project-folder-structure)
4. [Database Schema](#4-database-schema)
5. [Maven Dependencies (pom.xml)](#5-maven-dependencies-pomxml)
6. [Frontend CDN Libraries](#6-frontend-cdn-libraries)
7. [Architecture & Flow](#7-architecture--flow)
8. [Part 1 — Public Website Pages](#8-part-1--public-website-pages)
9. [Part 2 — Visitor Inquiry System](#9-part-2--visitor-inquiry-system)
10. [Part 3 — Admin Portal](#10-part-3--admin-portal)
11. [Utility Classes](#11-utility-classes)
12. [web.xml Configuration](#12-webxml-configuration)
13. [UI/UX Recommendations](#13-uiux-recommendations)
14. [AWS Deployment Guide](#14-aws-deployment-guide)
15. [Submission Checklist](#15-submission-checklist)
16. [Rubric Impact Summary](#16-rubric-impact-summary)

---

## 1. Project Overview

A dynamic web application for **Mulu Caves, Sarawak** — one of Malaysia's UNESCO World Heritage Sites. The system has two main parts:

- **Public Website** — visitors learn about Mulu Caves and submit inquiries
- **Admin Portal** — secured area for staff to manage and view visitor inquiries

---

## 2. Tech Stack

| Layer | Technology | Version |
|---|---|---|
| Server | Apache Tomcat | 10.x |
| Language | Java | 21 |
| Web framework | JSP + Java Servlets | Jakarta EE 10 |
| Database | MySQL | 8.x |
| Build tool | Maven | 3.9+ |
| Frontend UI | Bootstrap 5 | 5.3.3 |
| Data table | jQuery DataTables | 2.0.3 |
| Password hashing | jBCrypt | 0.4 |
| Connection pool | HikariCP | 5.1.0 |
| Logging | Logback + SLF4J | 1.5.3 |
| Validation | Apache Commons Validator | 1.8.0 |

---

## 3. Project Folder Structure

```
mulu-caves/
├── pom.xml
├── tourism_db.sql                      ← Include in ZIP submission
├── src/
│   └── main/
│       ├── java/
│       │   └── com/tourism/
│       │       ├── servlet/
│       │       │   ├── InquiryServlet.java
│       │       │   ├── LoginServlet.java
│       │       │   ├── LogoutServlet.java
│       │       │   └── DashboardServlet.java
│       │       ├── dao/
│       │       │   ├── InquiryDAO.java
│       │       │   └── AdminDAO.java
│       │       ├── model/
│       │       │   ├── Inquiry.java
│       │       │   └── Admin.java
│       │       ├── filter/
│       │       │   └── AuthFilter.java
│       │       └── util/
│       │           └── DBConnection.java
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml
│           ├── css/
│           │   └── style.css
│           ├── js/
│           │   └── main.js
│           ├── images/
│           │   ├── hero/
│           │   │   └── mulu-hero.jpg
│           │   ├── gallery/
│           │   │   ├── gallery-1.jpg
│           │   │   ├── gallery-2.jpg
│           │   │   ├── gallery-3.jpg
│           │   │   ├── gallery-4.jpg
│           │   │   ├── gallery-5.jpg
│           │   │   ├── gallery-6.jpg
│           │   │   ├── gallery-7.jpg
│           │   │   └── gallery-8.jpg
│           │   ├── activities/
│           │   │   ├── cave-exploration.jpg
│           │   │   ├── canopy-walk.jpg
│           │   │   ├── bat-exodus.jpg
│           │   │   └── jungle-trekking.jpg
│           │   └── accommodation/
│           │       ├── marriott.jpg
│           │       ├── longhouse.jpg
│           │       ├── camp5.jpg
│           │       └── garden-bungalow.jpg
│           ├── includes/
│           │   ├── header.jsp           ← Shared navbar
│           │   └── footer.jsp
│           ├── index.jsp                ← Home page
│           ├── gallery.jsp              ← Gallery (8 images)
│           ├── activities.jsp           ← Activities (4 items)
│           ├── accommodation.jsp        ← Accommodation (4 items)
│           ├── developer.jsp            ← Developer info
│           ├── inquiry.jsp              ← Public inquiry form
│           └── admin/
│               ├── login.jsp
│               └── dashboard.jsp
```

---

## 4. Database Schema

### 4.1 Create Database

```sql
CREATE DATABASE IF NOT EXISTS tourism_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE tourism_db;
```

### 4.2 Inquiries Table

Stores all public form submissions.

```sql
CREATE TABLE inquiries (
  id           INT           AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(100)  NOT NULL,
  contact      VARCHAR(20)   NOT NULL,
  gender       ENUM('Male', 'Female', 'Other') NOT NULL,
  email        VARCHAR(150)  NOT NULL,
  heard_from   VARCHAR(100)  NOT NULL,
  message      TEXT          NOT NULL,
  submitted_at TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);
```

> **Note:** `submitted_at` is system-generated — this earns the "Excellent" mark under Database Persistence (rubric explicitly mentions system-generated timestamps).

### 4.3 Admin Users Table

Stores hashed admin credentials.

```sql
CREATE TABLE admin_users (
  id         INT          AUTO_INCREMENT PRIMARY KEY,
  username   VARCHAR(50)  NOT NULL UNIQUE,
  password   VARCHAR(255) NOT NULL,
  created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);
```

### 4.4 Seed Admin Account

> **Important:** Replace `$2a$12$...` with an actual BCrypt hash. Generate it using `BCrypt.hashpw("admin123", BCrypt.gensalt())` in a small Java utility class before inserting.

```sql
INSERT INTO admin_users (username, password)
VALUES ('admin', '$2a$12$ReplaceWithActualBCryptHashHere');
```

### 4.5 Sample Inquiry Data (for testing)

```sql
INSERT INTO inquiries (name, contact, gender, email, heard_from, message) VALUES
('Ahmad Razif',    '0123456789', 'Male',   'ahmad@email.com',  'Social Media',  'When is the best season to visit Mulu Caves?'),
('Siti Nurfatin',  '0198765432', 'Female', 'siti@email.com',   'Friend',        'Do you offer group packages?'),
('David Lim',      '0112233445', 'Male',   'david@email.com',  'Google Search', 'Is the canopy walk suitable for children?'),
('Nurul Ain',      '0167890123', 'Female', 'nurul@email.com',  'Travel Blog',   'What accommodation is available near the caves?');
```

### 4.6 Complete SQL File (`tourism_db.sql`)

Save this as `tourism_db.sql` in your project root for submission.

```sql
-- CSC584 Tourism Web App | Mulu Caves, Sarawak
-- Student: [Your Name] | Student ID: [Your ID]
-- Semester: March 2026 – August 2026

CREATE DATABASE IF NOT EXISTS tourism_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE tourism_db;

DROP TABLE IF EXISTS inquiries;
DROP TABLE IF EXISTS admin_users;

CREATE TABLE admin_users (
  id         INT          AUTO_INCREMENT PRIMARY KEY,
  username   VARCHAR(50)  NOT NULL UNIQUE,
  password   VARCHAR(255) NOT NULL,
  created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE inquiries (
  id           INT           AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(100)  NOT NULL,
  contact      VARCHAR(20)   NOT NULL,
  gender       ENUM('Male', 'Female', 'Other') NOT NULL,
  email        VARCHAR(150)  NOT NULL,
  heard_from   VARCHAR(100)  NOT NULL,
  message      TEXT          NOT NULL,
  submitted_at TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO admin_users (username, password)
VALUES ('admin', '$2a$12$ReplaceWithActualBCryptHashHere');

INSERT INTO inquiries (name, contact, gender, email, heard_from, message) VALUES
('Ahmad Razif',   '0123456789', 'Male',   'ahmad@email.com',  'Social Media',  'When is the best season to visit Mulu Caves?'),
('Siti Nurfatin', '0198765432', 'Female', 'siti@email.com',   'Friend',        'Do you offer group packages?'),
('David Lim',     '0112233445', 'Male',   'david@email.com',  'Google Search', 'Is the canopy walk suitable for children?'),
('Nurul Ain',     '0167890123', 'Female', 'nurul@email.com',  'Travel Blog',   'What accommodation is available near the caves?');
```

---

## 5. Maven Dependencies (`pom.xml`)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.tourism</groupId>
    <artifactId>mulu-caves</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>war</packaging>

    <properties>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>

        <!-- ===== CORE ===== -->
        <dependency>
            <groupId>jakarta.servlet</groupId>
            <artifactId>jakarta.servlet-api</artifactId>
            <version>6.0.0</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>jakarta.servlet.jsp</groupId>
            <artifactId>jakarta.servlet.jsp-api</artifactId>
            <version>3.1.1</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>jakarta.servlet.jsp.jstl</groupId>
            <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
            <version>3.0.0</version>
        </dependency>
        <dependency>
            <groupId>org.glassfish.web</groupId>
            <artifactId>jakarta.servlet.jsp.jstl</artifactId>
            <version>3.0.1</version>
        </dependency>
        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <version>8.3.0</version>
        </dependency>

        <!-- ===== SECURITY ===== -->
        <dependency>
            <groupId>org.mindrot</groupId>
            <artifactId>jbcrypt</artifactId>
            <version>0.4</version>
        </dependency>

        <!-- ===== VALIDATION ===== -->
        <dependency>
            <groupId>commons-validator</groupId>
            <artifactId>commons-validator</artifactId>
            <version>1.8.0</version>
        </dependency>
        <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-lang3</artifactId>
            <version>3.14.0</version>
        </dependency>

        <!-- ===== CONNECTION POOL ===== -->
        <dependency>
            <groupId>com.zaxxer</groupId>
            <artifactId>HikariCP</artifactId>
            <version>5.1.0</version>
        </dependency>

        <!-- ===== LOGGING ===== -->
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>2.0.12</version>
        </dependency>
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-classic</artifactId>
            <version>1.5.3</version>
        </dependency>

    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-war-plugin</artifactId>
                <version>3.4.0</version>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.13.0</version>
                <configuration>
                    <source>21</source>
                    <target>21</target>
                </configuration>
            </plugin>
        </plugins>
    </build>

</project>
```

---

## 6. Frontend CDN Libraries

Add inside `<head>` of every JSP page (or in `header.jsp`):

```html
<!-- Bootstrap 5 — responsive layout -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery — required by DataTables -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- jQuery DataTables + Bootstrap 5 skin (REQUIRED by assignment rubric) -->
<link href="https://cdn.datatables.net/2.0.3/css/dataTables.bootstrap5.min.css" rel="stylesheet">
<script src="https://cdn.datatables.net/2.0.3/js/dataTables.min.js"></script>
<script src="https://cdn.datatables.net/2.0.3/js/dataTables.bootstrap5.min.js"></script>

<!-- Font Awesome 6 — icons for navbar, cards, activities -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">

<!-- Animate.css — hero entrance animations -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet">

<!-- Lightbox2 — popup viewer for 8-image gallery -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.4/css/lightbox.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.4/js/lightbox.min.js"></script>

<!-- SweetAlert2 — polished success/error popups -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
```

---

## 7. Architecture & Flow

```
Browser
  │
  ├── Public Pages (JSP)
  │     ├── index.jsp
  │     ├── gallery.jsp
  │     ├── activities.jsp
  │     ├── accommodation.jsp
  │     ├── developer.jsp
  │     └── inquiry.jsp ──POST──► InquiryServlet ──► InquiryDAO ──► inquiries table
  │
  └── Admin Pages (JSP)
        ├── admin/login.jsp ──POST──► LoginServlet ──► AdminDAO ──► admin_users table
        │                                 │
        │                          HttpSession (login state)
        │
        └── admin/dashboard.jsp ◄──── DashboardServlet ◄──► InquiryDAO ◄──► inquiries table
              (protected by AuthFilter — redirects to login if no session)
```

### Request lifecycle for inquiry form submission

1. User fills `inquiry.jsp` and clicks Submit
2. jQuery validates all fields client-side before allowing POST
3. `InquiryServlet` receives POST, validates server-side with Commons Validator
4. `InquiryDAO.save()` inserts row via HikariCP connection pool
5. Servlet sets success attribute, forwards back to `inquiry.jsp`
6. JSP checks attribute, triggers SweetAlert2 success popup

### Request lifecycle for admin login

1. Admin visits `admin/login.jsp`, submits credentials
2. `LoginServlet` receives POST, queries `admin_users` via `AdminDAO`
3. `BCrypt.checkpw()` compares input against stored hash
4. On success: `HttpSession` created, redirect to `admin/dashboard.jsp`
5. On failure: redirect to `login.jsp?error=1`
6. `AuthFilter` intercepts all `/admin/*` URLs — if no session, redirect to login

---

## 8. Part 1 — Public Website Pages

### 8.1 Shared Navbar (`includes/header.jsp`)

All pages must include this. Consistent navigation is worth 15% of marks.

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mulu Caves — Sarawak's Natural Wonder</title>
    <!-- CDN links here -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/index.jsp">
            <i class="fas fa-mountain me-2"></i>Mulu Caves
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/gallery.jsp">Gallery</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/activities.jsp">Activities</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/accommodation.jsp">Accommodation</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/inquiry.jsp">Inquiry</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/developer.jsp">Developer</a></li>
                <li class="nav-item">
                    <a class="nav-link" href="https://maps.google.com/?q=Mulu+Caves+Sarawak" target="_blank">
                        <i class="fas fa-map-marker-alt me-1"></i>Map
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>
```

### 8.2 Home Page (`index.jsp`)

```jsp
<%@ include file="includes/header.jsp" %>

<!-- Hero Section -->
<section class="hero-section position-relative">
    <img src="${pageContext.request.contextPath}/images/hero/mulu-hero.jpg"
         class="w-100 hero-img" alt="Mulu Caves Hero">
    <div class="hero-overlay position-absolute top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center">
        <div class="text-center text-white animate__animated animate__fadeInUp">
            <h1 class="display-3 fw-bold">Mulu Caves</h1>
            <p class="lead">Sarawak's UNESCO World Heritage — The World's Largest Cave Passage</p>
            <a href="${pageContext.request.contextPath}/inquiry.jsp" class="btn btn-warning btn-lg mt-3">
                Plan Your Visit
            </a>
            <a href="https://maps.google.com/?q=Mulu+Caves+Sarawak" target="_blank"
               class="btn btn-outline-light btn-lg mt-3 ms-2">
                <i class="fas fa-map-marker-alt me-1"></i>View on Map
            </a>
        </div>
    </div>
</section>

<!-- Introduction -->
<section class="py-5">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6">
                <h2>About Mulu Caves</h2>
                <p>Gunung Mulu National Park, a UNESCO World Heritage Site in Sarawak, Malaysia,
                   is home to the most impressive cave systems in the world. The Sarawak Chamber
                   is the largest underground chamber on Earth, capable of fitting 40 Boeing 747s.</p>
                <p>With over 295 km of surveyed passages, Mulu offers unparalleled adventures
                   from show caves to wild caving expeditions.</p>
            </div>
            <div class="col-md-6">
                <img src="${pageContext.request.contextPath}/images/gallery/gallery-1.jpg"
                     class="img-fluid rounded shadow" alt="Mulu Caves Interior">
            </div>
        </div>
    </div>
</section>

<%@ include file="includes/footer.jsp" %>
```

### 8.3 Gallery Page (`gallery.jsp`) — exactly 8 images required

```jsp
<%@ include file="includes/header.jsp" %>

<section class="py-5">
    <div class="container">
        <h2 class="text-center mb-4">Gallery</h2>
        <p class="text-center text-muted mb-5">Explore the breathtaking beauty of Mulu Caves</p>

        <div class="row g-3">
            <c:forEach var="i" begin="1" end="8">
                <div class="col-md-3 col-sm-6">
                    <a href="${pageContext.request.contextPath}/images/gallery/gallery-${i}.jpg"
                       data-lightbox="mulu-gallery"
                       data-title="Mulu Caves — Photo ${i}">
                        <img src="${pageContext.request.contextPath}/images/gallery/gallery-${i}.jpg"
                             class="img-fluid rounded shadow-sm gallery-thumb"
                             alt="Mulu Caves Gallery ${i}">
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<%@ include file="includes/footer.jsp" %>
```

### 8.4 Activities Page (`activities.jsp`) — exactly 4 items required

```jsp
<%@ include file="includes/header.jsp" %>

<section class="py-5">
    <div class="container">
        <h2 class="text-center mb-5">Things to Do at Mulu Caves</h2>

        <div class="row g-4">

            <!-- Activity 1 -->
            <div class="col-md-6">
                <div class="card h-100 shadow-sm">
                    <img src="${pageContext.request.contextPath}/images/activities/cave-exploration.jpg"
                         class="card-img-top" alt="Cave Exploration" style="height:220px; object-fit:cover;">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-cave me-2 text-warning"></i>Show Cave Tours</h5>
                        <p class="card-text">Explore the iconic Deer Cave, home to millions of bats,
                           and the majestic Lang's Cave with its stunning stalactites and stalagmites.
                           Guided tours depart daily at 8AM, 12PM, and 2PM.</p>
                    </div>
                </div>
            </div>

            <!-- Activity 2 -->
            <div class="col-md-6">
                <div class="card h-100 shadow-sm">
                    <img src="${pageContext.request.contextPath}/images/activities/canopy-walk.jpg"
                         class="card-img-top" alt="Canopy Walk" style="height:220px; object-fit:cover;">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-tree me-2 text-success"></i>Canopy Walk</h5>
                        <p class="card-text">Walk among the treetops on one of the world's longest
                           tree-based canopy walkways at 480 metres long and 25 metres above the
                           forest floor. Perfect for birdwatching enthusiasts.</p>
                    </div>
                </div>
            </div>

            <!-- Activity 3 -->
            <div class="col-md-6">
                <div class="card h-100 shadow-sm">
                    <img src="${pageContext.request.contextPath}/images/activities/bat-exodus.jpg"
                         class="card-img-top" alt="Bat Exodus" style="height:220px; object-fit:cover;">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-moon me-2 text-primary"></i>Bat Exodus</h5>
                        <p class="card-text">Witness one of nature's most spectacular events —
                           millions of bats spiraling out of Deer Cave at dusk every evening.
                           This natural phenomenon draws visitors from around the world.</p>
                    </div>
                </div>
            </div>

            <!-- Activity 4 -->
            <div class="col-md-6">
                <div class="card h-100 shadow-sm">
                    <img src="${pageContext.request.contextPath}/images/activities/jungle-trekking.jpg"
                         class="card-img-top" alt="Jungle Trekking" style="height:220px; object-fit:cover;">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-hiking me-2 text-danger"></i>Jungle Trekking</h5>
                        <p class="card-text">Trek through ancient rainforest trails to reach
                           the summit of Gunung Mulu. The 4-day summit trek passes through
                           multiple vegetation zones with stunning views at every elevation.</p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<%@ include file="includes/footer.jsp" %>
```

### 8.5 Accommodation Page (`accommodation.jsp`) — exactly 4 items required

```jsp
<%@ include file="includes/header.jsp" %>

<section class="py-5">
    <div class="container">
        <h2 class="text-center mb-5">Where to Stay Near Mulu Caves</h2>

        <div class="row g-4">

            <div class="col-md-6">
                <div class="card h-100 shadow-sm">
                    <img src="${pageContext.request.contextPath}/images/accommodation/marriott.jpg"
                         class="card-img-top" alt="Marriott" style="height:220px; object-fit:cover;">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-hotel me-2 text-warning"></i>Marriott Mulu Resort</h5>
                        <p class="card-text">The only five-star resort in Mulu, offering luxurious
                           longhouse-style rooms set over the Melinau River. Features a pool,
                           spa, and direct cave tour access. From RM 450/night.</p>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card h-100 shadow-sm">
                    <img src="${pageContext.request.contextPath}/images/accommodation/longhouse.jpg"
                         class="card-img-top" alt="Longhouse" style="height:220px; object-fit:cover;">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-home me-2 text-success"></i>Penan Longhouse Stay</h5>
                        <p class="card-text">Authentic cultural experience staying with the local
                           Penan community. Includes traditional meals, storytelling, and
                           guided forest walks. From RM 120/night per person.</p>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card h-100 shadow-sm">
                    <img src="${pageContext.request.contextPath}/images/accommodation/camp5.jpg"
                         class="card-img-top" alt="Camp 5" style="height:220px; object-fit:cover;">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-campground me-2 text-danger"></i>Camp 5 — Pinnacles Base</h5>
                        <p class="card-text">Rustic jungle camp located at the base of the Mulu
                           Pinnacles trail. Basic dormitory bunks, shared facilities, and
                           stunning forest views. For adventure seekers only. RM 60/night.</p>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card h-100 shadow-sm">
                    <img src="${pageContext.request.contextPath}/images/accommodation/garden-bungalow.jpg"
                         class="card-img-top" alt="Garden Bungalow" style="height:220px; object-fit:cover;">
                    <div class="card-body">
                        <h5 class="card-title"><i class="fas fa-leaf me-2 text-info"></i>Mulu Garden Bungalows</h5>
                        <p class="card-text">Mid-range air-conditioned bungalows surrounded by
                           tropical gardens. Close to the park entrance with breakfast included.
                           Family-friendly rooms available. From RM 180/night.</p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<%@ include file="includes/footer.jsp" %>
```

### 8.6 Developer Page (`developer.jsp`)

```jsp
<%@ include file="includes/header.jsp" %>

<section class="py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 text-center">
                <div class="card shadow p-4">
                    <img src="${pageContext.request.contextPath}/images/developer.jpg"
                         class="rounded-circle mx-auto mb-3"
                         style="width:150px; height:150px; object-fit:cover;"
                         alt="Developer Photo">
                    <h3 class="mb-1">[Your Full Name]</h3>
                    <p class="text-muted mb-3">[Your Student ID]</p>
                    <hr>
                    <table class="table text-start">
                        <tr>
                            <th><i class="fas fa-university me-2"></i>Programme</th>
                            <td>CS/IT — UiTM</td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-envelope me-2"></i>Email</th>
                            <td><a href="mailto:your@email.com">your@email.com</a></td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-phone me-2"></i>Phone</th>
                            <td>+60 1X-XXXXXXXX</td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-calendar me-2"></i>Semester</th>
                            <td>March 2026 – August 2026</td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-code me-2"></i>Subject</th>
                            <td>CSC584 — Web Front-End Development</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="includes/footer.jsp" %>
```

---

## 9. Part 2 — Visitor Inquiry System

### 9.1 Inquiry Form (`inquiry.jsp`)

All 6 fields required. Client-side validation before POST. SweetAlert2 for success message.

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="includes/header.jsp" %>

<section class="py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-7">
                <div class="card shadow p-4">
                    <h3 class="mb-4 text-center">Send Us an Inquiry</h3>

                    <form id="inquiryForm" action="${pageContext.request.contextPath}/InquiryServlet" method="post" novalidate>

                        <div class="mb-3">
                            <label class="form-label">Full Name <span class="text-danger">*</span></label>
                            <input type="text" id="name" name="name" class="form-control" placeholder="Enter your full name">
                            <div class="invalid-feedback">Name is required.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Contact Number <span class="text-danger">*</span></label>
                            <input type="tel" id="contact" name="contact" class="form-control" placeholder="e.g. 0123456789">
                            <div class="invalid-feedback">Contact number is required.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Gender <span class="text-danger">*</span></label>
                            <select id="gender" name="gender" class="form-select">
                                <option value="">-- Select Gender --</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                            <div class="invalid-feedback">Please select your gender.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Email Address <span class="text-danger">*</span></label>
                            <input type="email" id="email" name="email" class="form-control" placeholder="your@email.com">
                            <div class="invalid-feedback">A valid email address is required.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">How did you know about us? <span class="text-danger">*</span></label>
                            <select id="heardFrom" name="heardFrom" class="form-select">
                                <option value="">-- Select an option --</option>
                                <option value="Social Media">Social Media</option>
                                <option value="Google Search">Google Search</option>
                                <option value="Friend">Friend / Family</option>
                                <option value="Travel Blog">Travel Blog</option>
                                <option value="Advertisement">Advertisement</option>
                                <option value="Other">Other</option>
                            </select>
                            <div class="invalid-feedback">Please select an option.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Message <span class="text-danger">*</span></label>
                            <textarea id="message" name="message" class="form-control" rows="4"
                                      placeholder="Your question or message..."></textarea>
                            <div class="invalid-feedback">Message is required.</div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-warning w-100">
                                <i class="fas fa-paper-plane me-2"></i>Submit Inquiry
                            </button>
                            <button type="reset" class="btn btn-outline-secondary w-100" id="clearBtn">
                                <i class="fas fa-times me-2"></i>Clear
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
// Client-side validation
document.getElementById('inquiryForm').addEventListener('submit', function(e) {
    e.preventDefault();
    let valid = true;
    const fields = ['name', 'contact', 'gender', 'email', 'heardFrom', 'message'];

    fields.forEach(function(id) {
        const el = document.getElementById(id);
        if (!el.value.trim()) {
            el.classList.add('is-invalid');
            valid = false;
        } else {
            el.classList.remove('is-invalid');
            el.classList.add('is-valid');
        }
    });

    if (valid) this.submit();
});

// Clear button resets validation styles
document.getElementById('clearBtn').addEventListener('click', function() {
    document.querySelectorAll('.is-invalid, .is-valid').forEach(function(el) {
        el.classList.remove('is-invalid', 'is-valid');
    });
});

// Show SweetAlert2 success if redirected back with ?success=1
<% if ("1".equals(request.getParameter("success"))) { %>
Swal.fire({
    icon: 'success',
    title: 'Inquiry Sent Successfully!',
    text: 'We will get back to you shortly.',
    confirmButtonColor: '#ffc107'
});
<% } %>
</script>

<%@ include file="includes/footer.jsp" %>
```

### 9.2 Inquiry Model (`model/Inquiry.java`)

```java
package com.tourism.model;

import java.sql.Timestamp;

public class Inquiry {
    private int id;
    private String name;
    private String contact;
    private String gender;
    private String email;
    private String heardFrom;
    private String message;
    private Timestamp submittedAt;

    // Constructors
    public Inquiry() {}

    public Inquiry(String name, String contact, String gender,
                   String email, String heardFrom, String message) {
        this.name = name;
        this.contact = contact;
        this.gender = gender;
        this.email = email;
        this.heardFrom = heardFrom;
        this.message = message;
    }

    // Getters and Setters
    public int getId()                   { return id; }
    public void setId(int id)            { this.id = id; }

    public String getName()              { return name; }
    public void setName(String name)     { this.name = name; }

    public String getContact()           { return contact; }
    public void setContact(String c)     { this.contact = c; }

    public String getGender()            { return gender; }
    public void setGender(String g)      { this.gender = g; }

    public String getEmail()             { return email; }
    public void setEmail(String e)       { this.email = e; }

    public String getHeardFrom()         { return heardFrom; }
    public void setHeardFrom(String h)   { this.heardFrom = h; }

    public String getMessage()           { return message; }
    public void setMessage(String m)     { this.message = m; }

    public Timestamp getSubmittedAt()    { return submittedAt; }
    public void setSubmittedAt(Timestamp t) { this.submittedAt = t; }
}
```

### 9.3 Inquiry DAO (`dao/InquiryDAO.java`)

```java
package com.tourism.dao;

import com.tourism.model.Inquiry;
import com.tourism.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InquiryDAO {
    private static final Logger logger = LoggerFactory.getLogger(InquiryDAO.class);

    public boolean save(Inquiry inquiry) {
        String sql = "INSERT INTO inquiries (name, contact, gender, email, heard_from, message) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, inquiry.getName());
            ps.setString(2, inquiry.getContact());
            ps.setString(3, inquiry.getGender());
            ps.setString(4, inquiry.getEmail());
            ps.setString(5, inquiry.getHeardFrom());
            ps.setString(6, inquiry.getMessage());

            int rows = ps.executeUpdate();
            logger.info("Inquiry saved for: {}", inquiry.getName());
            return rows > 0;

        } catch (SQLException e) {
            logger.error("Error saving inquiry: {}", e.getMessage());
            return false;
        }
    }

    public List<Inquiry> findAll() {
        List<Inquiry> list = new ArrayList<>();
        String sql = "SELECT * FROM inquiries ORDER BY submitted_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Inquiry inq = new Inquiry();
                inq.setId(rs.getInt("id"));
                inq.setName(rs.getString("name"));
                inq.setContact(rs.getString("contact"));
                inq.setGender(rs.getString("gender"));
                inq.setEmail(rs.getString("email"));
                inq.setHeardFrom(rs.getString("heard_from"));
                inq.setMessage(rs.getString("message"));
                inq.setSubmittedAt(rs.getTimestamp("submitted_at"));
                list.add(inq);
            }

        } catch (SQLException e) {
            logger.error("Error fetching inquiries: {}", e.getMessage());
        }
        return list;
    }
}
```

### 9.4 Inquiry Servlet (`servlet/InquiryServlet.java`)

```java
package com.tourism.servlet;

import com.tourism.dao.InquiryDAO;
import com.tourism.model.Inquiry;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.validator.routines.EmailValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet("/InquiryServlet")
public class InquiryServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(InquiryServlet.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name      = request.getParameter("name");
        String contact   = request.getParameter("contact");
        String gender    = request.getParameter("gender");
        String email     = request.getParameter("email");
        String heardFrom = request.getParameter("heardFrom");
        String message   = request.getParameter("message");

        // Server-side validation
        if (StringUtils.isAnyBlank(name, contact, gender, email, heardFrom, message)) {
            response.sendRedirect(request.getContextPath() + "/inquiry.jsp?error=empty");
            return;
        }

        if (!EmailValidator.getInstance().isValid(email)) {
            response.sendRedirect(request.getContextPath() + "/inquiry.jsp?error=email");
            return;
        }

        Inquiry inquiry = new Inquiry(name, contact, gender, email, heardFrom, message);
        InquiryDAO dao = new InquiryDAO();

        if (dao.save(inquiry)) {
            response.sendRedirect(request.getContextPath() + "/inquiry.jsp?success=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/inquiry.jsp?error=db");
        }
    }
}
```

---

## 10. Part 3 — Admin Portal

### 10.1 Admin Login Page (`admin/login.jsp`)

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Login — Mulu Caves</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark">

<div class="container d-flex justify-content-center align-items-center min-vh-100">
    <div class="card shadow-lg p-4" style="width: 400px;">
        <h4 class="text-center mb-4">
            <i class="fas fa-lock me-2"></i>Admin Login
        </h4>

        <% if ("1".equals(request.getParameter("error"))) { %>
        <div class="alert alert-danger">Invalid username or password.</div>
        <% } %>

        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" name="username" class="form-control" required autofocus>
            </div>
            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-warning w-100">Login</button>
        </form>
    </div>
</div>

</body>
</html>
```

### 10.2 Admin Dashboard (`admin/dashboard.jsp`)

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.tourism.model.Inquiry" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard — Mulu Caves</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/2.0.3/css/dataTables.bootstrap5.min.css" rel="stylesheet">
</head>
<body>

<nav class="navbar navbar-dark bg-dark px-4">
    <span class="navbar-brand">Mulu Caves — Admin Panel</span>
    <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline-light btn-sm">
        <i class="fas fa-sign-out-alt me-1"></i>Logout
    </a>
</nav>

<div class="container-fluid py-4">
    <h4 class="mb-4">Visitor Inquiries
        <span class="badge bg-warning text-dark ms-2">${inquiries.size()} total</span>
    </h4>

    <div class="card shadow-sm">
        <div class="card-body">
            <table id="inquiriesTable" class="table table-striped table-hover" style="width:100%">
                <thead class="table-dark">
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Contact</th>
                        <th>Gender</th>
                        <th>Email</th>
                        <th>Heard From</th>
                        <th>Message</th>
                        <th>Submitted At</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="inq" items="${inquiries}" varStatus="s">
                    <tr>
                        <td>${s.count}</td>
                        <td>${inq.name}</td>
                        <td>${inq.contact}</td>
                        <td>${inq.gender}</td>
                        <td>${inq.email}</td>
                        <td>${inq.heardFrom}</td>
                        <td>${inq.message}</td>
                        <td>${inq.submittedAt}</td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/2.0.3/js/dataTables.min.js"></script>
<script src="https://cdn.datatables.net/2.0.3/js/dataTables.bootstrap5.min.js"></script>
<script>
$(document).ready(function() {
    $('#inquiriesTable').DataTable({
        order: [[7, 'desc']],
        pageLength: 10,
        language: { search: "Search inquiries:" }
    });
});
</script>
</body>
</html>
```

### 10.3 Login Servlet (`servlet/LoginServlet.java`)

```java
package com.tourism.servlet;

import com.tourism.dao.AdminDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        AdminDAO adminDAO = new AdminDAO();
        boolean valid = adminDAO.authenticate(username, password);

        if (valid) {
            HttpSession session = request.getSession();
            session.setAttribute("adminUser", username);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            response.sendRedirect(request.getContextPath() + "/DashboardServlet");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp?error=1");
        }
    }
}
```

### 10.4 Dashboard Servlet (`servlet/DashboardServlet.java`)

```java
package com.tourism.servlet;

import com.tourism.dao.InquiryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }

        InquiryDAO dao = new InquiryDAO();
        request.setAttribute("inquiries", dao.findAll());
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
```

### 10.5 Logout Servlet (`servlet/LogoutServlet.java`)

```java
package com.tourism.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
    }
}
```

### 10.6 Auth Filter (`filter/AuthFilter.java`)

Protects all `/admin/*` URLs. Without this, anyone can access the dashboard by typing the URL directly.

```java
package com.tourism.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/admin/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request   = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String requestURI = request.getRequestURI();

        // Allow login page to pass through
        if (requestURI.contains("login.jsp")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        }
    }
}
```

### 10.7 Admin DAO (`dao/AdminDAO.java`)

```java
package com.tourism.dao;

import com.tourism.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;

public class AdminDAO {
    private static final Logger logger = LoggerFactory.getLogger(AdminDAO.class);

    public boolean authenticate(String username, String password) {
        String sql = "SELECT password FROM admin_users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");
                return BCrypt.checkpw(password, storedHash);
            }

        } catch (SQLException e) {
            logger.error("Auth error: {}", e.getMessage());
        }
        return false;
    }
}
```

---

## 11. Utility Classes

### 11.1 DB Connection (`util/DBConnection.java`)

```java
package com.tourism.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnection {
    private static final Logger logger = LoggerFactory.getLogger(DBConnection.class);
    private static HikariDataSource dataSource;

    static {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:mysql://localhost:3306/tourism_db?useSSL=false&serverTimezone=Asia/Kuala_Lumpur");
        config.setUsername("root");
        config.setPassword("yourpassword");
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(600000);
        config.setMaxLifetime(1800000);

        try {
            dataSource = new HikariDataSource(config);
            logger.info("HikariCP connection pool initialized.");
        } catch (Exception e) {
            logger.error("Failed to initialize connection pool: {}", e.getMessage());
            throw new RuntimeException(e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}
```

### 11.2 BCrypt Hash Generator (run once to generate admin password)

```java
// Run this once, copy the output, paste into your SQL INSERT
import org.mindrot.jbcrypt.BCrypt;

public class GenerateHash {
    public static void main(String[] args) {
        String rawPassword = "admin123";
        String hash = BCrypt.hashpw(rawPassword, BCrypt.gensalt(12));
        System.out.println("BCrypt hash: " + hash);
        // Paste the output into your admin_users INSERT statement
    }
}
```

---

## 12. `web.xml` Configuration

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
         https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
         version="6.0">

    <display-name>Mulu Caves Tourism App</display-name>

    <!-- Default welcome page -->
    <welcome-file-list>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>

    <!-- Session timeout: 30 minutes -->
    <session-config>
        <session-timeout>30</session-timeout>
    </session-config>

    <!-- Custom 404 error page -->
    <error-page>
        <error-code>404</error-code>
        <location>/index.jsp</location>
    </error-page>

</web-app>
```

---

## 13. UI/UX Recommendations

### Recommended Free Template

**Travelo by HTML Codex** — tourism/travel HTML template, free, Bootstrap-based  
URL: `https://htmlcodex.com/travel-website-template`

**SB Admin 2** — admin dashboard template for the admin portal  
URL: `https://github.com/StartBootstrap/startbootstrap-sb-admin-2`

### Hero Section CSS (`css/style.css`)

```css
.hero-section {
    height: 90vh;
    overflow: hidden;
}

.hero-img {
    height: 100%;
    object-fit: cover;
    filter: brightness(0.55);
}

.hero-overlay {
    background: linear-gradient(to bottom, rgba(0,0,0,0.3), rgba(0,0,0,0.6));
}

.gallery-thumb {
    height: 200px;
    object-fit: cover;
    transition: transform 0.3s ease;
    cursor: pointer;
}

.gallery-thumb:hover {
    transform: scale(1.04);
}

.card {
    transition: box-shadow 0.3s ease;
}

.card:hover {
    box-shadow: 0 8px 24px rgba(0,0,0,0.12) !important;
}

.navbar-brand {
    font-size: 1.4rem;
    letter-spacing: 0.5px;
}

/* Google Maps external link indicator */
a[target="_blank"]::after {
    content: " ↗";
    font-size: 0.8em;
}
```

### Google Maps External Link (required by assignment)

```html
<!-- Must use target="_blank" as specified in assignment -->
<a href="https://maps.google.com/?q=Mulu+Caves+Sarawak+Malaysia" target="_blank" class="btn btn-outline-success">
    <i class="fas fa-map-marker-alt me-1"></i>View on Google Maps
</a>
```

---

## 14. AWS Deployment Guide

### Option A — AWS Elastic Beanstalk (Recommended, easiest)

```bash
# Step 1: Install EB CLI
pip install awsebcli

# Step 2: Configure AWS credentials
aws configure
# Enter: Access Key ID, Secret Access Key, Region: ap-southeast-1 (Singapore)

# Step 3: Build your WAR file
# In IDE: Build → Export → WAR file → mulu-caves.war

# Step 4: Initialise Elastic Beanstalk
cd /path/to/your/project
eb init mulu-caves-tourism \
    --platform "Tomcat 10 with Corretto 21" \
    --region ap-southeast-1

# Step 5: Create environment (single instance = free tier eligible)
eb create mulu-caves-env --single

# Step 6: Deploy
eb deploy

# Step 7: Open in browser
eb open
```

### Option B — AWS EC2 + Manual Tomcat (more control)

```bash
# Step 1: Launch EC2 Ubuntu t2.micro (free tier)
# Step 2: SSH in
ssh -i your-key.pem ubuntu@your-ec2-ip

# Step 3: Install Java and Tomcat
sudo apt update
sudo apt install -y openjdk-21-jdk
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.20/bin/apache-tomcat-10.1.20.tar.gz
sudo tar -xzf apache-tomcat-10.1.20.tar.gz -C /opt/
sudo ln -s /opt/apache-tomcat-10.1.20 /opt/tomcat

# Step 4: Install MySQL
sudo apt install -y mysql-server
sudo mysql -e "CREATE DATABASE tourism_db;"
sudo mysql tourism_db < tourism_db.sql

# Step 5: Deploy WAR
scp -i your-key.pem mulu-caves.war ubuntu@your-ec2-ip:/opt/tomcat/webapps/
sudo /opt/tomcat/bin/startup.sh

# App accessible at: http://your-ec2-ip:8080/mulu-caves
```

### AWS RDS MySQL (for Elastic Beanstalk)

In Elastic Beanstalk Console → Configuration → Database:
- Engine: MySQL 8.0
- Instance class: `db.t3.micro` (free tier)
- Username: `admin`
- Password: your choice

Then update `DBConnection.java`:

```java
// Read from environment variable injected by Elastic Beanstalk
String jdbcUrl = System.getenv("JDBC_CONNECTION_STRING");
config.setJdbcUrl(jdbcUrl);
```

---

## 15. Submission Checklist

### Files to include in ZIP

```
[StudentID]_CSC584_MuluCaves.zip
├── mulu-caves/          ← Full Maven project source code
│   ├── pom.xml
│   ├── src/
│   └── webapp/
└── tourism_db.sql       ← Must be working and complete
```

### Pre-submission checks

- [ ] All 6 public pages exist and are accessible via navbar
- [ ] Navbar is consistent on every page
- [ ] Google Maps link opens in a new tab (`target="_blank"`)
- [ ] Gallery has exactly 8 images
- [ ] Activities has exactly 4 items with images and descriptions
- [ ] Accommodation has exactly 4 items with images and descriptions
- [ ] Developer page has photo, name, student ID, and contact
- [ ] Inquiry form has all 6 required fields
- [ ] Form does not submit if any field is empty (client-side + server-side)
- [ ] Form data saves to MySQL via Servlet + JDBC
- [ ] Success message appears after form submit
- [ ] Clear button empties all fields
- [ ] Admin login works with correct credentials
- [ ] Admin dashboard is inaccessible without login (direct URL redirects)
- [ ] jQuery DataTable shows search, sort, and pagination
- [ ] Logout button works and destroys session
- [ ] SQL file is included in ZIP and is runnable without errors
- [ ] Video demo covers all core functionality

### Video walkthrough script (10 minutes max)

1. Show the ZIP folder structure (0:00–0:30)
2. Import and run `tourism_db.sql` in MySQL Workbench (0:30–1:00)
3. Deploy WAR to Tomcat, open in browser (1:00–1:30)
4. Navigate all public pages — Home, Gallery, Activities, Accommodation, Developer (1:30–3:30)
5. Fill and submit the inquiry form — show success message (3:30–4:30)
6. Try submitting with empty fields — show validation (4:30–5:00)
7. Open admin login — try wrong password, show error (5:00–5:30)
8. Login with correct credentials, show dashboard with DataTable (5:30–7:00)
9. Demonstrate search, sort, pagination in DataTable (7:00–8:00)
10. Try accessing dashboard URL directly without login — show redirect (8:00–8:30)
11. Click logout — confirm session destroyed (8:30–9:00)

---

## 16. Rubric Impact Summary

| Criteria | Weight | Key things that earn Excellent |
|---|---|---|
| UI/UX & Navigation | 15% | Navbar on every page, responsive layout, hero image, consistent design |
| Content & Gallery | 15% | Exactly 8 gallery images, exactly 4 activities, exactly 4 accommodation with descriptions |
| Database Persistence | 20% | All 6 fields saved, `submitted_at` timestamp, HikariCP, no SQL errors |
| Security & Sessions | 20% | BCrypt passwords, AuthFilter on all `/admin/*`, logout, session timeout |
| Admin Dashboard | 20% | DataTable with search + sort + pagination, all inquiry fields displayed |
| Organisation & Video | 10% | Clean ZIP, working SQL file, clear video covering all functionality |

### Packages that directly impact marks

| Package | Mark it affects |
|---|---|
| `jbcrypt` | Security & Sessions → Excellent |
| `HikariCP` | Database Persistence → Excellent |
| `commons-validator` | Database Persistence — correct data validation |
| `JSTL` | UI/UX — clean JSP without raw Java in HTML |
| `Lightbox2` | Content & Gallery — professional image viewer |
| `SweetAlert2` | UI/UX — polished success/error feedback |
| `DataTables + Bootstrap 5` | Admin Dashboard → Excellent |
| `Logback + SLF4J` | Organisation — professional error tracking |

---

*CSC584 — Web Front-End Development | UiTM | Semester March 2026 – August 2026*
*Tourism Spot: Mulu Caves, Sarawak, Malaysia*
