require 'spec_helper'

describe "Static pages" do
	
	subject { page }

    shared_examples_for "all static pages" do
        it { should have_selector('h1', text: heading) }
        it { should have_title(full_title(page_title)) }
    end
	
	describe "Home page" do
		before { visit root_path }
        let(:heading) { 'Приветствую, друзья!' }
        let(:page_title) { '' }

		it_should_behave_like "all static pages"
        it { should_not have_title('| Home') }
    end

    describe "Help page" do
    	before { visit help_path }
        let(:heading) { 'Помощь:' }
        let(:page_title) { '' }
    	
        it_should_behave_like "all static pages"
    end

    describe "About page" do
        before { visit about_path }
        let(:heading) { 'About Us :)' }
        let(:page_title) { '' }
    	
        it_should_behave_like "all static pages"
    end

    describe "Contact page" do
        before { visit contact_path }
        let(:heading) { 'Contact' }
        let(:page_title) { '' }

    	it_should_behave_like "all static pages"
    end

    it "should have the right links on the layout" do
        visit root_path
        click_link "About Us"
        expect(page).to have_title(full_title('About Us :)'))
        click_link "Помощь"
        expect(page).to have_title(full_title('Help'))
        click_link "Contact"
        expect(page).to have_title(full_title('Contact'))
        click_link "На главную"
        click_link "Создать аккаунт!"
        expect(page).to have_title(full_title('Sign up'))
        
    end
end