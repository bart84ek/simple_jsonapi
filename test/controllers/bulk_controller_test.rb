require "test_helper"

class BulkControllerTest < ActionDispatch::IntegrationTest
  test 'patch /bulk should success' do
    patch bulk_url
    assert_response :success
  end
end
