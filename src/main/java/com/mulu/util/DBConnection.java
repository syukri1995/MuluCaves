package com.mulu.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

/**
 * HikariCP-backed connection pool. Reads credentials from
 * WEB-INF/db.properties (git-ignored).
 *
 * Lookup order:
 *   1. /WEB-INF/db.properties (typical container deployment)
 *   2. /db.properties on classpath (Maven `src/main/resources`)
 *   3. Hard defaults (will fail if MySQL isn't on localhost:3306)
 */
public final class DBConnection {

    private static final Logger log = LoggerFactory.getLogger(DBConnection.class);
    private static HikariDataSource dataSource;

    static {
        Properties props = new Properties();

        // 1) Try the WEB-INF path (production)
        try (InputStream is = DBConnection.class.getResourceAsStream("/db.properties")) {
            if (is != null) {
                props.load(is);
                log.info("Loaded db.properties from classpath");
            }
        } catch (IOException ex) {
            log.warn("Failed reading classpath db.properties: {}", ex.getMessage());
        }

        // 2) Allow environment variable overrides (Elastic Beanstalk / Docker)
        String envUrl      = System.getenv("DB_URL");
        String envUser     = System.getenv("DB_USERNAME");
        String envPassword = System.getenv("DB_PASSWORD");

        String jdbcUrl    = envUrl    != null ? envUrl    : props.getProperty("jdbc.url",    "jdbc:mysql://localhost:3306/tourism_db?useSSL=false&serverTimezone=Asia/Kuala_Lumpur&allowPublicKeyRetrieval=true");
        String username   = envUser   != null ? envUser   : props.getProperty("db.username", "root");
        String password   = envPassword != null ? envPassword : props.getProperty("db.password", "");

        int maxPool  = Integer.parseInt(props.getProperty("db.pool.maximum", "10"));
        int minPool  = Integer.parseInt(props.getProperty("db.pool.minimum", "2"));
        int timeout  = Integer.parseInt(props.getProperty("db.pool.timeout", "30000"));

        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(jdbcUrl);
        config.setUsername(username);
        config.setPassword(password);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
        config.setMaximumPoolSize(maxPool);
        config.setMinimumIdle(minPool);
        config.setConnectionTimeout(timeout);
        config.setIdleTimeout(600_000);
        config.setMaxLifetime(1_800_000);
        config.setPoolName("mulu-pool");

        try {
            dataSource = new HikariDataSource(config);
            log.info("HikariCP pool initialized (jdbc={})", jdbcUrl);
        } catch (Exception ex) {
            log.error("Failed to initialize HikariCP: {}", ex.getMessage());
            throw new RuntimeException("DB pool init failed", ex);
        }
    }

    private DBConnection() {}

    /** Borrow a connection from the pool. Caller MUST close it. */
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    /** Close the pool at shutdown (useful for tests and graceful reloads). */
    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}