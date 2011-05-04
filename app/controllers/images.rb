CrunchyGentleman.controllers :images do
  get :index do
    @images = Media::Image.all
    render 'images/index'
  end
end