require "rails_helper"

RSpec.describe V1::CampusController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/v1/campus").to route_to("v1/campus#index")
    end

    it "routes to #show" do
      expect(:get => "/v1/campus/1").to route_to("v1/campus#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/v1/campus").to route_to("v1/campus#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/v1/campus/1").to route_to("v1/campus#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/v1/campus/1").to route_to("v1/campus#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/v1/campus/1").to route_to("v1/campus#destroy", :id => "1")
    end
  end
end
