import { MSSQL_CONFIG } from '../../config.js';

export default async (sql) => {
  try {
    await sql.connect(MSSQL_CONFIG);
    console.log('Connected to MSSQL');
  } catch (err) {
    console.log(err);
  }
};
