class Product < ActiveRecord::Base
	validates :title, :description, :image_url, presence: true
	validates :price, numericality: {greater_than_or_equal: 0.01}
	validates :title, uniqueness: true, length: { minimum: 10, too_short: "%{count} characters is the minimun allowed" }
	validates :image_url, allow_blank: true, format: {
																						with: %r{\.(gif|jpg|png)\Z}i,
																						message: 'must be a URL for GIF, JPG or PNG image.'
																						}
	has_many :line_items
	before_destroy :ensure_not_referenced_by_any_line_item

	def ensure_not_referenced_by_any_line_item
		if line_items.empty?
			return true
		else
			errors.add(:base, 'Line Items present')
			return false
		end
	end

end
