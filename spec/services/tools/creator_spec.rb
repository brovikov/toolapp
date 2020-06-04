require "rails_helper"

RSpec.describe Tools::Creator, vcr: true do
  let(:params) { {name: "BMI", language: "eN"} }

  subject! { described_class.new.call(params) }

  it { expect(subject.success?).to be true }
  it { expect(Tool.last.language).to eq params[:language].downcase }
end
