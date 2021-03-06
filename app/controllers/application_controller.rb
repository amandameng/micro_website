#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  include ApplicationHelper
  SITE_PATH = "/public/%s/"
  require "fileutils"

  def get_site
    @site = Site.find_by_id params[:site_id]
  end

  def save_into_file(content, page)
     site_root = page.site.root_path if page.site
     site_path = Rails.root.to_s + SITE_PATH % site_root
     FileUtils.mkdir_p(site_path) unless Dir.exists?(site_path)
     p 11111111111111111
     p site_path + page.file_name
     File.open(site_path + page.file_name, "wb") do |f|
        f.write(content.html_safe)
     end
    page.path_name = SITE_PATH % site_root + page.file_name
    page.save
  end
end
