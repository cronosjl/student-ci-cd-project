import { PrismaClient } from '@prisma/client';
import { mockDeep } from 'jest-mock-extended';

// Remarque : on ne fait pas 'as unknown as DeepMockProxy<PrismaClient>'
// car ça cause les problèmes de type circulaire avec Prisma 4+
const prismaMock = mockDeep<PrismaClient>();

export default prismaMock;