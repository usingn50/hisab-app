import { buildApp } from './app.js';
import { loadConfig } from './config.js';

const config = loadConfig();
const app = buildApp(config);

const close = async (signal: string) => {
  app.log.info({ signal }, 'Shutting down API server');
  await app.close();
  process.exit(0);
};

process.once('SIGINT', () => void close('SIGINT'));
process.once('SIGTERM', () => void close('SIGTERM'));

await app.listen({ host: config.HOST, port: config.PORT });
