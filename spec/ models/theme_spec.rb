require 'rails_helper'

RSpec.describe Theme, type: :model do
  describe "associations" do
    it "has many images" do
      expect(Theme.reflect_on_association(:images).macro).to eq(:has_many)
    end
  end

  describe "#best_image" do
    let(:theme) { Theme.create(name: "Nature") }
    let!(:image1) { Image.create(name: "Img1", file: "img1.jpg", theme: theme, ave_value: 60) }
    let!(:image2) { Image.create(name: "Img2", file: "img2.jpg", theme: theme, ave_value: 80) }

    it "returns the image with the highest ave_value" do
      expect(theme.best_image).to eq(image2)
    end

    it "returns nil if no images exist" do
      theme.images.destroy_all
      expect(theme.best_image).to be_nil
    end
  end
end