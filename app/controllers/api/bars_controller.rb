class Api::BarsController < ApplicationController
  before_action :set_bar, only: [:show, :update, :destroy]

  def index
    @bars = Bar.with_domain_name(params[:hostname])
  end

  def show
  end

  def create
    shop = Shop.find_by(id: params[:shop_id])
    @bar = shop.bars.new(bar_params)

    if @bar.save
      render 'api/bars/show'
    else
      render json: @bar.errors.full_messages, status: 422
    end
  end

  def update
    if @bar.update(bar_params)
      render 'api/bars/show'
    else
      render json: @bar.errors.full_messages, status: 422
    end
  end

  def destroy
    if @bar && @bar.destroy
      render 'api/bars/show'
    else
      render json: ['not found'], status: 404
    end
  end

  private

  def set_bar
    @bar = Bar.find_by(id: params[:id])
  end

  def bar_params
    params.require(:bar).permit(
      :title,
      :content,
      :padding_top,
      :padding_bottom,
      :padding_right,
      :padding_left,
      :has_close_button,
      :url,
      :is_active,
      :is_new_tab_url,
      :is_sticky,
      :placement,
      :page_template,
      :font_color,
      :font_family,
      :font_size,
      :text_opacity,
      :text_align,
      :background_opacity,
      :background_image,
      :background_image_repeat,
      :background_image_size_x,
      :background_image_size_y,
      :background_image_position_x,
      :background_image_position_y
    )
  end
end
