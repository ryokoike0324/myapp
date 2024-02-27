RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, :js, type: :system) do
    driven_by :selenium_chrome_headless
  end

  # Capybaraはボタンが現れるまで15秒待つ
  Capybara.default_max_wait_time = 15
end
