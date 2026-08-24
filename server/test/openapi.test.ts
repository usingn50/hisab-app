import { describe, expect, it } from 'vitest';

import { buildOpenApiDocument } from '../src/openapi/document.js';

describe('Hisab OpenAPI document', () => {
  it('documents the essential production foundation routes', () => {
    const document = buildOpenApiDocument();

    expect(document.openapi).toBe('3.1.0');
    expect(document.paths['/health']?.get?.security).toEqual([]);
    expect(document.paths['/auth/otp/verify']?.post).toBeDefined();
    expect(document.paths['/organizations/{organizationId}/invoices/issue']?.post)
        .toBeDefined();
    expect(document.paths['/organizations/{organizationId}/sync/mutations']?.post)
        .toBeDefined();
    expect(document.paths['/organizations/{organizationId}/sync/changes']?.get)
        .toBeDefined();
  });

  it('declares bearer authentication for protected organization routes', () => {
    const document = buildOpenApiDocument();
    const route = document.paths['/organizations/{organizationId}/products']?.post;

    expect(route?.security).toEqual([{ bearerAuth: [] }]);
    expect(document.components?.securitySchemes?.bearerAuth).toMatchObject({
      type: 'http',
      scheme: 'bearer',
    });
  });
});
