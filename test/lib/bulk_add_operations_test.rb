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

    assert_equal false, subject.errors?
    assert_equal 1, Author.count
    assert_equal 1, Article.count
  end

  test 'execute add operation with relationship in reveresed order succesfully' do
    operations = [
      Jsonapi::Operation.new(
        action: :add,
        model: :articles,
        attributes: { title: 'ArticleOne' },
        refs: { author: 'b' }
      ),
      Jsonapi::Operation.new(action: :add, lid: 'b', model: :authors, attributes: { name: 'Bob' })
    ]
    allowed_models = {
      authors: Author,
      articles: Article
    }
    subject = BulkAddOperations.new(allowed_models)
    subject.execute(operations)

    assert_equal false, subject.errors?
    assert_equal 1, Author.count
    assert_equal 1, Article.count
  end

  test 'execute add operation on not allowed models fails' do
    operations = [
      Jsonapi::Operation.new(
        action: :add,
        model: :articles,
        attributes: { title: 'ArticleOne' },
      )
    ]
    allowed_models = {}
    subject = BulkAddOperations.new(allowed_models)
    subject.execute(operations)

    assert_equal true, subject.errors?
    assert_equal ["operation 'add' on model 'articles' not allowed"], subject.errors
  end

  test 'execute add operation with relationship that dosn\'t exist fails' do
    operations = [
      Jsonapi::Operation.new(
        action: :add,
        model: :articles,
        attributes: { title: 'ArticleOne' },
        refs: { author: 'b' }
      )
    ]
    allowed_models = {
      articles: Article
    }
    subject = BulkAddOperations.new(allowed_models)
    subject.execute(operations)

    assert_equal true, subject.errors?
    assert_equal ["lid for 'author' not found", "'author' must exist"], subject.errors
  end
end
