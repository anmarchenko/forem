require "rails_helper"

RSpec.describe Role do
  describe "::ROLES" do
    it "contains the value" do
      expect(described_class::ROLES).to include("codeland_admin")
    end

    it "has NEW constant" do
      expect(Constants::Role::NEW).to eq(0)
    end
  end
end
