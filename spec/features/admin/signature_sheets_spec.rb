require 'rails_helper'

feature 'Signature sheets' do

  background do
    admin = create(:administrator)
    login_as(admin.user)
  end

  scenario "Index" do
    3.times { create(:signature_sheet) }

    visit admin_signature_sheets_path

    expect(page).to have_css(".signature_sheet", count: 3)

    SignatureSheet.all.each do |signature_sheet|
      expect(page).to have_content signature_sheet.name
    end
  end

  scenario 'Create' do
    proposal = create(:proposal)
    visit new_admin_signature_sheet_path

    select "Citizen proposal", from: "signature_sheet_signable_type"
    fill_in "signature_sheet_signable_id", with: proposal.id
    fill_in "signature_sheet_document_numbers", with: "12345678Z, 99999999Z"
    click_button "Create signature sheet"

    expect(page).to have_content "Signature sheet created successfully"
  end

  scenario 'Errors on create' do
    visit new_admin_signature_sheet_path

    click_button "Create signature sheet"

    expect(page).to have_content error_message
  end

  scenario 'Show' do
    proposal = create(:proposal)
    user = Administrator.first.user
    signature_sheet = create(:signature_sheet,
                             signable: proposal,
                             document_numbers: "12345678Z, 123A, 123B",
                             author: user)
    signature_sheet.verify_signatures

    visit admin_signature_sheet_path(signature_sheet)

    expect(page).to have_content "Citizen proposal #{proposal.id}"
    expect(page).to have_content "12345678Z, 123A, 123B"
    expect(page).to have_content signature_sheet.created_at.strftime("%d %b %H:%M")
    expect(page).to have_content user.name

    within("#verified_signatures") do
      expect(page).to have_content 1
    end

    within("#unverified_signatures") do
      expect(page).to have_content 2
    end
  end

end