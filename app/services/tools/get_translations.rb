module Tools
  class GetTranslations
    extend Dry::Initializer
    include Dry::Monads[:result]

    PLATFORMS = %w[ios android web other]

    option :api_client, reader: :private

    def call(tool)
      @tool = tool

      Success(Sparsify.unsparse(translations)[tool.name])
    end

    private

    def keys
      api_client.keys(ENV["LOKALISE_PROJECT_ID"], limit: 1000, filter_tag: "#{tool.name}, #{tool.language}", include_translations: 1)
    end

    def translations
      @translations ||= keys.collection.each_with_object({}) { |c, res| res[c.key_name["other"]] = c.translations.first["translation"] }
    end

    attr_reader :tool
  end
end
