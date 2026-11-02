import { Pool } from 'pg';

const connectionString = process.env.DATABASE_URL;

// PostgreSQL connection pool with SSL configured for Neon serverless
const pool = new Pool({
  connectionString,
  ssl: {
    rejectUnauthorized: false, // Neon requires SSL
  },
  max: 10,
  idleTimeoutMillis: 30000,
});

export async function query<T = any>(text: string, params: any[] = []): Promise<T[]> {
  const client = await pool.connect();
  try {
    const result = await client.query(text, params);
    return result.rows as T[];
  } finally {
    client.release();
  }
}

export default pool;
