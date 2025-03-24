require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = User.new(name: "Test", email: "test@example.com", password: "password123")
      expect(user).to be_valid
    end

    it "is invalid without a name" do
      user = User.new(email: "test@example.com", password: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "is invalid with a duplicate name" do
      User.create(name: "Test", email: "test1@example.com", password: "password123")
      user = User.new(name: "Test", email: "test2@example.com", password: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("has already been taken")
    end

    it "is invalid without an email" do
      user = User.new(name: "Test", password: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid with an invalid email format" do
      user = User.new(name: "Test", email: "invalid", password: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    it "is invalid with a duplicate email (case insensitive)" do
      User.create(name: "Test1", email: "TEST@example.com", password: "password123")
      user = User.new(name: "Test2", email: "test@example.com", password: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "is invalid with a password shorter than 6 characters" do
      user = User.new(name: "Test", email: "test@example.com", password: "pass")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end

  describe "associations" do
    it "has many values" do
      expect(User.reflect_on_association(:values).macro).to eq(:has_many)
    end
  end

  describe "remember_token" do
    it "creates a remember_token before saving" do
      user = User.create(name: "Test", email: "test@example.com", password: "password123")
      expect(user.remember_token).not_to be_nil
    end
  end
end