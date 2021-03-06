#encoding: utf-8
class ResourcesController < ApplicationController
  layout 'sites'
  SITE_PATH = "/public/%s/"
  require 'fileutils'
  #  require 'rubygems'
  #  require 'zip'
  #require 'archive/zip'

  def index
    @site=Site.find(params[:site_id])
  end

  def create
   do_create
  end
  #创建
  def do_create
    @site=Site.find(params[:site_id])
    @tmp = params[:resources][:myfile]
    @resource=@site.resources.build
    @root1_path=@site.root_path
    @resource.path_name=@root1_path+"/resources/"+@tmp.original_filename
    @full_dir=Rails.root.to_s+SITE_PATH % @root1_path+"resources"
    @full_path=Rails.root.to_s+SITE_PATH % @root1_path+"resources/"+@tmp.original_filename
    @lim_resource=%w[zip jpg png mp3 mp4 avi rm rmvb gif ]
    @img_resources=%w[jpg png gif]
    @voice_resources=%w[mp3]
    @video_resoures=%w[mp4 avi rm rmvb]
    postfix_name=@tmp.original_filename.split('.')[-1]
    
    #创建目录
    resources_dir_exist
    if @lim_resource.include?(postfix_name)
      if postfix_name=='zip'
        save_all
      elsif @img_resources.include?(postfix_name)&&@tmp.size<1024*1024
        svae_afile @tmp
      elsif @voice_resources.include?(postfix_name)&&@tmp.size<50*1024*1024
        svae_afile @tmp
      elsif @video_resoures.include?(postfix_name)&&@tmp.size<200*1024*1024
        svae_afile @tmp
      else
        flash[:error]='文件大小超限,图片不超过1M，音频不超过50M，视频不超过200M'
      end
      redirect_to site_resources_path(@site)
    else
      #flash[:error]='资源不规范，只能视频，音频，图片，或(zip)压缩包'
      #render 'index'
      redirect_to site_resources_path(@site)
    end
  end


  #判断是否有目录
  def resources_dir_exist
    if !File::directory?( @full_dir )
      FileUtils.mkdir_p(@full_dir)
    end
  end

  ##########保存一个文件
  def svae_afile(tmp)
    if @resource.save
      flash[:success]='保存成功'
      save
    else
      flash[:error]='文件已经存在'
    end
  end

  #zip解压保存
  def save_all
    # @full_path=Rails.root.to_s+SITE_PATH % @root1_path+"temp1/"+@tmp.original_filename
    # @full_dir=Rails.root.to_s+SITE_PATH % @root1_path+"temp1"
    #save
    #解压在一个临时目录
    @full_dir=Rails.root.to_s+SITE_PATH % @root1_path+"temp"
    #执行解压
    Archive::Zip.open(@tmp.path) do |z|
      z.extract(@full_dir, :flatten => true)
    end
    
    # Archive::Zip.extract(
    # @tmp.path,
    # @full_dir,
    # :create => false,
    # :overwrite => :older
    # )
    #@full_path=Rails.root.to_s+SITE_PATH % @root1_path+"resources/"+@tmp.original_filename
    arr=[]
    @arr_repeat=0
    arr_error=0
    Dir.foreach(@full_dir) do |entry|
      if !File::directory?(entry)
        postfix_name=entry.split('.')[-1]
        resour=@site.resources.build
        resour.path_name=@root1_path+"/resources/"+entry
        ful_pa=Rails.root.to_s+SITE_PATH % @root1_path+"temp/"+entry
        tmp_file=File.new(ful_pa)
        ful_path=Rails.root.to_s+SITE_PATH % @root1_path+"resources/"+entry
        
        if @img_resources.include?(postfix_name)&&tmp_file.size<1024*1024
          save_from_zip(resour,arr,ful_pa,ful_path)
        elsif @voice_resources.include?(postfix_name)&&tmp_file.size<50*1024*1024
          save_from_zip(resour,arr,ful_pa,ful_path)
        elsif @video_resoures.include?(postfix_name)&&tmp_file.size<200*1024*1024
          save_from_zip(resour,arr,ful_pa,ful_path)
        else
          arr_error+=1
        end
       
      end
    end
    flash[:success]="成功加入#{arr.length}个资源,有#{arr_error}个不符合规范的，有#{@arr_repeat}个重复资源"
    FileUtils.rm_r @full_dir 
  end
  ##
  def save_from_zip(resour,arr,ful_pa,ful_path)
    if resour.save
      arr<<resour.path_name
      FileUtils.cp  ful_pa,ful_path
    else
      @arr_repeat+=1
    end
  end

  def save
    file = File.join("public",@tmp.original_filename)
    #dirname=Rails.root.to_s+SITE_PATH % @root_path+"//resources"
    file1=File.new(@full_path,'wb')
    FileUtils.cp @tmp.path,file1
  end



  def is_not_repeat
    puts '*******************'
    puts '*******    ********'
    puts '*     *************'
    puts '*******************'
    puts '*******************'
    @site=Site.find(params[:id])
    name=@site.root_path+"/resources/"+params[:name]
    @re=Resource.find_by_path_name(name)

    if @re
      render :json => {:status => 0}
    else
      render :json => {:status => 1}
    end
 
    #redirect_to root_path
  #  render 'resources/is_not_repeat',:layout=>false
  end


    #
  def destroy
    @site=Site.find(params[:site_id])
    @resource=Resource.find(params[:id])
    name=@resource.path_name
    if @resource.destroy
      flash[:success]='删除成功'
      delete_file name
      redirect_to site_resources_path(@site)
    else
      flash[:success]='删除成功'
      redirect_to site_resources_path(@site)
    end
  end

  def delete_file(name)
    dirname=Rails.root.to_s+'/public/'+name;
    FileUtils.rm dirname
  end

  #show
  def show
  end
end
