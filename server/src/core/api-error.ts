export class ApiError extends Error {
  constructor(
    public readonly statusCode: number,
    public readonly code: string,
    message: string,
    public readonly details: Array<{ field: string; reason: string }> = [],
  ) {
    super(message);
    this.name = 'ApiError';
  }
}
