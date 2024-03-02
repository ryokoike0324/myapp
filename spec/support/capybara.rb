require 'capybara/rspec'
require 'selenium/webdriver'

Capybara.register_driver :remote_chrome do |app|
  url = ENV.fetch('SELENIUM_DRIVER_URL')

  chrome_options = Selenium::WebDriver::Chrome::Options.new
  chrome_options.add_argument('--no-sandbox')
  chrome_options.add_argument('--headless')
  chrome_options.add_argument('--disable-gpu')
  chrome_options.add_argument('--window-size=1680,1050')

  {
    browserName: 'chrome',
    'goog:chromeOptions' => chrome_options.as_json
  }

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url:,
    options: chrome_options
  )
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, :js, type: :system) do
    driven_by :remote_chrome
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 4444
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end
end
