require "spec_helper"

feature "Users can search for primers" do
  context "CSV contains a matching primer" do
    scenario "the results page shows only the matching primer" do
      visit "/"

      fill_in(
        "target",
        with: "ttaaaa"
      )
      fill_in(
        "target_container",
        with: "cacacattaaaacccccgtgtgt"
      )
      attach_file(
        "primer_csv",
        File.expand_path("spec/fixtures/primers.csv")
      )
      click_on "Find primers!"

      expect(page).to have_content("primer_1")
      expect(page).not_to have_content("primer_2")
    end
  end

  context "CSV doesn't contain a matching primer" do
    scenario "the results page reports no matches" do
      visit "/"

      fill_in(
        "target",
        with: "ttagga"
      )
      fill_in(
        "target_container",
        with: "cacacattaggacccccgtgtgt"
      )
      attach_file(
        "primer_csv",
        File.expand_path("spec/fixtures/primers.csv")
      )
      click_on "Find primers!"

      expect(page).to have_content("Couldn't match any of these primers.")
    end
  end
end
