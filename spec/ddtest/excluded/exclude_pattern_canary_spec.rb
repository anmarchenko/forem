# frozen_string_literal: true

RSpec.describe "DDTest exclude pattern canary" do
  it "would be discovered without the ddtest exclude pattern" do
    expect(true).to be(true)
  end
end
