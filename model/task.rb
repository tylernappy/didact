class Task < ActiveRecord::Base
    belongs_to :integration
    has_many :comments

    after_initialize :set_default_values
    def set_default_values
      # Only set if time_zone IS NOT set
      self.is_complete ||= false
    end
end
