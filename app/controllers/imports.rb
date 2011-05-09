CrunchyGentleman.controllers :imports do
  get :imagefap do
    render 'imports/imagefap'
  end

  post :imagefap do
    doc = Nokogiri::HTML(open(params[:imagefap_url] + "?view=2"))

    post_name = doc.at_css("div#main table font").text

    image_tags = doc.search("div#post a img")
    thumb_image_urls = image_tags.map{|il| il.attributes["src"].value}
    full_image_urls = thumb_image_urls.map{|ti| ti.gsub(/\/thumb\//, '/full/')}

    @post = Post::Image.create(:description => post_name)

    full_image_urls.each do |url|
      Media::Image.create(:post => @post, :remote_file_url => url)
    end

    redirect url(:posts, :show, :id => @post)
  end

end