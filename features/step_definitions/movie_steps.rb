# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  Movie.destroy_all
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    m = Movie.new(movie)
    m.save
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  page_body = page.body.to_s
  if page_body.index(e1) && page_body.index(e2)
    page_body.index(e1) < page_body.index(e2)? true: false
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(",")
  ratings.each do |rating|
    if uncheck
      uncheck "ratings_#{rating.strip}"
    else
      check "ratings_#{rating.strip}"
    end
  end
end

def table_cell(content)
  /.*<td>#{content}<\/td>.*/m
end
Then /I should see ratings: (.*)/ do |rating_list|
  ratings = rating_list.split(",")
  ratings.each do |rating|
    page.body.should match table_cell(rating.strip)
  end
end

Then /I should not see ratings: (.*)/ do |rating_list|
  ratings = rating_list.split(",")
  ratings.each do |rating|
    page.body.should_not match table_cell(rating.strip)
  end
end

Then /I should see all of the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |movie|
    page.body.should match table_cell(movie.title)
  end
end
