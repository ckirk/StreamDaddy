class HboMovie < ActiveRecord::Base
	belongs_to :movie

	default_scope { order('available_since DESC') }
end
