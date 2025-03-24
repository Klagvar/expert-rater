require 'rails_helper'

RSpec.describe Image, type: :model do
  let(:theme) { Theme.create(name: "Nature") }

  describe "validations" do
    it "is valid with valid attributes" do
      image = Image.new(name: "Test Image", file: "test.jpg", theme: theme)
      expect(image).to be_valid
    end

    it "is invalid without a name" do
      image = Image.new(file: "test.jpg", theme: theme)
      expect(image).not_to be_valid
      expect(image.errors[:name]).to include("Название обязательно")
    end

    it "is invalid if name is too long" do
      image = Image.new(name: "a" * 201, file: "test.jpg", theme: theme)
      expect(image).not_to be_valid
      expect(image.errors[:name]).to include("is too long (maximum is 200 characters)")
    end

    it "is invalid without a file" do
      image = Image.new(name: "Test Image", theme: theme)
      expect(image).not_to be_valid
      expect(image.errors[:file]).to include("Файл обязателен")
    end

    it "is invalid with an invalid ave_value" do
      image = Image.new(name: "Test Image", file: "test.jpg", theme: theme, ave_value: 101)
      expect(image).not_to be_valid
      expect(image.errors[:ave_value]).to include("must be less than or equal to 100")
    end
  end

  describe "associations" do
    it "belongs to a theme" do
      expect(Image.reflect_on_association(:theme).macro).to eq(:belongs_to)
    end

    it "has many values" do
      expect(Image.reflect_on_association(:values).macro).to eq(:has_many)
    end
  end

  describe "scopes" do
    let(:theme) { Theme.create(name: "Nature") }
    let!(:image1) { Image.create(name: "Img1", file: "img1.jpg", theme: theme) }
    let!(:image2) { Image.create(name: "Img2", file: "img2.jpg", theme: theme) }

    before { Image.where.not(id: [image1.id, image2.id]).destroy_all }

    it "returns popular images with ave_value > 70" do
      popular_image = Image.create(name: "Popular", file: "pop.jpg", theme: theme, ave_value: 80)
      unpopular_image = Image.create(name: "Unpopular", file: "unpop.jpg", theme: theme, ave_value: 50)
      expect(Image.popular).to include(popular_image)
      expect(Image.popular).not_to include(unpopular_image)
    end

    it "returns theme images ordered by id" do
      expect(Image.theme_images(theme.id)).to eq([image1, image2])
    end
  end

  describe "#next_in_theme" do
    it "returns the next image in the same theme" do
      image1 = Image.create(name: "Img1", file: "img1.jpg", theme: theme)
      image2 = Image.create(name: "Img2", file: "img2.jpg", theme: theme)
      expect(image1.next_in_theme).to eq(image2)
    end
  end

  describe "#previous_in_theme" do
    it "returns the previous image in the same theme" do
      image1 = Image.create(name: "Img1", file: "img1.jpg", theme: theme)
      image2 = Image.create(name: "Img2", file: "img2.jpg", theme: theme)
      expect(image2.previous_in_theme).to eq(image1)
    end
  end

  describe "#update_ave_value" do
    let(:user) { User.create(name: "Test", email: "test@example.com", password: "password123") }
    let(:image) { Image.create(name: "Test Image", file: "test.jpg", theme: theme) }

    it "updates ave_value based on values" do
      Value.create(user: user, image: image, value: 80)
      Value.create(user: user, image: image, value: 60)
      image.update_ave_value
      expect(image.ave_value).to eq(70.0)
    end
  end
end