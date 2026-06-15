# frozen_string_literal: true

# Touch this spec-tree file when validating DDTest discovery-cache invalidation.
RSpec.describe "DDTest exclude pattern canary" do
  it "would be discovered without the ddtest exclude pattern" do
    expect(true).to be(true)
  end
end
