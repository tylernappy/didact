class Integration < ActiveRecord::Base
    validates :name, presence: true

    belongs_to :user
    has_many :tasks

    after_initialize :set_default_values
    def set_default_values
      # Only set if time_zone IS NOT set
      self.is_complete ||= false
    end
end
