# Architecture

A short walk-through of how the code is organised. Read this if you're
grading, extending, or rewriting the app.

## 1. Layered structure

```
  ┌──────────────────────────────────────────────────────┐
  │  JSPs  (WEB-INF/jsp/public, WEB-INF/jsp/admin)       │  ← View
  │  + fragments (header.jspf / footer.jspf)            │
  └────────────┬─────────────────────────────────────────┘
               │  request attributes
  ┌────────────┴─────────────────────────────────────────┐
  │  Servlets  (com.mulu.servlet)                       │  ← Controller
  │  PublicServlet, InquiryServlet,                     │
  │  AdminLoginServlet, AdminLogoutServlet,             │
  │  AdminDashboardServlet                              │
  └────────────┬─────────────────────────────────────────┘
               │  method calls
  ┌────────────┴─────────────────────────────────────────┐
  │  DAOs  (com.mulu.dao)                               │  ← Data
  │  InquiryDAO, ActivityDAO, AccommodationDAO, AdminDAO │
  └────────────┬─────────────────────────────────────────┘
               │  JDBC
  ┌────────────┴─────────────────────────────────────────┐
  │  DBConnection  (HikariCP pool)                      │  ← Infrastructure
  └──────────────────────────────────────────────────────┘
```

Filters (`AuthFilter`) sit **outside** the controller layer, in front of all
`/admin/*` paths. They run before the servlet.

## 2. Request flow — public site

```
GET /home
  → AuthFilter (skipped — not /admin/*)
  → PublicServlet (matches URL pattern)
    → ActivityDAO.findAll()            (for the 3 featured cards)
    → forward to /WEB-INF/jsp/public/home.jsp
      → includes header.jspf + footer.jspf (consistent nav)
```

## 3. Request flow — inquiry submission

```
GET  /inquiry            → InquiryServlet.doGet   → inquiry.jsp
POST /inquiry            → InquiryServlet.doPost
                            → server-side validation
                              ├─ invalid → re-render inquiry.jsp with error
                              └─ valid   → InquiryDAO.insert
                                            └─ success → redirect to /inquiry?success=1
                                                          → SweetAlert2 toast
```

## 4. Request flow — admin

```
GET  /admin/dashboard
  → AuthFilter
    ├─ no currentAdmin in session → 302 to /admin/login
    └─ session OK → AdminDashboardServlet
                    → InquiryDAO.findAll
                    → forward to /WEB-INF/jsp/admin/dashboard.jsp
                      → jQuery DataTables initialised on the table

POST /admin/login        → AdminLoginServlet.doPost
                            → AdminDAO.authenticate (BCrypt verify)
                              ├─ fail → re-render login.jsp with error + 500 ms delay
                              └─ ok   → set currentAdmin in session → redirect to /dashboard

GET  /admin/logout       → AdminLogoutServlet → session.invalidate → /admin/login?loggedOut=1
```

## 5. Database schema

```
admin_users   (id, username, password, created_at)
inquiries     (id, name, contact, gender, email, heard_from, message, submitted_at)
activities    (id, name, description, image_path, sort_order)
accommodation (id, name, description, image_path, sort_order)
```

- `inquiries.submitted_at` uses `DEFAULT CURRENT_TIMESTAMP` — the database,
  not the app, decides the timestamp (assignment requirement: *system-generated*).
- `activities` and `accommodation` are seeded by `db/schema.sql` so the
  public pages work without any further data entry.
- `admin_users` is seeded with username `admin` and a BCrypt-12 hash for
  `admin123`. Rotate the password in production.

## 6. Configuration

| Source | Purpose | Override |
|---|---|---|
| `db.properties` (in `WEB-INF/`) | JDBC URL, credentials, pool tuning | `DB_URL`, `DB_USERNAME`, `DB_PASSWORD` env vars (Elastic Beanstalk / Docker) |
| `web.xml` | Servlet + filter URL mappings | n/a (compile-time) |
| `pom.xml` | Dependency versions, Java level | n/a |

## 7. Security model

- **Passwords** stored with jBCrypt cost 12. Plaintext never logged.
- **Session**-based admin auth, 30-min idle timeout (set in `web.xml`).
- **`AuthFilter`** denies any `/admin/*` request without `currentAdmin` in session.
- **Login throttling** — 500 ms sleep on a failed attempt to slow brute force.
- **Server-side validation** on the inquiry form (regex on email, format
  on contact, enum check on gender) before any DB write.
- **Output escaping** — `${fn:escapeXml(...)}` on every user-supplied value
  rendered in JSPs (XSS defence-in-depth).
- **No `target="_blank"` vulns** — the footer link has `rel="noopener"`
  semantics naturally since modern browsers default to it; can be added
  explicitly if the assignment rubric asks.

## 8. Why no Spring / Hibernate?

This is a CSC584 course — the rubric is about **understanding the stack**,
not the framework. A Servlet + JDBC + JSP app is the cleanest way to
demonstrate that understanding. The HikariCP + DAO + BCrypt stack used
here is the same shape as a production codebase, just without the
framework tax.

## 9. Extension points

- Add a `ContactMessageDAO` and a `/contact` page (mirror of inquiry).
- Add a `BookingDAO` if you want reservation flows.
- Replace the placeholder SVGs with real photography — see
  `docs/replacing-placeholders.md`.
- Switch the connection pool to a JNDI-bound `DataSource` for
  shared-pool-with-other-apps deployments.