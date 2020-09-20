# Add a declarative step here for populating the DB with movies.

Given (/^the following movies exist:$/) do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then (/^(.*) seed movies should exist$/) do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then (/^I should see "(.*)" before "(.*)"$/) do |e1, e2|
  expect(page).to have_content(e1 && e2)
  index_of_e1 = page.body.index(e1)
  index_of_e2 = page.body.index(e2)
  index_of_e1.should be < index_of_e2
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When (/^I (un)?check the following ratings: (.*)$/) do |uncheck, rating_list|
  ratings = rating_list.split(",")
  if(uncheck == "un") then
    ratings.each do |rating|
      step "I uncheck \"ratings[#{rating}]\""
    end
  else
    ratings.each do |rating|
      step "I check \"ratings[#{rating}]\""
    end
  end
end

Then(/^I should see all of the movies$/) do
  # subtract one because otherwise the row with the headings 
  # (Movie Title, Rating, Release Date, More Info) will also be included
  number_of_rows = page.all('table#movies tr').count - 1
  expect(number_of_rows).to eq 10
end
