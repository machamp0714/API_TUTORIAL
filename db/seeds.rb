# frozen_string_literal: true

Article.create([
                 { title: 'Test Title 1', content: 'Test Content 1', slug: 'Test Slug 1' },
                 { title: 'Test Title 2', content: 'Test Content 2', slug: 'Test Slug 2' },
                 { title: 'Test Title 3', content: 'Test Content 3', slug: 'Test Slug 3' }
               ])

User.create(
  login: 'sample',
  url: 'http://sample.url',
  avatar_url: 'http://sample/avatar',
  name: 'sample_name',
  email: 'sample@gmail.com',
  provider: 'github'
)
