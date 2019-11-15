# frozen_string_literal: true

user = User.create(
  login: 'sample',
  url: 'http://sample.url',
  avatar_url: 'http://sample/avatar',
  name: 'sample_name',
  email: 'sample@gmail.com',
  provider: 'github'
)

other_user = User.create(
  login: 'sample2',
  url: 'http://sample2.url',
  avatar_url: 'http://sample2/avatar',
  name: 'sample2_name',
  email: 'sample2@gmail.com',
  provider: 'github'
)

Article.create([
                 { title: 'Test Title 1', content: 'Test Content 1', slug: 'Test Slug 1', user: user },
                 { title: 'Test Title 2', content: 'Test Content 2', slug: 'Test Slug 2', user: user },
                 { title: 'Test Title 3', content: 'Test Content 3', slug: 'Test Slug 3', user: other_user }
               ])
