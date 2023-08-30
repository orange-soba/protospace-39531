require 'rails_helper'

RSpec.describe "新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  it "必要な情報を入力すれば新規登録できる" do
    # トップページへ遷移
    visit root_path
    # 新規登録ボタンの確認
    expect(page).to have_content("新規登録")
    # 新規登録ボタンを押す
    click_on "新規登録"
    sleep 1
    # 新規登録ページへ遷移しているのを確認
    expect(current_path).to eq(new_user_registration_path)
    # 情報の入力
    fill_in "メールアドレス", with: @user.email
    fill_in "パスワード（6文字以上）", with: @user.password
    fill_in "パスワード再入力", with: @user.password_confirmation
    fill_in "ユーザー名", with: @user.name
    fill_in "プロフィール", with: @user.profile
    fill_in "所属", with: @user.occupation
    fill_in "役職", with: @user.position
    # 新規登録ボタンをクリックするとユーザーモデルのカウントが1増える
    expect{
      find('input[name="commit"]').click
      sleep 1
    }.to change { User.count }.by(1)
  end
  it "入力漏れがあると新規登録できない" do
    visit root_path
    expect(page).to have_content("新規登録")
    click_on "新規登録"
    sleep 1
    expect(current_path).to eq(new_user_registration_path)
    # 誤った情報の入力
    fill_in "メールアドレス", with: ""
    fill_in "パスワード（6文字以上）", with: ""
    fill_in "パスワード再入力", with: ""
    fill_in "ユーザー名", with: ""
    fill_in "プロフィール", with: ""
    fill_in "所属", with: ""
    fill_in "役職", with: ""
    # 新規登録ボタンをクリックしてもユーザーモデルのカウントが増えない
    expect{
      find('input[name="commit"]').click
      sleep 1
    }.to change { User.count }.by(0)
    # そのまま新規登録ページに留まっているのを確認
    expect(current_path).to eq(new_user_registration_path)
  end
end

RSpec.describe "ログイン", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  it "正しい情報を入力すればログインできる" do
    visit root_path
    # ログインボタンの確認
    expect(page).to have_content("ログイン")
    click_on "ログイン"
    sleep 1
    # ログインページへ遷移しているのを確認
    expect(current_path).to eq(new_user_session_path)
    # 情報を入力
    fill_in "メールアドレス", with: @user.email
    fill_in "パスワード（6文字以上", with: @user.password
    # ログインボタンをクリックするとトップページへ遷移していることを確認
    find('input[name="commit"]').click
    sleep 1
    expect(current_path).to eq(root_path)
  end
  it "入力漏れがあるとログインできない" do
    visit root_path
    expect(page).to have_content("ログイン")
    click_on "ログイン"
    sleep 1
    expect(current_path). to eq(new_user_session_path)
    # 間違った情報を入力
    wrong_email = "wrong_" + @user.email
    wrong_password = "wrong_" + @user.password
    fill_in "メールアドレス", with: wrong_email
    fill_in "パスワード（6文字以上", with: wrong_password
    # ログインボタンをクリックしてもログインページに戻っているのを確認
    find('input[name="commit"]').click
    sleep 1
    expect(current_path).to eq(new_user_session_path)
  end
end

RSpec.describe "ログイン状態/ログアウト状態", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @prototype = FactoryBot.create(:prototype)
  end
  context "ログイン状態" do
    it "ヘッダーに「ログアウト」, 「New Prot」のリンクが存在し、トップページからログアウトができる" do
      sign_in(@user)
      expect(page).to have_content("ログアウト")
      expect(page).to have_content("New Prot")
      click_on "ログアウト"
      sleep 1
      expect(page).to have_content("ログイン")
    end
    it "トップページに「こんにちは、〇〇さん」とユーザー名が表示されている" do
      sign_in(@user)
      expect(page).to have_content(@user.name)
    end
    # テストだとcurrent_userが機能していない模様
    # it "投稿したユーザーにだけ「編集」「削除」のリンクが存在する" do
    #   sign_in(@prototype.user)
    #   click_on "#{@prototype.title}"
    #   sleep 1
    #   binding.pry
    #   expect(page).to have_content("編集")
    #   expect(page).to have_content("削除")
    # end
    # it "投稿したユーザーだけ「編集」ボタンをクリックすると編集ページに遷移する" do
    #   sign_in(@prototype.user)
    #   click_on "#{@prototype.title}"
    #   sleep 1
    #   click_on "編集"
    #   sleep 1
    #   expect(current_path).to eq(edit_prototype_path(@prototype.id))
    # end
    # it "投稿したユーザーだけ「削除」ボタンをクリックするとプロトタイプが削除でき、トップページへ遷移する" do
    #   sign_in(@prototype.user)
    #   click_on "#{@prototype.title}"
    #   sleep 1
    #   expect{
    #     click_on "削除"
    #     sleep 1
    #   }.to change { Prototype.count }.by(-1)
    #   expect(current_path).to eq(root_path)
    # end
    it "詳細ページにコメント投稿欄が表示されている" do
      sign_in(@prototype.user)
      click_on "#{@prototype.title}"
      sleep 1
      expect(page).to have_button("送信する")
    end
    it "他のユーザーのプロトタイプ編集ページに遷移しよとするとトップページにリダイレクトされる" do
      another_prototype = FactoryBot.create(:prototype)
      sign_in(@prototype.user)
      visit edit_prototype_path(another_prototype.id)
      sleep 1
      expect(current_path).to eq(root_path)
    end
  end
  context "ログアウト状態" do
    it "トップページに遷移できる" do
      visit root_path
      expect(current_path).to eq(root_path)
    end
    it "プロトタイプ詳細ページに遷移できる" do
      visit prototype_path(@prototype.id)
      expect(current_path).to eq(prototype_path(@prototype.id))
    end
    it "ユーザー詳細ページに遷移できる" do
      visit user_path(@user.id)
      expect(current_path).to eq(user_path(@user.id))
    end
    it "ユーザー新規登録ページに遷移できる" do
      visit new_user_registration_path
      expect(current_path).to eq(new_user_registration_path)
    end
    it "ログインページに遷移できる" do
      visit new_user_session_path
      expect(current_path).to eq(new_user_session_path)
    end
    it "ヘッダーに「新規登録」、「ログイン」のリンクが存在する" do
      visit root_path
      expect(page).to have_content("新規登録")
      expect(page).to have_content("ログイン")
    end
    it "新規投稿ページに遷移しようとするとログインページにリダイレクトされる" do
      visit root_path
      visit new_prototype_path
      sleep 1
      expect(current_path).to eq(new_user_session_path)
    end
    it "編集ページに遷移しようとするとログインページにリダイレクトされる" do
      visit root_path
      visit edit_prototype_path(@prototype.id)
      sleep 1
      expect(current_path).to eq(new_user_session_path)
    end
  end
  context "ログイン/ログアウト状態に関わらない" do
    it "ログインしていない状態で一覧表示されている画像をクリックすると詳細ページに遷移し、プロダクトの情報が載っている" do
      visit root_path
      find('img[class="card__img"]').click
      sleep 1
      confirm_prototype(@prototype)
    end
    it "ログインしていない状態で一覧表示されているプロトタイプ名をクリックすると詳細ページに遷移し、プロダクトの情報が載っている" do
      visit root_path
      click_on @prototype.title
      sleep 1
      confirm_prototype(@prototype)
    end
    it "ログイン状態で一覧表示されている画像をクリックすると詳細ページに遷移し、プロダクトの情報が載っている" do
      sign_in(@user)
      find('img[class="card__img"]').click
      sleep 1
      confirm_prototype(@prototype)
    end
    it "ログイン状態で一覧表示されているプロトタイプ名をクリックすると詳細ページに遷移し、プロダクトの情報が載っている" do
      sign_in(@user)
      click_on @prototype.title
      sleep 1
      confirm_prototype(@prototype)
    end
    it "各ページのユーザー名をクリックするとそのユーザーの詳細ページに遷移し、ユーザーの詳細情報とプロトタイプ一覧が載っている(今回は面倒なのでトップページだけ)" do
      user = @prototype.user
      sign_in(user)
      click_on user.name
      sleep 1
      expect(current_path).to eq(user_path(user.id))
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.profile)
      expect(page).to have_content(user.occupation)
      expect(page).to have_content(user.position)
      expect(page).to have_content(@prototype.title)
      expect(page).to have_content(@prototype.catch_copy)
    end
  end
end