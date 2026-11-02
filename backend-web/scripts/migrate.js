const fs = require('fs');
const path = require('path');
const { Client } = require('pg');
require('dotenv').config({ path: path.join(__dirname, '..', '.env.local') });

async function runMigration() {
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) {
    console.error('❌ Error: DATABASE_URL is not defined in .env.local');
    process.exit(1);
  }

  const sqlFilePath = path.join(__dirname, '..', '..', 'schema_postgres.sql');
  if (!fs.existsSync(sqlFilePath)) {
    console.error('❌ Error: schema_postgres.sql not found at', sqlFilePath);
    process.exit(1);
  }

  console.log('🚀 Reading schema_postgres.sql...');
  const schemaSql = fs.readFileSync(sqlFilePath, 'utf8');

  console.log('⚡ Connecting to Neon PostgreSQL...');
  const client = new Client({
    connectionString,
    ssl: {
      rejectUnauthorized: false,
    },
  });

  try {
    await client.connect();
    console.log('✅ Connected successfully!');
    console.log('📦 Executing schema migrations and seeding initial data...');
    await client.query(schemaSql);
    console.log('🎉 Migration finished successfully!');

    // Verify tables
    const res = await client.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      ORDER BY table_name;
    `);

    console.log('\n📋 Created Tables in Neon:');
    res.rows.forEach(r => console.log(`  - ${r.table_name}`));

    // Verify products seed
    const prodRes = await client.query('SELECT COUNT(*) as count FROM products');
    console.log(`\n🌾 Seeded Products: ${prodRes.rows[0].count} items`);

    const userRes = await client.query('SELECT COUNT(*) as count FROM users');
    console.log(`👤 Seeded Users: ${userRes.rows[0].count} accounts`);

  } catch (err) {
    console.error('❌ Migration failed:', err);
    process.exit(1);
  } finally {
    await client.end();
  }
}

runMigration();
