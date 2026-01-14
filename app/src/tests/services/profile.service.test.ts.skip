import prismaMock from '../prisma-mock';
// Mock utilisateur authentifié
const mockedAuthUser = {
  id: 2,
  username: 'JaneDoe',
  email: 'jane@example.com',
  password: 'hashedpassword',
  bio: 'Hello world',
  image: null,
  token: 'token123',
  demo: false,
  followedBy: [],
  createdAt: new Date(),
  updatedAt: new Date(),
};

// Mock réponse après update
const mockedResponse = {
  ...mockedAuthUser,
  bio: 'Updated bio',
  updatedAt: new Date(),
};

// Tests
prismaMock.user.findUnique.mockResolvedValue(mockedAuthUser);
prismaMock.user.update.mockResolvedValue(mockedResponse);
