require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment)
  end

  describe "コメント投稿" do
    context "投稿できる" do
      it "contentが入力されていれば投稿できる" do
        expect(@comment).to be_valid
      end
    end
    context "投稿できない" do
      it "contentが入力されていないと投稿できない" do
        @comment.content = ""
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Content can't be blank")
      end
    end
  end
end
