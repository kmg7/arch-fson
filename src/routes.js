import { Router } from 'express';
import { create, read, readById, update } from './controller/room_controller.js';
const router = Router();

router.route('/room').post(create).get(read).put(update);
router.route('/room/:id').get(readById);

export default router;
