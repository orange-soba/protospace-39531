require 'rails_helper'

RSpec.describe Prototype, type: :model do
  before do
    @prototype = FactoryBot.build(:prototype)
  end

  describe "プロトタイプ投稿" do
    context "投稿できる" do
      it "必要な情報がすべて入力されていれば投稿できる" do
        expect(@prototype).to be_valid
      end
    end
    context "投稿できない" do
      it "titleが体と投稿できない" do
        @prototype.title = ""
        @prototype.valid?
        expect(@prototype.errors.full_messages).to include("Title can't be blank")
      end
      it "catch_copyが空だと投稿できない" do
        @prototype.catch_copy = ""
        @prototype.valid?
        expect(@prototype.errors.full_messages).to include("Catch copy can't be blank")
      end
      it "conceptが空だと投稿できない" do
        @prototype.concept = ""
        @prototype.valid?
        expect(@prototype.errors.full_messages).to include("Concept can't be blank")
      end
      it "imageが空だと投稿できない" do
        @prototype.image = nil
        @prototype.valid?
        expect(@prototype.errors.full_messages).to include("Image can't be blank")
      end
    end
  end
end
