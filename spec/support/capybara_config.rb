Capybara.register_driver :poltergeist do |app|
  options = {
    :js_errors => false,
    :timeout => 120,
    :debug => false,
    :phantomjs_options => ['--load-images=no', '--disk-cache=false'],
    :inspector => false
  }
  Capybara::Poltergeist::Driver.new(app, options) #, debug: true, window_size: [1300, 1000]) #, debug: true, window_size: [1300, 1000])
end

Capybara.javascript_driver = :poltergeist

Capybara.asset_host="http://localhost:3000/"
Capybara.save_and_open_page_path = Rails.root.join('tmp', 'capybara').to_s
