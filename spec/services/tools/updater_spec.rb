require "rails_helper"

RSpec.describe Tools::Updater, vcr: true do
  let(:tool) { FactoryBot.create(:tool) }

  subject { described_class.new.call(tool) }

  it { expect(subject.success?).to be true }
end
