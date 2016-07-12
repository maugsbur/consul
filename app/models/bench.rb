class Bench < ActiveRecord::Base

  def original_image_url
    "docs/town_planning/#{code}_#{name.parameterize.underscore}.jpg"
  end

  def thumb_image_url
    "town_planning/#{code}_#{name.parameterize.underscore}_thumb.jpg"
  end

  def pdf_url
    "/docs/town_planning/#{code}_dossier_#{name.parameterize.underscore}.pdf"
  end

  def pdf_title
    "Dossier #{name} (PDF | #{pdf_size})"
  end

  def pdf_size
    helper = Object.new.extend(ActionView::Helpers::NumberHelper)
    helper.number_to_human_size(pdf_url.size)
  end

end