require 'test_helper'

class JsonapiTest < ActiveSupport::TestCase
  include Jsonapi::Deserializer

  test 'simple add operation' do
    params = {
      operations: [
        { op: :add, ref: { type: 'authors' }, data: { attributes: { name: 'Bob' }, lid: 'bob' } }
      ]
    }
    results = operations_deserializer(params)
    assert_equal :add, results.first.action
    assert_equal :authors, results.first.model
    assert_equal 'bob', results.first.lid
    assert_equal 'Bob', results.first.attributes[:name]
  end

  test 'simple add operation with relationship' do
    params = {
      operations: [
        {
          op: :add,
          ref: { type: 'authors' },
          data: {
            attributes: { name: 'Bob' },
            lid: 'bob',
            relationships: {
              author: { data: { type: 'authors', lid: 'john' } },
            }
          }
        }
      ]
    }
    results = operations_deserializer(params)
    assert_equal({ author: 'john' }, results.first.refs)
  end
end
