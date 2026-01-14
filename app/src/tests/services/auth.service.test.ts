// Mock utilisateur existant
const mockedExistingUser = {
  id: 3,
  username: 'AuthUser',
  email: 'auth@example.com',
  password: 'hashedpassword',
  bio: null,
  image: null,
  token: 'token-auth',
  demo: false,
  createdAt: new Date(),
  updatedAt: new Date(),
};

// Mock réponse après update
const mockedResponse = {
  ...mockedExistingUser,
  bio: 'Updated bio',
  updatedAt: new Date(),
};

// Utilisation dans les tests
prismaMock.user.findUnique.mockResolvedValue(mockedExistingUser);
prismaMock.user.update.mockResolvedValue(mockedResponse);
