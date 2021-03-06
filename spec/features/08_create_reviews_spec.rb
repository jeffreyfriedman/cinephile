require "rails_helper"

feature "Create reviews user" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:movie1) { FactoryGirl.create(:movie) }
  let!(:movie2) { FactoryGirl.create(:movie) }
  let!(:review1) { FactoryGirl.create(:review, movie: movie1, user: user2) }

  before do
    user_sign_in(user)
  end

  scenario "user sees review form" do
    click_link movie1.title

    expect(page).to have_content("Write Review")
    expect(page).to have_content("Review Title")
    expect(page).to have_content("Review Body")
    expect(page).to have_content("Rating")
    expect(page).to have_button("Submit Review")
  end

  scenario "user succesfully submits review " do
    click_link movie1.title
    user_review(review1)

    expect(page).to have_content(review1.title)
    expect(page).to have_content(review1.body)
    expect(page).to have_content(review1.rating)
    expect(page).to have_content(movie1.title)
    expect(page).to_not have_content(movie2.title)
    expect(page).to have_content("Review Submitted!")
  end

  scenario "user unsuccessfully fills out review form" do
    click_link movie1.title
    click_button "Submit Review"

    expect(page).to have_content(movie1.title)
    expect(page).to_not have_content(movie2.title)
    expect(page).to have_content("Review failed to submit")
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Body must be at least 50 characters")
    expect(page).to have_content("Rating must be between 1 - 5")
  end

  scenario "user can only make one review per movie" do
    click_link movie1.title
    2.times do
      user_review(review1)
    end

    expect(page).to have_content(movie1.title)
    expect(page).to have_content("User can only submit one review per movie")
  end
end
