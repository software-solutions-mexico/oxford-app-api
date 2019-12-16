require 'rails_helper'

RSpec.describe "V1::Campus", type: :request do
  describe "GET /v1/campus" do
    it "works! (now write some real specs)" do
      get campus_path
      expect(response).to have_http_status(200)
    end
  end
end
