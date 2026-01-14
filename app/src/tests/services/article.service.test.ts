import prismaMock from '../prisma-mock';
import {
  deleteComment,
  favoriteArticle,
  unfavoriteArticle,
} from '../../app/routes/article/article.service';

describe('ArticleService', () => {
  describe('deleteComment', () => {
    test('should throw an error', async () => {
      const id = 123;
      const idUser = 456;

      prismaMock.comment.findFirst.mockResolvedValue(null);

      await expect(deleteComment(id, idUser)).rejects.toThrowError();
    });
  });

  describe('favoriteArticle', () => {
    test('should return the favorited article', async () => {
      const slug = 'how-to-train-your-dragon';

      const mockedUserResponse = {
        id: 123,
        username: 'RealWorld',
        email: 'realworld@me',
        password: '1234',
        bio: null,
        image: null,
        token: '',
        demo: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      };

      const mockedArticleResponse = {
        id: 123,
        slug,
        title: 'How to train your dragon',
        description: '',
        body: '',
        createdAt: new Date(),
        updatedAt: new Date(),
        authorId: 456,
        tagList: [],
        favoritedBy: [],
        author: {
          username: 'RealWorld',
          bio: null,
          image: null,
          followedBy: [],
        },
      };

      prismaMock.user.findUnique.mockResolvedValue(mockedUserResponse);
      prismaMock.article.update.mockResolvedValue(mockedArticleResponse);

      await expect(favoriteArticle(slug, mockedUserResponse.id)).resolves.toHaveProperty('favoritesCount');
    });

    test('should throw an error if no user is found', async () => {
      prismaMock.user.findUnique.mockResolvedValue(null);
      await expect(favoriteArticle('slug', 1)).rejects.toThrowError();
    });
  });

  describe('unfavoriteArticle', () => {
    test('should return the unfavorited article', async () => {
      const slug = 'how-to-train-your-dragon';

      const mockedUserResponse = {
        id: 123,
        username: 'RealWorld',
        email: 'realworld@me',
        password: '1234',
        bio: null,
        image: null,
        token: '',
        demo: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      };

      const mockedArticleResponse = {
        id: 123,
        slug,
        title: 'How to train your dragon',
        description: '',
        body: '',
        createdAt: new Date(),
        updatedAt: new Date(),
        authorId: 456,
        tagList: [],
        favoritedBy: [],
        author: {
          username: 'RealWorld',
          bio: null,
          image: null,
          followedBy: [],
        },
      };

      prismaMock.user.findUnique.mockResolvedValue(mockedUserResponse);
      prismaMock.article.update.mockResolvedValue(mockedArticleResponse);

      await expect(unfavoriteArticle(slug, mockedUserResponse.id)).resolves.toHaveProperty('favoritesCount');
    });

    test('should throw an error if no user is found', async () => {
      prismaMock.user.findUnique.mockResolvedValue(null);
      await expect(unfavoriteArticle('slug', 1)).rejects.toThrowError();
    });
  });
});
