# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)#:title => movie[0], :release_date => movie[1], :rating => movie[2])
  end
  #flunk "Unimplemented"
end

When /^I press (.*)$/ do |pressed|
        click_button(pressed)
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  values = all("table#movies tbody tr").collect { 
                |row| 
                row.all("td")[0].text 
        }
   e1Pos = values.find_index(e1)
   e2Pos = values.find_index(e2)
   assert e1Pos<e2Pos
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Given /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(", ").each do |rating|
    step %{I #{uncheck}check "ratings_#{rating}"}
  end
end

Then /I should(n't)? see: (.*)/ do |not_present, title_list|
  title_list.split(", ").each do |title|
    if page.respond_to? :should
      if not_present then
        page.should_not have_content(title)
      else
        page.should have_content(title)
      end
    else
      if not_present then
        assert page.has_content?(title) == false
      else
        assert page.has_content?(title)
      end
    end
  end
end

Then /I should see no movies/ do
  rows = all("table#movies tbody tr").count
  rows.should == 0  
end

Then /I should see all of the movies/ do
  rows = all("table#movies tbody tr").count
  rows.should == 10  
end
