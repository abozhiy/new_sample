require 'spec_helper'

describe "Authentication" do

	subject { page }

  describe "signin pages" do
    before { visit signin_path }

    it { should have_content('Авторизация пользователя:') }
    it { should have_title('Sign in') }
  end

  describe "signin" do

  	before { visit signin_path }

  	describe "with invalid information" do
  		before { click_button "Войти" }

  		it { should have_title('Sign in') }
  		it { should have_error_message('Неверная') }

      describe "after visiting another page" do
        before { click_link "На главную" }
        it { should_not have_error_message('Неверная') }
      end
  	end

  	describe "with valid information" do
  		let(:user) { FactoryGirl.create(:user) }
  		before { valid_signin(user) }

  		it { should have_title(user.name) }
      it { should have_link("Юзеры", href: users_path) }
  		it { should have_link("Моя страница", href: user_path(user)) }
      it { should have_link("Настройки", href: edit_user_path(user)) }
  		it { should have_link("Выйти", href: signout_path) }
  		it { should_not have_link("Войти", href: signin_path) }

      describe "followed by signout" do
        before { click_link "Выйти" }
        it { should have_link('Войти') }
      end
  	end
  end

  describe "autorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attemping to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Адрес эл. почты:", with: user.email
          fill_in "Пароль:", with: user.password
          click_button "Войти"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the User#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }
      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end
