import { PrismaClient } from '@prisma/client';
import { mockDeep, DeepMockProxy } from 'jest-mock-extended';

// On force le type pour éviter les erreurs TS2615
const prismaMock = mockDeep<PrismaClient>() as unknown as DeepMockProxy<PrismaClient>;

export default prismaMock;
