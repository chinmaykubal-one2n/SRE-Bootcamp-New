// server.js

import express from 'express';
import bodyParser from 'body-parser';
import morgan from 'morgan';
import pkg from 'pg';
import dotenv from 'dotenv';
import promClient from 'prom-client';

const app = express();
const port = 3000;
const { Client } = pkg;
dotenv.config();

// PostgreSQL connection
const client = new Client({
  connectionString: process.env.DATABASE_URL,
});

client.connect()
  .then(() => console.log('Connected to the database'))
  .catch(err => console.error('Connection error', err.stack));

// Prometheus metrics setup
promClient.collectDefaultMetrics();

const httpRequestDurationMicroseconds = new promClient.Histogram({
  name: 'http_request_duration_ms',
  help: 'Duration of HTTP requests in ms',
  labelNames: ['method', 'route', 'status'],
  buckets: [50, 100, 200, 300, 400, 500],
});

// Middleware
app.use(bodyParser.json());
app.use(morgan('combined', {
  stream: {
    write: (message) => console.log(JSON.stringify({ message }))
  }
}));

// Track request duration
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    httpRequestDurationMicroseconds.labels(req.method, req.route ? req.route.path : req.path, res.statusCode).observe(duration);
  });
  next();
});

// Healthcheck endpoint
app.get('/api/v1/healthcheck', (req, res) => {
  res.status(200).json({ status: 'OK' });
});

// CRUD operations
app.post('/api/v1/students', async (req, res) => {
  const { name, age } = req.body;
  try {
    const result = await client.query(
      'INSERT INTO students (name, age) VALUES ($1, $2) RETURNING *',
      [name, age]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error inserting data', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.get('/api/v1/students', async (req, res) => {
  try {
    const result = await client.query('SELECT * FROM students');
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching data', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.get('/api/v1/students/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await client.query('SELECT * FROM students WHERE id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Student not found' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error fetching data', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.put('/api/v1/students/:id', async (req, res) => {
  const { id } = req.params;
  const { name, age } = req.body;
  try {
    const result = await client.query(
      'UPDATE students SET name = $1, age = $2 WHERE id = $3 RETURNING *',
      [name, age, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Student not found' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error updating data', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.delete('/api/v1/students/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await client.query('DELETE FROM students WHERE id = $1 RETURNING *', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Student not found' });
    }
    res.status(204).end();
  } catch (error) {
    console.error('Error deleting data', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Expose metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', promClient.register.contentType);
  res.end(await promClient.register.metrics());
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
