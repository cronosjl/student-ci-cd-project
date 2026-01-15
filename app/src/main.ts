import express from 'express';
import cors from 'cors';
import * as bodyParser from 'body-parser';
import routes from './app/routes/routes';
import HttpException from './app/models/http-exception.model';

const app = express();

/**
 * App Configuration
 */
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Sécurité pour l'import des routes (Fix Build Prod)
app.use((routes as any).default ? (routes as any).default : routes);

// Serves images
app.use(express.static(__dirname + '/assets'));

app.get('/', (req: express.Request, res: express.Response) => {
  res.json({ status: 'API is running on /api' });
});

/* eslint-disable */
app.use(
  (
    err: Error | HttpException,
    req: express.Request,
    res: express.Response,
    next: express.NextFunction,
  ) => {
    if (err && err.name === 'UnauthorizedError') {
      return res.status(401).json({
        status: 'error',
        message: 'missing authorization credentials',
      });
    } else if (err && (err as HttpException).errorCode) {
      res.status((err as HttpException).errorCode).json(err.message);
    } else if (err) {
      res.status(500).json(err.message);
    }
  },
);

/**
 * Server activation
 */
const PORT = process.env.PORT || 3000;

// FIX : Utilisation de '0.0.0.0' pour l'accessibilité Docker
app.listen(Number(PORT), '0.0.0.0', () => {
  console.info(`server up on port ${PORT}`);
});