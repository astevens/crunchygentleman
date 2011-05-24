CrunchyGentleman.controllers :imports do
  get :imagefap do
    render 'imports/imagefap'
  end

  post :imagefap do
    doc = Nokogiri::HTML(open(params[:imagefap_url] + "?view=2"))

    post_name = doc.at_css("div#main table font").text

    image_tags = doc.search("div#gallery a img")
    thumb_image_urls = image_tags.map{|il| il.attributes["src"].value}
    full_image_urls = thumb_image_urls.map{|ti| ti.gsub(/\/thumb\//, '/full/')}
    
    logger.info("Creating post #{post_name}")
    @post = Post::Image.create(:description => post_name)

    number_per_thread = (full_image_urls.length / 3.0).round
    full_image_urls.each_slice(number_per_thread).each do |url_subset|
      Thread.new do
        url_subset.each do |url|
          logger.info("Adding image #{url}")
          Media::Image.create(:post => @post, :remote_file_url => url)
        end
      end
    end
    
    redirect url(:posts, :show, :id => @post)
  end
  
end