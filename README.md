# Mulu Caves Tourism Web App

CSC584 (Web Front-End Development) coursework — Semester March 2026 – August 2026.

A public tourism site for **Gunung Mulu National Park**, Sarawak, plus a private
admin console for managing visitor inquiries. Built as a Maven WAR using
Java 21, Jakarta EE 10 (Tomcat 10), and MySQL 8.

> **Note for evaluators:** all photographs in `src/main/webapp/images/` are honest
> placeholder SVGs (coloured panels with labels). Replace with real photography
> by dropping files into the same paths — JSPs never change. See
> `docs/replacing-placeholders.md`.

---

## 1. What's inside

```
MuluCaves/
├── pom.xml                                   Maven build (Java 21, WAR)
├── docker-compose.yml                        Local MySQL + Tomcat
├── db/schema.sql                             Database + seed data
├── src/main/java/com/mulu/
│   ├── model/                                Inquiry, Activity, Accommodation, Admin
│   ├── dao/                                  DBConnection, InquiryDAO, ActivityDAO, AccommodationDAO, AdminDAO
│   ├── util/                                 PasswordUtil (BCrypt cost 12)
│   ├── filter/AuthFilter.java                Guards /admin/* (except /admin/login)
│   └── servlet/                              PublicServlet, InquiryServlet, AdminLoginServlet, AdminLogoutServlet, AdminDashboardServlet
├── src/main/webapp/
│   ├── index.jsp                             Redirects to /home
│   ├── assets/css/site.css                   Site styles
│   ├── images/                               Placeholder SVGs (hero, gallery ×8, activities ×4, accommodation ×4, developer)
│   └── WEB-INF/
│       ├── web.xml                           Servlet + filter wiring
│       ├── db.properties.template            Copy → db.properties before run
│       ├── fragments/header.jspf, footer.jspf  Shared layout
│       └── jsp/public/                       home, explore, activities, accommodation, inquiry, developer
│       └── jsp/admin/                        login, dashboard
├── scripts/                                  run-local.{ps1,sh}, stop-local.{ps1,sh}, aws-deploy.sh, generate-placeholders.ps1
├── docs/                                     deployment.md, architecture.md, replacing-placeholders.md
└── mulu-marketing/                           ✨ INDEPENDENT React/Vite marketing site (see §10)
```

> **`mulu-marketing/` is a separate project.** Different stack, different
> dependency tree, different build. It lives next to the JSP app for
> convenience but **Maven does not touch it** and the Docker / AWS deploy
> scripts **never copy from it**. To work on it: `cd mulu-marketing && npm run dev`.

## 2. Quick start (Docker, recommended)

Prereqs: **Docker** (with Compose v2) and **JDK 21 + Maven**.

```powershell
# Windows / PowerShell
.\scripts\run-local.ps1
```

```bash
# macOS / Linux
./scripts/run-local.sh
```

The script:

1. Materialises `db.properties` from the template
2. Builds the WAR (`mvn package`)
3. Starts MySQL 8 + Tomcat 10.1 in containers
4. Waits for the app to respond

Then open:

| URL | Purpose |
|---|---|
| http://localhost:8080/mulu-caves/home | Public site |
| http://localhost:8080/mulu-caves/explore | Gallery (8 images) |
| http://localhost:8080/mulu-caves/activities | 4 activities |
| http://localhost:8080/mulu-caves/accommodation | 4 stays |
| http://localhost:8080/mulu-caves/inquiry | Form (6 fields) |
| http://localhost:8080/mulu-caves/developer | Developer card |
| http://localhost:8080/mulu-caves/admin/login | Admin sign-in (`admin` / `admin123`) |

To stop:

```powershell
.\scripts\stop-local.ps1            # keep DB volume
.\scripts\stop-local.ps1 -v         # also delete the DB volume
```

## 3. Manual run (no Docker)

Prereqs: JDK 25, Maven, MySQL 8, Tomcat 10.

```bash
# 1. Database
mysql -u root -p < db/schema.sql

# 2. Credentials
cp src/main/webapp/WEB-INF/db.properties.template \
   src/main/webapp/WEB-INF/db.properties
# edit db.properties → set db.password

# 3. Build
mvn -DskipTests clean package

# 4. Deploy
cp target/mulu-caves.war $CATALINA_HOME/webapps/
$CATALINA_HOME/bin/startup.sh
```

## 4. AWS deployment

See **`docs/deployment.md`** for the full guide, or run the helper:

```bash
./scripts/aws-deploy.sh
```

The script uses the **AWS CLI** to provision a `t3.micro` EC2 instance, install
Corretto 25 + Tomcat 10 + MariaDB, deploy the WAR, and print the public URL.
It will prompt you for AWS credentials (or honour `aws configure`).

> After you're done, **terminate the instance** — see the cleanup commands the
> script prints at the end.

## 5. Assignment requirements — coverage

| Requirement | Where it lives | Notes |
|---|---|---|
| Navbar consistent on every page | `WEB-INF/fragments/header.jspf` | `<%@ include %>` from every public JSP |
| 6 public pages | `WEB-INF/jsp/public/*.jsp` | Home, Explore, Activities, Stay, Inquire, Developer |
| 8 gallery images | `explore.jsp` + `images/gallery/gallery-1..8.svg` | Lightbox2 |
| 4 activities | `activities.jsp` + `db/schema.sql` seed | Sourced from DB |
| 4 accommodation | `accommodation.jsp` + `db/schema.sql` seed | Sourced from DB |
| 6 inquiry fields | `inquiry.jsp` + `InquiryServlet` validation | Name, contact, gender, email, heard_from, message |
| System-generated timestamp | `inquiries.submitted_at DEFAULT CURRENT_TIMESTAMP` | |
| JDBC + DAO persistence | `dao/*.java` | HikariCP pool |
| BCrypt admin auth | `util/PasswordUtil`, `dao/AdminDAO` | Cost factor 12 |
| Session + AuthFilter | `filter/AuthFilter`, `web.xml` | `/admin/*` except `/admin/login` |
| DataTables (search/sort/page) | `WEB-INF/jsp/admin/dashboard.jsp` | jQuery DataTables 1.13.8 |
| Google Maps link `target="_blank"` | `fragments/footer.jspf` | Required by assignment |
| HikariCP | `util/DBConnection` | |
| BCrypt | `util/PasswordUtil` | |
| Logback + SLF4J | `util/DBConnection`, all DAOs/filter | |

## 6. Default admin credentials

```
username: admin
password: admin123
```

The hash in `db/schema.sql` is a BCrypt-12 hash for `admin123`. If login fails
on first deploy, regenerate it:

```sql
-- Run inside the running Tomcat container (or locally)
UPDATE admin_users
SET password = '<bcrypt-hash>'
WHERE username = 'admin';
```

Generate the hash with the bundled utility (one-liner, or use any BCrypt
online tool with cost 12).

## 7. Replacing the placeholder images

See `docs/replacing-placeholders.md`. TL;DR — drop replacement JPEGs/PNGs into
`src/main/webapp/images/...` with the **same filenames** (e.g. `gallery-1.svg`
→ `gallery-1.jpg`). Then update the relevant JSPs to reference the new
extension, or change `generate-placeholders.ps1` to use `.jpg` by default.

## 8. Tech stack

- **Java** 21
- **Jakarta EE 10** (Servlets 6.0, JSP 3.1, JSTL 3.0)
- **Tomcat 10.1** (Servlet container)
- **MySQL 8** (or MariaDB 10.5+)
- **HikariCP 5.1** (connection pool)
- **jBCrypt 0.4** (password hashing)
- **Logback 1.5** + **SLF4J 2** (logging)
- **Bootstrap 5.3** + **Font Awesome 6** + **jQuery 3.7** (frontend)
- **Lightbox2 2.11** (gallery)
- **SweetAlert2 11** (form feedback)
- **DataTables 1.13** (admin table)

## 9. License & ownership

Coursework, © 2026 UiTM CSC584 student. Not for production use as-is.

---

## 10. `mulu-marketing/` — independent marketing one-pager

A separate React + Vite + Tailwind site that lives **next to** the JSP app
but is **completely independent**. Different stack, different build, different
deployment — it does **not** affect the coursework.

| | JSP coursework | mulu-marketing/ |
|---|---|---|
| Stack | Java 21 / Jakarta EE 10 / MySQL | React 18 / TS / Tailwind / Vite |
| Build | `mvn package` → `target/mulu-caves.war` | `npm run build` → `mulu-marketing/dist/` |
| Deploy | Docker / AWS via `scripts/*.sh` | Static hosting (Netlify, Vercel, S3, GitHub Pages) |
| Bundle | `src/main/webapp/` | `src/` (own React app) |

**Isolation guarantees:**

- `mulu-marketing/` is **outside** Maven's `warSourceDirectory` (`src/main/webapp/`). `mvn package` cannot see it.
- `scripts/run-local.{ps1,sh}`, `scripts/stop-local.{ps1,sh}`, `scripts/aws-deploy.sh` only touch `target/mulu-caves.war` and `db/schema.sql`. They never `cp` / `scp` anything from `mulu-marketing/`.
- `docker-compose.yml` mounts only the WAR. The marketing site is not in the Tomcat container.
- Parent `.gitignore` excludes `mulu-marketing/node_modules/`, `dist/`, and `.vite/` so nothing leaks.

To work on the marketing site:

```bash
cd mulu-marketing
npm install
npm run dev          # → http://127.0.0.1:5173
npm run build        # → dist/  (deploy this anywhere)
```

To deploy it independently, upload `mulu-marketing/dist/` to any static host.
See `mulu-marketing/README.md` for the design rationale and customization guide.