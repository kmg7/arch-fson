import Joi from 'joi';
import dbClient from '../utils/db/client.js';

const create = async (req, res) => {
  try {
    await createSchema.validateAsync({ query: req.query });
    const result = handleResult(await dbClient.createRoom(req.query.code, req.query.password));
    res.status(result.status).json(result.response);
  } catch (error) {
    if (error.isJoi) {
      res.status(400).json({ msg: error.details[0].message });
    } else {
      res.sendStatus(500);
    }
  }
};

const read = async (req, res) => {
  try {
    await createSchema.validateAsync({ query: req.query });
    const result = handleResult(await dbClient.getRoom(req.query.code, req.query.password));
    res.status(result.status).json(result.response);
  } catch (error) {
    if (error.isJoi) {
      res.status(400).json({ msg: error.details[0].message });
    } else {
      res.sendStatus(500);
    }
  }
};
const readById = async (req, res) => {
  try {
    const result = handleResult(await dbClient.getRoomById(req.params['id']));
    res.status(result.status).json(result.response);
  } catch (error) {
    if (error.isJoi) {
      res.status(400).json({ msg: error.details[0].message });
    } else {
      res.sendStatus(500);
    }
  }
};

const update = async (req, res) => {
  try {
    await updateSchema.validateAsync({ query: req.query, body: req.body });
    const result = handleResult(await dbClient.updateRoom(req.query.code, req.query.password, req.body));
    res.status(result.status).json(result.response);
  } catch (error) {
    if (error.isJoi) {
      res.status(400).json({ msg: error.details[0].message });
    } else {
      res.sendStatus(500);
    }
  }
};

export { create, read, readById, update };

function handleResult(result) {
  if (result.data) {
    return {
      status: 200,
      response: result.data,
    };
  } else {
    if (result.kind === 'notFound') {
      return {
        status: 404,
        response: result,
      };
    } else if (result.kind === 'badRequest') {
      return {
        status: 400,
        response: result,
      };
    } else {
      return {
        status: 500,
        response: result,
      };
    }
  }
}

const querySchema = Joi.object({
  code: Joi.string().alphanum().min(4).max(16).required(),
  password: Joi.string().min(1).max(16).required(),
}).required();

const updateSchema = Joi.object({
  query: querySchema,
  body: Joi.object({
    code: Joi.string().alphanum().min(4).max(16),
    password: Joi.string().min(1).max(16),
    host: Joi.string().min(1).max(24),
  })
    .required()
    .min(1),
}).required();

const createSchema = Joi.object({ query: querySchema });
