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
    expected = [
      { action: :add, model: :authors, lid: 'bob', attributes: { name: 'Bob' }, refs: {} }
    ]
    assert_equal expected, results
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
    expected = [
      {
        action: :add,
        model: :authors,
        lid: 'bob',
        attributes: { name: 'Bob' },
        refs: { author: 'john' }
      }
    ]
    assert_equal expected, results
  end
end
