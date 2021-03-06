# TODO: this should be just a function that is called in a before
# these are not shared examples, so it feels misleading
#
# TODO: we should probably use `login_as` for most tests and only
# use the OmniAuth login when explicitly testing OmniAuth (for speeed)

RSpec.shared_examples "admin login" do |parameter|
  let(:admin) { FactoryBot.create :facebook_user, :with_admin }

  before :each do
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      "provider": "facebook",
      "uid": admin.identities.facebook.first.uid,
      "email": admin.email,
      "name": admin.name
    })

    visit new_user_session_path
    click_link 'Login with Facebook'

    visit admin_dashboard_path
    wait_until { page.current_path == admin_dashboard_path }
  end
end

RSpec.shared_examples "user login" do |parameter|
  let(:user) { FactoryBot.create :user }

  before :each do
    login_as user, scope: :user
  end
end

