require 'test_helper'

class HomepageRouteTest < ActionDispatch::IntegrationTest
  def test_user_get
    assert_routing "/api/users", :controller => "api/users", :action => "index"
  end

  def test_user_post
    assert_routing({ method: 'post', path: '/api/users' }, {:controller => "api/users", :action => "create"})
  end
end