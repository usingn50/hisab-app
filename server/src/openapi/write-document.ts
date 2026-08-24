import { mkdir, writeFile } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

import { buildOpenApiDocument } from './document.js';

const outputPath = resolve(
  dirname(fileURLToPath(import.meta.url)),
  '../../openapi/hisab-v1.json',
);

await mkdir(dirname(outputPath), { recursive: true });
await writeFile(outputPath, `${JSON.stringify(buildOpenApiDocument(), null, 2)}\n`);
console.log(`OpenAPI document written to ${outputPath}`);
