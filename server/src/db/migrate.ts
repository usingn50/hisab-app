import { readdir, readFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

import { loadConfig } from '../config.js';
import { createDatabaseClient, type DatabaseClient } from './client.js';

const migrationsDirectory = join(
  dirname(fileURLToPath(import.meta.url)),
  'migrations',
);

export async function runMigrations(database: DatabaseClient): Promise<string[]> {
  await database.unsafe(`
    CREATE TABLE IF NOT EXISTS schema_migrations (
      version TEXT PRIMARY KEY,
      applied_at TIMESTAMPTZ NOT NULL DEFAULT now()
    )
  `);

  const appliedRows = await database<{ version: string }[]>`
    SELECT version FROM schema_migrations
  `;
  const applied = new Set(appliedRows.map((row) => row.version));
  const files = (await readdir(migrationsDirectory))
    .filter((file) => file.endsWith('.sql'))
    .sort();
  const executed: string[] = [];

  for (const file of files) {
    if (applied.has(file)) continue;

    const source = await readFile(join(migrationsDirectory, file), 'utf8');
    await database.begin(async (transaction) => {
      await transaction.unsafe(source);
      await transaction`
        INSERT INTO schema_migrations (version) VALUES (${file})
      `;
    });
    executed.push(file);
  }

  return executed;
}

async function main(): Promise<void> {
  const config = loadConfig();
  const database = createDatabaseClient(config);

  try {
    const executed = await runMigrations(database);
    console.log(
      executed.length === 0
        ? 'Database schema is already current.'
        : `Applied migrations: ${executed.join(', ')}`,
    );
  } finally {
    await database.end({ timeout: 5 });
  }
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  await main();
}
