module ConfirmPrototyoeSupport
  def confirm_prototype(prototype)
    expect(current_path).to eq(prototype_path(prototype.id))
    expect(page).to have_content(prototype.title)
    expect(page).to have_content(prototype.catch_copy)
    expect(page).to have_content(prototype.concept)
  end
end