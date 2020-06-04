module Tools
  class Creator
    extend Dry::Initializer
    include Dry::Monads[:result, :do]
    include Dry::Monads::Do.for(:call)

    option :validator, reader: :private, default: proc { Tools::Contract.new }
    option :github_client, reader: :private, default: proc { Octokit::Client.new(access_token: ENV["GITHUB_ACCESS_TOKEN"]) }
    option :lokalize_client, reader: :private, default: proc { Lokalise.client(ENV["LOKALISE_API_KEY"]) }
    option :tool, reader: :private, default: proc { Tool }
    option :filename_lookup, reader: :private, default: proc { Github::FilenameLookup.new(api_client: github_client) }
    option :fetch_file, reader: :private, default: proc { Github::FetchFile.new(api_client: github_client) }
    option :post_keys_to_lokalise, reader: :private, default: proc { PostKeysToLokalise.new(api_client: lokalize_client) }

    def call(params)
      payload = yield validator.validate(params)
      file_name = yield filename_lookup.call(file_name_regex(payload))
      json_spec = yield fetch_file.call(file_name)
      yield post_keys_to_lokalise.call(json_spec)
      tool_instance = yield create_tool(payload.to_h.merge(json_spec: json_spec))

      Success(tool_instance)
    end

    private

    def create_tool(payload)
      tool_instance = tool.new(payload)
      tool_instance.save ? Success(tool_instance) : Filure(tool_instance.errors)
    end

    def file_name_regex(payload)
      /#{payload[:name]}\.#{payload[:language]}.*\.json/
    end
  end
end
