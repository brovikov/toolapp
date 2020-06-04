module Tools
  class Contract < Dry::Validation::Contract
    include Dry::Monads[:result]

    params do
      required(:name).filled(:string)
      required(:language).filled(:string).value(Types::LowcaseString, size?: 2)
    end

    def validate(params)
      validate = call(params)

      return Success(validate) if validate.success?

      Failure(validate.errors(full: true).to_h.flat_map { |key, value| value })
    end
  end
end
