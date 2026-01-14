import prismaMock from '../prisma-mock';
// Mock utilisateur
const mockedUserResponse = {
  id: 1,
  username: 'JohnDoe',
  email: 'john@example.com',
  password: 'hashedpassword',
  bio: null,
  image: null,
  token: 'token',
  demo: false,
  createdAt: new Date(),
  updatedAt: new Date(),
};

// Mock article
const mockedArticleResponse = {
  id: 1,
  title: 'Test Article',
  content: 'Content of the article',
  authorId: mockedUserResponse.id,
  createdAt: new Date(),
  updatedAt: new Date(),
};

// Utilisation dans tes tests
prismaMock.user.findUnique.mockResolvedValue(mockedUserResponse);
prismaMock.article.update.mockResolvedValue(mockedArticleResponse);
