require 'capybara/dsl'
require 'capybara/poltergeist'
require "selenium/webdriver"
require 'yaml'

# Experimental for right now

Capybara.register_driver :chrome do |app|
  profile = Selenium::WebDriver::Chrome::Profile.new
  profile["download.default_directory"] = DownloadHelpers::PATH.to_s
  Capybara::Selenium::Driver.new(app, :browser => :chrome, :profile => profile)
end

Capybara.default_driver = Capybara.javascript_driver = :chrome

module DownloadHelpers
  TIMEOUT = 10
  PATH    = File.join(Dir.home, "Downloads") 

  extend self

  def downloads
    Dir.entries(PATH)
  end

  def download
    downloads.first
  end

  def download_content
    wait_for_download
    File.read(download)
  end

  def wait_for_download
    Timeout.timeout(TIMEOUT) do
      sleep 0.1 until downloaded?
    end
  end

  def downloaded?
    !downloading? && downloads.any?
  end

  def downloading?
    downloads.grep(/\.crdownload$/).any?
  end

  def clear_downloads
    FileUtils.rm_f(downloads)
  end
end

module Gliffy include Capybara::DSL

  def login
    config_file = File.join(Dir.home, "drivegliffy.yml")
    if File.exist?(config_file)
      @config = YAML.load_file(config_file)
    end
    visit('https://go.gliffy.com/go/auth/login')
    #click_link('Login')
    #sleep 10
    find('[name=login-email]').set(@config['gliffy_username'])
    find('[name=login-password]').set(@config['gliffy_password'])
    click_button("Sign in")
    sleep 10
    find('a.close').click
  end

  def import(filename)
    within(:id, 'top-menu-file-import', :visible => false) do
      attach_file('file', filename, visible: false)
    end
    sleep 5
    new_window = window_opened_by { click_button 'Open' }
    return new_window
  end

  def save_and_export_png(new_window)
    export_filename = "DELETEME_"+Time.now.to_i.to_s
    within_window new_window do
      sleep 5
      find(:id, 'top-menu-file').click
      find(:xpath, '//*[@id="top-menu-file-save"]/a', visible: false).click
      sleep 5
      find('.gliffy-save-filename').set(export_filename)
      find(:xpath, '//*[@id="gliffy-save-modal"]/div[3]/div/button[3]', visible: false).click
      sleep 30
      find(:id, 'top-menu-file').click
      find(:xpath, '//*[@id="top-menu-file-export"]/a', visible: false).click
      find(:xpath, '//*[@id="alertDialog"]/div[3]/button[1]', visible: false).click
      sleep 30
    end
    return export_filename
  end

end

include Gliffy
in_filename = ARGV[0]
out_filename = ARGV[1]
File.delete(out_filename) if File.exist?(out_filename)
login
win = import(in_filename)
export_filename = save_and_export_png(win) + ".png"
export_filename = File.join(DownloadHelpers::PATH, export_filename)
File.rename(export_filename, out_filename)
