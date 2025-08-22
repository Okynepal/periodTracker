const { Pool } = require('pg');

const pool = new Pool({
  host: 'periodtracker-instance.cduga8c80pbs.ap-south-1.rds.amazonaws.com',
  port: 5432,
  database: 'periodtracker',
  user: 'periodtracker',
  password: 'periodtracker',
  ssl: {
    rejectUnauthorized: false
  }
});

async function testConnection() {
  try {
    const client = await pool.connect();
    console.log('✅ Database connection successful!');
    
    const result = await client.query('SELECT NOW()');
    console.log('📅 Current time from DB:', result.rows[0].now);
    
    client.release();
  } catch (err) {
    console.error('❌ Database connection failed:', err.message);
  } finally {
    await pool.end();
  }
}

testConnection();