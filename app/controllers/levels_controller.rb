class LevelsController < ApplicationController
  def index
    @levels = Level.all
  end

  def show
  end

  def new
    @level = Level.new
  end

  def create
    @level = Level.new(level_params)

    image = params[:level][:image_path]
    if image != nil
      filename = image.original_filename
      filepath = "#{Rails.root}/public/upload/#{filename}"
      File.open("#{filepath}", "wb") do |f|
    	   f.write(image.read)
      end
      @level.image_path = "/upload/#{filename}"
    end

    if @level.save
      redirect_to action: "index"
    else
      render :new
    end
  end

  def edit
    @level = Level.find(params[:id])
  end

  def update
    @level = Level.find(params[:id])

    if @level.update_attributes(level_params)
      redirect_to action: 'index'
    else
      render :edit
    end
  end

  def destroy
    @level = Level.find params[:id]

    Option.destroy_all(level_id: @level.id)
    Tip.destroy_all(level_id: @level.id)

    # if @level.image_path != nil and @level.image_path != ""
    #   filepath = "#{Rails.root}/public" + @level.image_path
    #   File.delete(filepath)
    # end

    @level.destroy
    redirect_to action: "index"
  end

  private

    def level_params
      params.require(:level)
            .permit(:name, :description, :image_path, :degree)
    end

end
