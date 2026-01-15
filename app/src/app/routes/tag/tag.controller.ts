import { NextFunction, Request, Response, Router } from 'express';
// --- MODIFICATION DE L'IMPORT ---
// On importe "optional" spécifiquement et on le renomme "authOptional" pour plus de clarté
import { optional as authOptional } from '../auth/auth';
import { getTags } from './tag.service';

const router = Router();

/**
 * Get top 10 popular tags
 * @auth optional
 * @route {GET} /api/tags
 * @returns tags list of tag names
 */
// --- UTILISATION DE authOptional ---
router.get('/tags', authOptional, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const tags = await getTags(req.auth?.user?.id);
    res.json({ tags });
  } catch (error) {
    next(error);
  }
});

export default router;