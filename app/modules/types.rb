module Types
  include Dry::Types()

  LowcaseString = Types::String.constructor(&:downcase)
end
