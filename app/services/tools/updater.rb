module Tools
  class Updater
    extend Dry::Initializer
    include Dry::Monads[:result, :do]
    include Dry::Monads::Do.for(:call)

    option :github_client, reader: :private, default: proc { Octokit::Client.new(access_token: ENV["GITHUB_ACCESS_TOKEN"]) }
    option :lokalize_client, reader: :private, default: proc { Lokalise.client(ENV["LOKALISE_API_KEY"]) }
    option :get_translations, reader: :private, default: proc { GetTranslations.new(api_client: lokalize_client) }
    option :filename_lookup, reader: :private, default: proc { Github::FilenameLookup.new(api_client: github_client) }
    option :fetch_file, reader: :private, default: proc { Github::FetchFile.new(api_client: github_client) }
    option :merge_hashes, reader: :private, default: proc { MergeHashes.new }
    option :create_pull_request, reader: :private, default: proc { Github::CreatePullRequest.new(api_client: github_client) }

    def call(tool)
      translations_hash = yield get_translations.call(tool)
      file_name = yield filename_lookup.call(file_name_regex(tool.name))
      json_spec = yield fetch_file.call(file_name)
      payload = yield merge_hashes.call(translations: translations_hash, master: json_spec)
      yield create_pull_request.call(tool: tool, payload: payload)

      Success()
    end

    private

    def file_name_regex(name)
      /#{name}\...\.master.json/
    end
  end
end
