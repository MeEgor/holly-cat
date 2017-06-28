require 'test_helper'

class StaticPagesTest < ActionDispatch::IntegrationTest
  test "root page" do
    get root_path
    assert_select "h1.content-header", "Holly Cat!"
    assert_select "img#cat-img"
  end
end
