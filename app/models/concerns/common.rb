module Concerns::Common
  extend ActiveSupport::Concern

  included do

    class << self
      def get_random
        order('RAND()').first
      end
    end

  end

end
