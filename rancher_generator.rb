require 'selenium-webdriver'
require 'capybara'
require 'headless'

class RancherGenerator
  HA_NODES_MAPPING = {
    '1' => 0,
    '3' => 1,
    '5' => 2,
  }

  attr_reader :url, :fqdn_url, :ha_nodes, :session

  def initialize(url: , fqdn_url: , ha_nodes: '3', download_dir: '/tmp/')
    @url = url
    @fqdn_url = fqdn_url
    @ha_nodes = ha_nodes
    headless = Headless.new(:destroy_at_exit => true)
    headless.start

    Capybara.register_driver :firefox do |app|
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['browser.download.dir'] = download_dir
      profile['browser.download.folderList'] = 2
      profile['browser.helperApps.neverAsk.saveToDisk'] = "application/octet-stream"


      Capybara::Selenium::Driver.new(app, browser: :firefox, profile: profile)
    end
    @session = Capybara::Session.new(:firefox)
  end

  def configure_ha
    session.visit url

    begin
      session.find('button', text: 'Got It').click
    rescue Exception => e
      puts e
    end

    form = session.find('#haConfigForm')

    radios = session.all('input[type=radio]')

    radios[HA_NODES_MAPPING[ha_nodes]].click

    fqdn_field = form.find('input[type=text]')

    fqdn_field.set(fqdn_url)

    form.find('button', text: 'Generate Config Script').click

    session.find('button', text: 'Download Config Script').click
  end
end
