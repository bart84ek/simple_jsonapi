require 'test_helper'

class BulkControllerTest < ActionDispatch::IntegrationTest
  test 'patch /bulk should success' do
    patch bulk_url, params: { bulk: { operations: [] } }
    assert_response :success
  end

  test 'patch /bulk with two associated operations should success' do
    params = {
      "operations": [{
        "op": "add",
        "ref": {
          "type": "authors"
        },
        "data": {
          "type": "authors",
          "lid": "a",
          "attributes": {
            "name": "dgeb"
          }
        }
      }, {
        "op": "add",
        "ref": {
          "type": "articles"
        },
        "data": {
          "type": "articles",
          "attributes": {
            "title": "JSON API paints my bikeshed!"
          },
          "relationships": {
            "author": {
              "data": {
                "type": "authors",
                "lid": "a"
              }
            }
          }
        }
      }]
    }

    patch bulk_url, params: { bulk: params }
    assert_response :success
    assert_equal 1, Author.count
    assert_equal 1, Article.count
    assert_equal 'dgeb', Author.first.name
    assert_equal 'dgeb', Article.first.author.name
  end

  test 'patch /bulk with two associated with wrong operations order should success' do
    params = {
      "operations": [
      {
        "op": "add",
        "ref": {
          "type": "articles"
        },
        "data": {
          "type": "articles",
          "attributes": {
            "title": "JSON API paints my bikeshed!"
          },
          "relationships": {
            "author": {
              "data": {
                "type": "authors",
                "lid": "a"
              }
            }
          }
        }
      },
      {
        "op": "add",
        "ref": {
          "type": "authors"
        },
        "data": {
          "type": "authors",
          "lid": "a",
          "attributes": {
            "name": "dgeb"
          }
        }
      }]
    }

    patch bulk_url, params: { bulk: params }
    assert_response :success
    assert_equal 1, Author.count
    assert_equal 1, Article.count
    assert_equal 'dgeb', Author.first.name
    assert_equal 'dgeb', Article.first.author.name
  end
end
