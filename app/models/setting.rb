class Setting < ApplicationRecord

  has_paper_trail

  has_one_attached :attachment, acl: 'public'

  validates_presence_of :name

  def self.fetch name, default = nil, attachment_options = {}
    setting = Setting.find_or_create_by(name: name) do |s|
      s.value = default
      if attachment_options.present?
        s.attachment.attach(attachment_options)
      end
    end

    setting.has_attachment? ? setting.url : setting.value
  rescue Exception
    return default
  end

  def self.get name
    setting = Setting.find_by(name: name)
    return setting.value unless setting.nil?
  end

  def self.set name, value
    setting = Setting.find_by(name: name)
    if setting.nil?
      Setting.fetch name, value
    else
      setting.update(value: value)
    end
  end

  # Dry up setting access:
  def self.site_title
    fetch 'site.title', 'Location Machine'
  end

  def self.site_tagline
    fetch 'site.tagline', 'GPS meets Photography meets Messaging'
  end

  def self.site_custom_html
    fetch('site.custom-html', '').html_safe
  end

  def self.site_logo
    fetch 'site.logo', nil, {
      io: File.open(Rails.root.join('app', 'assets', 'images', 'logo.png')), filename: 'logo.png'
    }
  end

  def self.site_logo_masthead
    fetch 'site.logo-masthead', nil, {
      io: File.open(Rails.root.join('app', 'assets', 'images', 'logo-masthead.png')), filename: 'logo-masthead.png'
    }
  end

  def self.site_currency
    fetch 'site.currency', 'USD'
  end

  def self.site_limit_location
    fetch "site.limit_location", 50
  end

  def self.site_location_radius
    fetch "site.site_location_radius", 50
  end

  def self.number_of_newest_items
    fetch "site.number_of_newest_items", 20
  end

  def self.map_center
    fetch 'map.center', '21.0174607, 105.8416558'
  end

  def has_attachment?
    attachment.attached?
  end

  def has_image_attached?
    has_attachment? && attachment.content_type.include?('image')
  end

  def url
    attachment.service_url
  end
end
