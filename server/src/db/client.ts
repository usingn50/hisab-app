import postgres from 'postgres';

import type { AppConfig } from '../config.js';

export function createDatabaseClient(config: AppConfig) {
  return postgres(config.DATABASE_URL, {
    max: config.NODE_ENV === 'test' ? 2 : 10,
    idle_timeout: 20,
    connect_timeout: 10,
    prepare: false,
  });
}

export type DatabaseClient = ReturnType<typeof createDatabaseClient>;
