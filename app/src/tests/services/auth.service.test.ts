import prismaMock from '../prisma-mock';
import { registerUser, loginUser } from '../../app/routes/auth/auth.service';

describe('AuthService', () => {
  test('registerUser should return created user', async () => {
    const mockedExistingUser = {
      id: 1,
      username: 'TestUser',
      email: 'test@me',
      password: '1234',
      bio: null,
      image: null,
      token: '',
      demo: false,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    prismaMock.user.findUnique.mockResolvedValue(null);
    prismaMock.user.create.mockResolvedValue(mockedExistingUser);

    await expect(registerUser('TestUser', 'test@me', '1234')).resolves.toHaveProperty('username', 'TestUser');
  });

  test('loginUser should return existing user', async () => {
    const mockedExistingUser = {
      id: 1,
      username: 'TestUser',
      email: 'test@me',
      password: '1234',
      bio: null,
      image: null,
      token: '',
      demo: false,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    prismaMock.user.findUnique.mockResolvedValue(mockedExistingUser);

    await expect(loginUser('test@me', '1234')).resolves.toHaveProperty('email', 'test@me');
  });
});
