require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  test "root page" do
    get :index
    assert_select "h1.content-header", "Holly Cat!"
    assert_select "img#cat-img"
  end

end
