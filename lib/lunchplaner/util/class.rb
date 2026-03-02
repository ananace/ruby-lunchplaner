# frozen_string_literal: true

class Class
  def demodularized
    name.split('::').last
  end
end
