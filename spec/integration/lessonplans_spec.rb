# -*- coding: utf-8 -*-

require 'spec_helper'

describe "lessons related functions", type: :feature do


  context "create lessons" do


    context "without logging in" do

      before { visit "/lessonplans/new" }

      it "should redirect me to login page" do
        page.should have_content "登录"
      end
    end

    context "logged in" do

      let!(:user) { FactoryGirl.create(:publisher) }

      context "create a lessonplan" do

        before do
          login_as user
          page.should have_content "个人信息"
          visit "/lessonplans/new"
        end

        it "should visitable" do
          page.should have_content "教案介绍"
        end

        context "without tasks" do
          it "should create a new plan" do
            fill_in 'lessonplan_title', with: "This is a new plan"
            fill_in 'lessonplan_short_description', with: "This is a description isn't it?"
            fill_in 'lessonplan_content', with: "hmmm... It's a good editor, isn't it?"
            fill_in 'lessonplan_symbol_img_url', with: "placeholder.jpg"

            click_button "保存教案"

            page.should have_content "评论"
            page.should have_content "This is a new plan"
            page.should have_content "This is a description isn't it?"
            page.should have_content "hmmm... It's a good editor, isn't it?"
            page.should have_css 'img[src="placeholder.jpg"]'
          end
        end

        # There is a bug when creating tasks.
        context "with tasks" do
        end
      end
    end
  end

  context "edit a lessonplan" do

    let!(:user) { FactoryGirl.create(:publisher) }
    let!(:lessonplan) { FactoryGirl.create(:lessonplan, :publisher => user) }

    before do
      login_as user
      page.should have_content "个人信息"

      visit "/lessonplans/#{lessonplan.id}/edit"
    end

    it "should update lessonplan" do
      fill_in 'lessonplan_title', with: "This is a updated plan"
      fill_in 'lessonplan_short_description', with: "This is a updated description isn't it?"
      fill_in 'lessonplan_content', with: "This is a updated content"

      click_button '保存教案'

      page.should have_content("This is a updated plan")
      page.should have_content("This is a updated description isn't it?")
      page.should have_content("This is a updated content")
      page.should have_content("评论")
    end

  end


  context 'delete a lessonplan' do

    let!(:user) { FactoryGirl.create(:publisher) }
    let!(:lessonplan) { FactoryGirl.create(:lessonplan, :publisher => user) }

    before do
      login_as user
      page.should have_content "个人信息"

      visit "/lessonplans/#{lessonplan.id}"
    end

    it "should redirect to index" do
      click_link 'delete_button'

      page.should have_content('新的课堂，你来设计')
      page.should_not have_content(lessonplan.title)
    end

  end

end
