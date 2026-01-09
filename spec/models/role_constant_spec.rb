require "rails_helper"

RSpec.describe Role do
  describe "::ROLES" do
    it "contains the value" do
      expect(described_class::ROLES).to include("codeland_admin")
    end
  end
end
