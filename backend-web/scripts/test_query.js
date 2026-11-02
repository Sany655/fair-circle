const { Client } = require('pg');
require('dotenv').config({ path: require('path').join(__dirname, '..', '.env.local') });

async function testFetch() {
  const client = new Client({
    connectionString: process.env.DATABASE_URL,
    ssl: { rejectUnauthorized: false },
  });

  await client.connect();
  const res = await client.query(`
    SELECT p.id, p.title, p.category, p.total_price,
           p.raw_material_cost, p.labor_wage_cost, p.packaging_transport_cost, p.fair_profit_margin,
           u.full_name AS producer_name
    FROM products p
    JOIN users u ON p.producer_id = u.id
  `);

  console.log('✅ Real-time query result from Neon PostgreSQL:');
  console.table(res.rows);
  await client.end();
}

testFetch();
