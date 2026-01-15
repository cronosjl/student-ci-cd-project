import { expressjwt as jwt } from 'express-jwt';
import * as express from 'express';

const getTokenFromHeaders = (req: express.Request): string | null => {
  if (
    (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Token') ||
    (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer')
  ) {
    return req.headers.authorization.split(' ')[1];
  }
  return null;
};

// --- MODIFICATION ICI : "export const" direct ---

export const required = jwt({
  secret: process.env.JWT_SECRET || 'superSecret',
  getToken: getTokenFromHeaders,
  algorithms: ['HS256'],
});

export const optional = jwt({
  secret: process.env.JWT_SECRET || 'superSecret',
  credentialsRequired: false,
  getToken: getTokenFromHeaders,
  algorithms: ['HS256'],
});

// ON SUPPRIME LE "export default auth;"