class Bar < ApplicationRecord
  PX_REGEX = /\d+(\.\d+)?px/
  SCRUB_PARAMS = %w(title created_at updated_at shop_id is_active background_image).freeze

  mount_uploader :background_image, BackgroundUploader

  belongs_to :shop

  validates_presence_of :title,
    :placement,
    :font_color,
    :page_template
  validates_length_of :content, minimum: 0, allow_nil: false
  validates_inclusion_of :placement, in: %w(top bottom)
  validates_inclusion_of :is_active, in: [true, false]
  validates_inclusion_of :is_sticky, in: [true, false]
  validates_inclusion_of :is_new_tab_url, in: [true, false]
  validates_inclusion_of :is_full_width_link, in: [true, false]
  validates_inclusion_of :has_close_button, in: [true, false]
  validates_inclusion_of :page_template,
    in: %w(global homepage collection product cart)
  validates_inclusion_of :background_image_repeat,
    in: %w(no-repeat repeat-x repeat-y repeat space)
  validates_inclusion_of :text_align, in: %w(center left right), allow_nil: true
  validates_format_of :font_size, with: PX_REGEX, allow_nil: true
  validates_format_of :padding_y, with: PX_REGEX, allow_nil: true
  validates_format_of :padding_x, with: PX_REGEX, allow_nil: true
  validates_numericality_of :text_opacity,
    less_than_or_equal_to: 1,
    greater_than_or_equal_to: 0,
    allow_nil: true
  validates_numericality_of :background_opacity,
    less_than_or_equal_to: 1,
    greater_than_or_equal_to: 0,
    allow_nil: true
  validates :url, url: true, allow_nil: true

  scope :with_active, -> { where(is_active: true) }

  def self.with_page_template(page_template)
    where(page_template: page_template)
  end

  def self.with_domain_name(domain)
    shop = Shop.by_domain_name(domain)
    where(shop_id: shop)
  end

  def self.to_decimal(integer)
    return 1.0 if integer > 100
    return 0.0 if integer < 0
    integer.to_f / 100
  end

  def opacity(integer, param)
    decimal = Bar.to_decimal(integer)
    update_attribute(param, decimal)
    self
  end

  after_update_commit :is_active_toggle_for_page_template

  private

  def is_active_toggle_for_page_template
    return unless is_active?
    return unless saved_change_to_is_active?
    return update_is_active_for_all_templates if page_template === 'global'
    update_is_active_for_match_template
  end

  def update_is_active_for_all_templates
    bars_active_without_current.each do |bar|
      bar.update_columns(is_active: false)
    end
  end

  def update_is_active_for_match_template
    bars_active_without_current
      .with_page_template(page_template)
      .or(bars_active_without_current.with_page_template('global'))
      .each { |bar| bar.update_columns(is_active: false) }
  end

  def bars_active_without_current
    shop.bars.with_active.where.not(id: id)
  end
end