module Tools
  class MergeHashes
    extend Dry::Initializer
    include Dry::Monads[:result]

    def call(translations:, master:)
      # Success(update_hash(translations: translations.merge("language" => "zulu"), master: master))
      Success(update_hash(translations: translations, master: master))
    end

    private

    def update_hash(master:, translations:)
      master.each do |k, v|
        if v.is_a?(Hash)
          update_hash master: v, translations: translations[k]
        elsif translations[k].present?
          v.replace translations[k]
        end
      end
      master
    end
  end
end
