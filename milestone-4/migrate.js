// migrate.js
import pkg from 'pg';
import dotenv from 'dotenv';

const { Client } = pkg;

dotenv.config();

const client = new Client({
  connectionString: process.env.DATABASE_URL,
});

const createTable = async () => {
  try {
    await client.connect();
    await client.query(`
      CREATE TABLE IF NOT EXISTS students (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100),
        age INT
      );
    `);
    console.log('Table created successfully');
  } catch (error) {
    console.error('Error creating table:', error);
  } finally {
    await client.end();
  }
};

createTable();


