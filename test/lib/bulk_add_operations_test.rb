require 'test_helper'

class BulkAddOperationsTest < ActiveSupport::TestCase
  test 'execute add operation succesfully' do
    operations = [
      Jsonapi::Operation.new(action: :add, model: :authors, attributes: { name: 'Bob' })
    ]
    allowed_models = {
      authors: Author
    }
    subject = BulkAddOperations.new(allowed_models)
    subject.execute(operations)

    assert_equal false, subject.errors?
    assert_equal 1, Author.count
    assert_equal 'Bob', Author.first.name
  end

  test 'execute add operation with relationship succesfully' do
    operations = [
      Jsonapi::Operation.new(action: :add, lid: 'b', model: :authors, attributes: { name: 'Bob' }),
      Jsonapi::Operation.new(
        action: :add,
        model: :articles,
        attributes: { title: 'ArticleOne' },
        refs: { author: 'b' }
      )
    ]
    allowed_models = {
      authors: Author,
      articles: Article
    }
    subject = BulkAddOperations.new(allowed_models)
    subject.execute(operations)

    puts subject.errors

    assert_equal false, subject.errors?
    assert_equal 1, Author.count
    assert_equal 1, Article.count
  end
end
