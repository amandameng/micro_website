#encoding: utf-8
class Page < ActiveRecord::Base
   belongs_to :site
   attr_accessible :title, :file_name, :types, :site_id, :path_name, :authenticate,:element_relation,:content
   attr_accessor :content
   TYPES_ARR = ['main', 'sub', 'style', 'form']
   TYPE_NAMES = {:main => 0, :sub => 1, :style => 2, :form => 3}
   TYPES = {0 => "主页", 1 => "子页", 2 => "样式表", 3 => "表单"}

  TYPES_ARR.each do |type|
   scope type.to_sym, :conditions => { :types => TYPE_NAMES[type.to_sym] }
  end
   validates :title, :file_name,  :uniqueness => {:scope => :site_id}
   
end
