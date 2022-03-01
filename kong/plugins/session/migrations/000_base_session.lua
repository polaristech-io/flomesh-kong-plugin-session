return {
  postgres = {
    up = [[
      CREATE TABLE IF NOT EXISTS sessions(
        id            uuid,
        session_id    text UNIQUE,
        expires       int,
        data          text,
        created_at    timestamp WITH TIME ZONE,
        ttl           timestamp WITH TIME ZONE,
        PRIMARY KEY (id)
      );

      DO $$
      BEGIN
        CREATE INDEX IF NOT EXISTS "session_sessions_expires_idx" ON "sessions" ("expires");
      EXCEPTION WHEN UNDEFINED_COLUMN THEN
        -- Do nothing, accept existing state
      END$$;
    ]],
  },
  mysql = {
    up = [[
      CREATE TABLE IF NOT EXISTS `sessions` (
        `id` VARCHAR(36) NOT NULL,
        `session_id` TEXT NOT NULL,
        `expires` INT NOT NULL,
        `data` TEXT NOT NULL,
        `created_at` DATETIME(3) NOT NULL,
        `ttl` DATETIME(3) NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE INDEX `sessions_session_id_key` (`session_id`(255) ASC)
      );

      DROP INDEX IF EXISTS session_sessions_expires_idx;
      CREATE INDEX `session_sessions_expires_idx` ON `sessions` (`expires`);
    ]],
  },
  cassandra = {
    up = [[
      CREATE TABLE IF NOT EXISTS sessions(
        id            uuid,
        session_id    text,
        expires       int,
        data          text,
        created_at    timestamp,
        PRIMARY KEY (id)
      );

      CREATE INDEX IF NOT EXISTS ON sessions (session_id);
      CREATE INDEX IF NOT EXISTS ON sessions (expires);
    ]],
  },
}
