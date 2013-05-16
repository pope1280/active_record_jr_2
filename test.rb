require_relative 'app.rb'

# breanna = Student.where('first_name = ?', 'Breanna')
# p breanna.first[:first_name] == 'Breanna'

# new_student = Student.new(:cohort_id => 1, :first_name => 'Yolanda', :last_name => 'Polly', :email => 'polly_wog@gmail.com', :birthdate => '1998-05-12', :created_at => Time.now, :updated_at => Time.now)
# new_student.save

# p new_student[:id]

# # cohort = Cohort.where('name = ?', 'Alpha').first 

# # p cohort.students.count# == 227
# # p cohort.students.first[:email] == 'ayana.schuster@walker.org'

# cohort = Cohort.find(1)
# cohort[:name] = 'Best Cohort Ever'
# cohort.save

# # This re-queries the database, so we're checking that we actually
# # saved the data as intended
# p Cohort.find(1)[:name] == 'Best Cohort Ever'

# cohort = Cohort.where('name = ?', 'Best Cohort Ever').first 
# # p cohort.students.count == 236
# p cohort.students.first[:email] == 'ayana.schuster@walker.org'

# student500 = Student.find(500)

# p student500[:first_name] == "Nina"


# cohort4 = Cohort.find(4)

# p cohort4[:name] == "Gamma"

# cohort2 = Cohort.find(2)
# cohort2[:name] = 'Worst Cohort Ever'
# cohort2.save

# p Cohort.find(2)[:name] == 'Worst Cohort Ever'

# p Cohort.all('cohorts')

cohort = Cohort.where('name = ?', 'Best Cohort Ever').first 
p cohort.students.count 
p cohort.students.first[:email] == 'ayana.schuster@walker.org'
