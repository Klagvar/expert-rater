require 'rails_helper'

RSpec.describe Value, type: :model do
  let(:user) { User.create(name: "Test", email: "test@example.com", password: "password123") }
  let(:theme) { Theme.create(name: "Nature") }
  let(:image) { Image.create(name: "Test Image", file: "test.jpg", theme: theme) }

  describe "validations" do
    it "is valid with valid attributes" do
      value = Value.new(user: user, image: image, value: 75)
      expect(value).to be_valid
    end

    it "is invalid without a user" do
      value = Value.new(image: image, value: 75)
      expect(value).not_to be_valid
      expect(value.errors[:user]).to include("must exist")
    end

    it "is invalid without an image" do
      value = Value.new(user: user, value: 75)
      expect(value).not_to be_valid
      expect(value.errors[:image]).to include("must exist")
    end

    it "is invalid without a value" do
      value = Value.new(user: user, image: image)
      expect(value).not_to be_valid
      expect(value.errors[:value]).to include("can't be blank")
    end

    it "is invalid with a value outside 0-100" do
      value = Value.new(user: user, image: image, value: 101)
      expect(value).not_to be_valid
      expect(value.errors[:value]).to include("Оценка должна быть от 0 до 100")
    end
  end

  describe "associations" do
    it "belongs to a user" do
      expect(Value.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it "belongs to an image" do
      expect(Value.reflect_on_association(:image).macro).to eq(:belongs_to)
    end
  end

  describe "after_save callback" do
    it "updates the image's ave_value after saving" do
      Value.create(user: user, image: image, value: 80)
      expect(image.reload.ave_value).to eq(80.0)
    end
  end
end