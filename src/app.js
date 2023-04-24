import path from 'path';
import { fileURLToPath } from 'url';
import express from 'express';
import { HOST, NODE_ENV, PORT } from './config.js';
import cors from 'cors';
import './utils/db/client.js';
import routes from './routes.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

console.log(`\n\nMODE:${NODE_ENV}`);

const app = express();
const mainPath = path.join(__dirname, 'public', 'index.html');
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));
// app.use(express.json());

app.use(cors(), routes);

app.get('/', (req, res) => {
  res.setEncoding('utf-8');
  res.status(200).sendFile(mainPath);
});

const start = () => {
  app.listen(PORT, HOST, () => console.log(`\nServer initialized on ${HOST} port ${PORT}`));
};

start();
