# db/seeds.rb

puts "Cleaning up existing data..."
Review.destroy_all
Step.destroy_all
Recipe.destroy_all
Skill.destroy_all
User.destroy_all

puts "Creating Skills..."

skill_knife = Skill.create!(
  title: "Basic Knife Skills",
  description: "Learn the proper grip and basic cuts like chop, dice, and mince.",
  video: "dice-chop-mince.mp4",
  skill_level: 0
)

skill_sauce = Skill.create!(
  title: "Making Béchamel Sauce",
  description: "Master the classic French white sauce by creating a roux.",
  video: "bechamel.mp4",
  skill_level: 1
)

skill_bread = Skill.create!(
  title: "Kneading and Proofing Dough",
  description: "Develop the gluten structure in bread dough for a perfect rise.",
  video: "dough-preparation.mp4",
  skill_level: 2
)

skill_temp = Skill.create!(
  title: "Checking Meat Internal Temperature",
  description: "Use a thermometer to ensure meat is cooked properly.",
  video: "meat-temperature.mp4",
  skill_level: 0
)

skill_whisk = Skill.create!(
  title: "Emulsifying Vinaigrette",
  description: "Create a stable, creamy dressing from oil and vinegar.",
  video: "emulsified-vinaigrette.mp4",
  skill_level: 1
)

skill_onion_dice = Skill.create!(
  title: "Dicing an Onion",
  description: "Learn the correct knife technique for dicing an onion.",
  video: "dice-onion.mp4",
  skill_level: 0
)

puts "Created #{Skill.count} skills."

# ---------------------------
# USER
# ---------------------------
puts "Creating User..."

user = User.create!(
  email: "tester@test.com",
  password: "password",
  username: "test_user"
)

puts "Created User: #{user.email}"

# ---------------------------
# RECIPES + STEPS
# ---------------------------
puts "Creating Recipes and Steps..."

# ========== RECIPE 1 ==========
recipe_1 = Recipe.create!(
  title: "Fluffy Scrambled Eggs",
  description: "A quick and easy classic, perfect for breakfast.",
  ingredients: {
    "eggs": "2 large",
    "butter": "5 g",
    "milk": "15 ml",
    "salt_pepper": "to taste"
  },
  recipe_level: 0
)

Step.create!(title: "Crack Eggs", content: "Whisk eggs, milk, salt, and pepper.", recipe: recipe_1)
Step.create!(title: "Melt Butter", content: "Melt butter on medium heat.", recipe: recipe_1)
Step.create!(title: "Cook Eggs", content: "Stir until soft curds form.", recipe: recipe_1)

# ========== RECIPE 2 ==========
recipe_2 = Recipe.create!(
  title: "Roasted Tomato Soup",
  description: "A comforting soup with deep roasted flavor.",
  ingredients: {
    "tomatoes": "1 kg",
    "onion": "200 g",
    "garlic": "4 cloves",
    "vegetable_broth": "1 L"
  },
  recipe_level: 0
)

Step.create!(title: "Prep Veggies", content: "Chop vegetables and toss with oil.", recipe: recipe_2, skill: skill_onion_dice)
Step.create!(title: "Roast", content: "Roast for 30 minutes at 200°C.", recipe: recipe_2)
Step.create!(title: "Simmer", content: "Add broth and simmer 10 minutes.", recipe: recipe_2)
Step.create!(title: "Blend", content: "Blend until smooth.", recipe: recipe_2)

# ========== RECIPE 3 ==========
recipe_3 = Recipe.create!(
  title: "Creamy Chicken Alfredo",
  description: "Fettuccine pasta in a rich cream sauce.",
  ingredients: {
    "fettuccine": "225 g",
    "chicken_breast": "450 g",
    "heavy_cream": "250 ml",
    "parmesan": "50 g"
  },
  recipe_level: 1
)

Step.create!(title: "Cook Chicken", content: "Cook chicken to safe temperature.", recipe: recipe_3, skill: skill_temp)
Step.create!(title: "Cook Pasta", content: "Boil pasta until al dente.", recipe: recipe_3)
Step.create!(title: "Make Sauce", content: "Combine butter, cream, cheese.", recipe: recipe_3, skill: skill_sauce)
Step.create!(title: "Combine", content: "Mix pasta and sauce.", recipe: recipe_3)

# ========== RECIPE 4 ==========
recipe_4 = Recipe.create!(
  title: "Rustic Sourdough Loaf",
  description: "A crusty, tangy bread requiring patience.",
  ingredients: {
    "sourdough_starter": "250 g",
    "bread_flour": "500 g",
    "water": "350 ml",
    "salt": "10 g"
  },
  recipe_level: 2
)

Step.create!(title: "Mix Dough", content: "Combine ingredients.", recipe: recipe_4)
Step.create!(title: "Knead Dough", content: "Knead until windowpane test passes.", recipe: recipe_4, skill: skill_bread)
Step.create!(title: "Proof", content: "Shape and proof overnight.", recipe: recipe_4)
Step.create!(title: "Bake", content: "Bake in Dutch oven.", recipe: recipe_4)

# ========== RECIPE 5 ==========
recipe_5 = Recipe.create!(
  title: "Fresh Lemon Vinaigrette",
  description: "A bright, zesty salad dressing.",
  ingredients: {
    "olive_oil": "125 ml",
    "lemon_juice": "60 ml",
    "dijon_mustard": "5 ml",
    "salt_pepper": "to taste"
  },
  recipe_level: 1
)

Step.create!(title: "Combine Ingredients", content: "Mix lemon, mustard, salt, pepper.", recipe: recipe_5)
Step.create!(title: "Emulsify", content: "Slowly whisk in oil.", recipe: recipe_5, skill: skill_whisk)
Step.create!(title: "Serve", content: "Adjust seasoning.", recipe: recipe_5)

puts "Created #{Recipe.count} recipes with #{Step.count} steps."

# ---------------------------
# CREATE RANDOM REVIEWS
# ---------------------------
puts "Creating Reviews..."

REVIEW_TITLES = [
  "Amazing!", "Loved it!", "Pretty good",
  "Needs improvement", "Not bad", "Delicious!",
  "Would cook again", "A bit bland", "Great flavor",
  "Too complicated", "Perfect for beginners"
]

REVIEW_COMMENTS = [
  "Turned out fantastic!",
  "The instructions were super clear.",
  "My family loved it!",
  "Not my favorite, but decent.",
  "I added more seasoning and it was perfect.",
  "Would tweak a few things next time.",
  "Super easy to follow.",
  "Tasted great but took longer than expected.",
  "Really fun to make.",
  "Could use more flavor.",
  "The sauce was amazing!"
]

def create_recipe_reviews(recipe)
  puts "  -> Creating reviews for: #{recipe.title}"

  rand(2..7).times do
    Review.create!(
      title: REVIEW_TITLES.sample,
      comment: REVIEW_COMMENTS.sample,
      rate: rand(1..5),
      recipe: recipe
    )
  end
end

[recipe_1, recipe_2, recipe_3, recipe_4, recipe_5].each do |rec|
  create_recipe_reviews(rec)
end

puts "Created #{Review.count} total reviews."

# ---------------------------
# CHAT + MESSAGES
# ---------------------------
puts "Creating Chat and Messages..."

chat = Chat.create!(user: user, title: "Botifara Ideas")

first_message = Message.create!(
  chat: chat,
  role: "user",
  content: "I have carrots, beetroot, and botifarra. What can I cook?"
)

Message.create!(
  chat: chat,
  role: "ai",
  content: "Here are 5 recipe ideas using those ingredients!"
)

puts "Seed data successfully created!"
