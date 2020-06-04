module Tools
  class PostKeysToLokalise
    extend Dry::Initializer
    include Dry::Monads[:result]

    PLATFORMS = %w[ios android web other]

    option :api_client, reader: :private

    def call(json_spec)
      @json_spec = json_spec
      created_keys = api_client.create_keys(ENV["LOKALISE_PROJECT_ID"], payload)

      Success(created_keys)
    end

    private

    def payload
      translation_keys.map { |key, val| key_payload(key, val) }
    end

    def key_payload(key, val)
      {
        key_name: key_name(key),
        platforms: PLATFORMS,
        translations: [{
          language_iso: language,
          translation: val
        }],
        tags: [tool_name, language]
      }
    end

    def key_name(key)
      JSON.generate(PLATFORMS.each_with_object({}) { |p, res| res[p] = key })
    end

    def translation_keys
      Sparsify.sparse(json_spec, tool_name: tool_name).select { |k, v| v.is_a? String }
    end

    def tool_name
      json_spec["id"]
    end

    def language
      json_spec["language"].downcase
    end

    attr_reader :json_spec
  end
end
