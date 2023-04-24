import mssql from 'mssql';
import connect from './connect.js';

await connect(mssql);

class DBClient {
  constructor() {
    console.log('DBClient initialized');
  }

  async createRoom(code, password) {
    try {
      await mssql.query`INSERT INTO room(code, pwd) VALUES(${code},${password})`;
      return await this.getRoom(code, password);
    } catch (error) {
      return handleError(error);
    }
  }

  async getRoom(code, password) {
    try {
      const result = (await mssql.query`SELECT id, code, pwd, host FROM room WHERE code=${code}`).recordset;
      if (result[0]) {
        if (password === result[0].pwd) {
          return {
            data: {
              id: result[0].id,
              code: result[0].code,
              host: result[0].host,
            },
          };
        }
      }
      return dbError('notFound', 'No record found with given credentinals');
    } catch (error) {
      return handleError(error);
    }
  }

  async getRoomById(id) {
    try {
      const result = (await mssql.query`SELECT id, code, host FROM room WHERE id = ${id}`).recordset;
      if (result[0]) {
        return {
          data: {
            id: result[0].id,
            code: result[0].code,
            host: result[0].host,
          },
        };
      }
      return dbError('notFound', 'No record found with given credentinals');
    } catch (error) {
      return handleError(error);
    }
  }

  async updateRoom(code, password, data) {
    try {
      const response = await this.getRoom(code, password);
      if (!response.data) {
        return response;
      }
      let query = 'UPDATE room SET';

      if (data.code) query += ` code = '${data.code}',`;
      if (data.password) query += ` pwd = '${data.password}',`;
      if (data.host) query += ` host = '${data.host}'`;
      query += ` WHERE id = '${response.data.id}'`;

      await mssql.query(query);

      return await this.getRoomById(response.data.id);
    } catch (error) {
      return handleError(error);
    }
  }
}
export default new DBClient();

function handleError(error) {
  if (process.env.NODE_ENV === 'development') console.log(error);
  if (error.name === 'RequestError' && error.code === 'EREQUEST') {
    return dbError('badRequest', "Field 'code' must be unique");
  } else {
    return dbError('internal', 'Something went wrong. Try again later.');
  }
}
function dbError(kind, message) {
  return {
    kind: kind,
    message: message,
  };
}
