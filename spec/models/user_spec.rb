require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe "ユーザー新規登録" do
    context "新規登録できる時" do
      it "すべての情報が適切に入力されていれば新規登録できる" do
        expect(@user).to be_valid
      end
    end
    context "新規登録できない時" do
      it "emailが空だと登録できない" do
        @user.email = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      it "同じemailが登録されていると新規登録できない" do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include("Email has already been taken")
      end
      it "emailに@が含まれていないと登録できない" do
        @user.email = "test.email.com"
        @user.valid?
        expect(@user.errors.full_messages).to include("Email is invalid")
      end
      it "passwordが空だと登録できない" do
        @user.password = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end
      it "passwordが5文字以下だと登録できない" do
        @user.password = "pass"
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      end
      it "password_confirmationが空だと登録できない" do
        @user.password_confirmation = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it "passwordとpassword_confirmatinoが一致しないと登録できない" do
        @user.password = "password"
        @user.password_confirmation = "testpass"
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it "nameが空だと登録できない" do
        @user.name = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Name can't be blank")
      end
      it "profileが空だと登録できない" do
        @user.profile = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Profile can't be blank")
      end
      it "occupationが空だと登録できない" do
        @user.occupation = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Occupation can't be blank")
      end
      it "positionが空だと登録できない" do
        @user.position = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Position can't be blank")
      end
    end
  end
end
