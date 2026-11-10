PRAGMA foreign_keys = ON;
CREATE TABLE IF NOT EXISTS sources (
 id TEXT PRIMARY KEY, name TEXT NOT NULL, kind TEXT NOT NULL CHECK(kind IN ('github_catalog','authorized_api')),
 project_url TEXT, api_base_url TEXT, authorization_confirmed INTEGER NOT NULL DEFAULT 0,
 public_display_allowed INTEGER NOT NULL DEFAULT 0, enabled INTEGER NOT NULL DEFAULT 0,
 last_sync_at TEXT, last_error TEXT, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS numbers (
 id TEXT PRIMARY KEY, source_id TEXT NOT NULL REFERENCES sources(id), phone TEXT NOT NULL,
 country TEXT NOT NULL, country_code TEXT, status TEXT NOT NULL DEFAULT 'pending' CHECK(status IN ('verified','pending','offline')),
 public_inbox INTEGER NOT NULL DEFAULT 0, last_tested_at TEXT, last_test_result TEXT,
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE(source_id, phone)
);
CREATE TABLE IF NOT EXISTS messages (
 id TEXT PRIMARY KEY, number_id TEXT NOT NULL REFERENCES numbers(id) ON DELETE CASCADE,
 body TEXT NOT NULL, received_at TEXT NOT NULL, public_display_allowed INTEGER NOT NULL DEFAULT 0,
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_numbers_country ON numbers(country,status);
CREATE INDEX IF NOT EXISTS idx_messages_number_time ON messages(number_id,received_at DESC);
