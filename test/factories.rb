
# Begin with the User class
  Factory.define :event do |e|
    # if we create multiple users, automatically add a incremented number
    # by using the sequence method since login must be unique
    #u.sequence(:login) { |n| "fred_#{n}" }   
	e.name "Something random"
	e.user_id "byee" # cause Brian's a guinea pig
    e.description "Some helpful description"  
    e.time Time.now + 2432425
	e.categories "1,2" #in at least 1 category but no more than 2
	e.flyer "something.jpg" # must have a flyer or a pattern
	e.pattern 1
  end