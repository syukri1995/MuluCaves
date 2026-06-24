package com.mulu.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Thin wrapper around jBCrypt so the rest of the codebase
 * never imports the library directly.
 *
 * Strength = 12. Higher numbers = slower hashing = stronger against brute force.
 * 12 is the project default; do not drop below 10.
 */
public final class PasswordUtil {

    /** BCrypt cost factor. Increase to slow brute force, decrease if hardware is constrained. */
    public static final int COST = 12;

    private PasswordUtil() {}

    /** Hash a plaintext password. */
    public static String hash(String plaintext) {
        if (plaintext == null || plaintext.isBlank()) {
            throw new IllegalArgumentException("Password must not be blank");
        }
        return BCrypt.hashpw(plaintext, BCrypt.gensalt(COST));
    }

    /** Verify a plaintext password against a stored BCrypt hash. */
    public static boolean verify(String plaintext, String hashed) {
        if (plaintext == null || hashed == null || hashed.isBlank()) {
            return false;
        }
        try {
            return BCrypt.checkpw(plaintext, hashed);
        } catch (IllegalArgumentException ex) {
            // Malformed hash (not a valid BCrypt string)
            return false;
        }
    }
}