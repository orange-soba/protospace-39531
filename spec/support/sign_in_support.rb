module SignInSupport
  def sign_in(user)
    visit root_path
    click_on "ログイン"
    sleep 1
    fill_in "メールアドレス", with: @user.email
    fill_in "パスワード（6文字以上", with: @user.password
    find('input[name="commit"]').click
    sleep 1
    expect(current_path).to eq(root_path)
  end
end