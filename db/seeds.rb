# db/seeds.rb

puts "Cleaning up existing data..."

Review.destroy_all
Step.destroy_all
Message.destroy_all

# 👇 THIS LINE MUST BE HERE 👇
UserSkill.destroy_all

# 2. Primary Records (Parents) must be destroyed last.

Chat.destroy_all
Recipe.destroy_all
Skill.destroy_all
User.destroy_all


# ---------------------------
# SKILLS
# ---------------------------
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
  description: "Develop the gluten structure for a perfect rise.",
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
  description: "Learn proper professional onion dicing technique.",
  video: "dice-onion.mp4",
  skill_level: 0
)

# --- NEW SKILLS ADDED ---

skill_julienne = Skill.create!(
  title: "Cutting Julienne",
  description: "Achieve the precise matchstick cut for vegetables.",
  video: "cutting-julienne.mp4",
  skill_level: 1
)

skill_brunoise = Skill.create!(
  title: "Cutting Brunoise",
  description: "Master the fine dice (tiny cubes) used for garnishes and aromatic bases.",
  video: "cutting_brunoise.mp4",
  skill_level: 2
)

skill_risotto = Skill.create!(
  title: "Cooking Risotto (Proper Stirring)",
  description: "Learn the technique of adding stock slowly while stirring to achieve creamy texture.",
  video: "cooking-risotto.mp4",
  skill_level: 2
)

skill_braise = Skill.create!(
  title: "Braising Meat",
  description: "Slow-cooking meat in liquid for maximum tenderness and flavor.",
  video: "braising-technique.mp4",
  skill_level: 1
)

skill_roux = Skill.create!(
  title: "Making a Basic Roux",
  description: "Combining butter and flour to create a thickening agent for sauces and soups.",
  video: "basic-roux.mp4",
  skill_level: 0
)

puts "Created #{Skill.count} skills."

# ---------------------------
# USERS
# ---------------------------
puts "Creating Users..."

# The primary user for testing review ownership and deletion
user = User.create!(
  email: "adam@lewagon.com",
  password: "password",
  username: "Adam"
)

# A secondary user for creating general reviews (to test non-owned reviews)
generic_user = User.create!(
  email: "generic@test.com",
  password: "password",
  username: "John Doe"
)

puts "Created #{User.count} users: #{user.email}, #{generic_user.email}"

# ---------------------------
# RECIPES + STEPS
# ---------------------------

puts "Creating Recipes and Steps..."

# The Recipe Author (if needed for moderation logic)
recipe_author = user

# ========= RECIPE 1: Fluffy Scrambled Eggs (Beginner) =========
recipe_1 = Recipe.create!(
  title: "Fluffy Scrambled Eggs",
  description: "A quick and easy classic, perfect for breakfast.",
  ingredients: { "eggs": "2 large", "butter": "5 g", "milk": "15 ml", "salt_pepper": "to taste" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 10 # ADDED PREP TIME
)
Step.create!(title: "Crack Eggs", content: "Whisk eggs, milk, salt, and pepper.", recipe: recipe_1)
Step.create!(title: "Melt Butter", content: "Melt butter on medium heat.", recipe: recipe_1)
Step.create!(title: "Cook Eggs", content: "Stir until soft curds form.", recipe: recipe_1)


# ========= RECIPE 2: Roasted Tomato Soup (Beginner) =========
recipe_2 = Recipe.create!(
  title: "Roasted Tomato Soup",
  description: "A comforting soup with deep roasted flavor.",
  ingredients: { "tomatoes": "1 kg", "onion": "200 g", "garlic": "4 cloves", "vegetable_broth": "1 L" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 45 # ADDED PREP TIME
)
Step.create!(title: "Prep Veggies", content: "Chop vegetables and toss with oil.", recipe: recipe_2, skill: skill_onion_dice)
Step.create!(title: "Roast Veggies", content: "Roast 30 minutes at 200°C.", recipe: recipe_2)
Step.create!(title: "Simmer Soup", content: "Add broth and simmer 10 minutes.", recipe: recipe_2)
Step.create!(title: "Blend Soup", content: "Blend until smooth.", recipe: recipe_2)


# ========= RECIPE 3: Creamy Chicken Alfredo (Intermediate) =========
recipe_3 = Recipe.create!(
  title: "Creamy Chicken Alfredo",
  description: "Fettuccine pasta in a rich cream sauce.",
  ingredients: { "fettuccine": "225 g", "chicken_breast": "450 g", "heavy_cream": "250 ml", "parmesan": "50 g" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 30 # ADDED PREP TIME
)
Step.create!(title: "Cook Chicken", content: "Cook chicken to safe temperature.", recipe: recipe_3, skill: skill_temp)
Step.create!(title: "Cook Pasta", content: "Boil pasta until al dente.", recipe: recipe_3)
Step.create!(title: "Make Sauce", content: "Combine cream, butter, cheese.", recipe: recipe_3, skill: skill_sauce)
Step.create!(title: "Combine All", content: "Mix pasta with sauce.", recipe: recipe_3)


# ========= RECIPE 4: Rustic Sourdough Loaf (Expert) =========
recipe_4 = Recipe.create!(
  title: "Rustic Sourdough Loaf",
  description: "A crusty, tangy bread requiring patience.",
  ingredients: { "sourdough_starter": "250 g", "bread_flour": "500 g", "water": "350 ml", "salt": "10 g" },
  recipe_level: 2,
  user: recipe_author,
  meal_prep_time: 180 # ADDED PREP TIME (mostly inactive time)
)
Step.create!(title: "Mix Dough", content: "Combine starter, flour, water.", recipe: recipe_4)
Step.create!(title: "Knead Dough", content: "Knead until elastic.", recipe: recipe_4, skill: skill_bread)
Step.create!(title: "Proof Overnight", content: "Rest overnight.", recipe: recipe_4)
Step.create!(title: "Bake Bread", content: "Bake in Dutch oven.", recipe: recipe_4)


# ========= RECIPE 5: Fresh Lemon Vinaigrette (Intermediate) =========
recipe_5 = Recipe.create!(
  title: "Fresh Lemon Vinaigrette",
  description: "A bright, zesty salad dressing.",
  ingredients: { "olive_oil": "125 ml", "lemon_juice": "60 ml", "dijon_mustard": "5 ml", "salt_pepper": "to taste" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 15 # ADDED PREP TIME
)
Step.create!(title: "Combine Base", content: "Mix lemon, mustard, salt, pepper.", recipe: recipe_5)
Step.create!(title: "Whisk In Oil", content: "Emulsify the dressing.", recipe: recipe_5, skill: skill_whisk)
Step.create!(title: "Serve", content: "Adjust seasoning.", recipe: recipe_5)


# ========= RECIPE 6: Spicy Chickpea Curry (Intermediate) =========
recipe_6 = Recipe.create!(
  title: "Spicy Chickpea Curry",
  description: "A warming curry packed with bold spices.",
  ingredients: { "chickpeas": "400 g", "onion": "1", "garlic": "3 cloves", "ginger": "1 tbsp", "coconut_milk": "200 ml" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 35 # ADDED PREP TIME
)
Step.create!(title: "Dice Aromatics", content: "Prep onion, garlic, ginger.", recipe: recipe_6, skill: skill_onion_dice)
Step.create!(title: "Cook Base", content: "Sauté aromatics.", recipe: recipe_6)
Step.create!(title: "Simmer Curry", content: "Add chickpeas, coconut milk.", recipe: recipe_6)


# ========= RECIPE 7: Crispy Pan-Fried Salmon (Intermediate) =========
recipe_7 = Recipe.create!(
  title: "Crispy Pan-Fried Salmon",
  description: "A simple salmon dish with a perfect crust.",
  ingredients: { "salmon": "2 fillets", "lemon": "1", "oil": "1 tbsp" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 20 # ADDED PREP TIME
)
Step.create!(title: "Season Salmon", content: "Season well.", recipe: recipe_7)
Step.create!(title: "Sear Fish", content: "Cook skin side down.", recipe: recipe_7)
Step.create!(title: "Finish", content: "Add lemon.", recipe: recipe_7)


# ========= RECIPE 8: Garlic Butter Shrimp Pasta (Beginner) =========
recipe_8 = Recipe.create!(
  title: "Garlic Butter Shrimp Pasta",
  description: "A quick 15-minute pasta loaded with garlic.",
  ingredients: { "spaghetti": "200 g", "shrimp": "250 g", "garlic": "4 cloves" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 15 # ADDED PREP TIME
)
Step.create!(title: "Boil Pasta", content: "Cook spaghetti.", recipe: recipe_8)
Step.create!(title: "Cook Shrimp", content: "Sauté shrimp.", recipe: recipe_8)
Step.create!(title: "Combine", content: "Mix everything together.", recipe: recipe_8)


# ========= RECIPE 9: Vegetable Stir-Fry (Beginner) =========
recipe_9 = Recipe.create!(
  title: "Vegetable Stir-Fry",
  description: "A vibrant stir-fry with savory sauce.",
  ingredients: { "broccoli": "200 g", "carrots": "2", "bell_pepper": "1" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 25 # ADDED PREP TIME
)
Step.create!(title: "Prep Veg", content: "Chop all vegetables.", recipe: recipe_9, skill: skill_knife)
Step.create!(title: "Stir Fry", content: "Cook quickly on high heat.", recipe: recipe_9)
Step.create!(title: "Add Sauce", content: "Add soy glaze.", recipe: recipe_9)


# ========= RECIPE 10: Slow-Cooked Beef Stew (Expert) =========
recipe_10 = Recipe.create!(
  title: "Slow-Cooked Beef Stew",
  description: "A rich stew simmered for hours.",
  ingredients: { "beef": "500 g", "potatoes": "3", "carrots": "2" },
  recipe_level: 2,
  user: recipe_author,
  meal_prep_time: 210 # ADDED PREP TIME (mostly slow cook time)
)
Step.create!(title: "Brown Beef", content: "Sear beef.", recipe: recipe_10)
Step.create!(title: "Prep Vegetables", content: "Cut everything.", recipe: recipe_10, skill: skill_knife)
Step.create!(title: "Slow Cook", content: "Cook 3 hours.", recipe: recipe_10)


# ========= RECIPE 11: Avocado Toast Deluxe (Beginner) =========
recipe_11 = Recipe.create!(
  title: "Avocado Toast Deluxe",
  description: "Creamy avocado toast with chili flakes.",
  ingredients: { "bread": "2 slices", "avocado": "1" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 5 # ADDED PREP TIME
)
Step.create!(title: "Toast Bread", content: "Toast slices.", recipe: recipe_11)
Step.create!(title: "Mash Avocado", content: "Mash until creamy.", recipe: recipe_11)
Step.create!(title: "Assemble", content: "Layer everything.", recipe: recipe_11)


# ========= RECIPE 12: Homemade Pancakes (Beginner) =========
recipe_12 = Recipe.create!(
  title: "Homemade Pancakes",
  description: "Fluffy pancakes perfect for weekends.",
  ingredients: { "flour": "200 g", "milk": "250 ml", "egg": "1" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 20 # ADDED PREP TIME
)
Step.create!(title: "Mix Batter", content: "Whisk ingredients.", recipe: recipe_12)
Step.create!(title: "Heat Pan", content: "Melt butter.", recipe: recipe_12)
Step.create!(title: "Cook Cakes", content: "Flip when bubbly.", recipe: recipe_12)


puts "Created #{Recipe.count} recipes with #{Step.count} steps."


# ---------------------------------------
# REVIEWS
# ---------------------------------------

puts "Creating Reviews..."

REVIEW_TITLES = [
  "Amazing!", "Loved it!", "Pretty good",
  "Needs improvement", "Not bad", "Delicious!",
  "Would cook again", "A bit bland", "Great flavor",
  "Too complicated", "Perfect for beginners",
  "Total comfort food",
  "Presentation challenge"
]

REVIEW_COMMENTS = [
  "Turned out fantastic!",
  "The instructions were super clear.",
  "My family loved it!",
  "Not my favorite, but decent.",
  "Could use more spice.",
  "Would tweak a few things next time.",
  "Super easy to follow.",
  "Tasted great but took longer than expected.",
  "Really fun to make!",
  "Could use more flavor.",
  "The sauce was amazing!",
  "Needed more detail on plating the final dish.",
  "Warm and satisfying, perfect for a cold evening."
]

def create_recipe_reviews(recipe, user, generic_user)
  rand(3..7).times do
    # Randomly assign author between the two users
    reviewer = [user, generic_user].sample

    Review.create!(
      title: REVIEW_TITLES.sample,
      comment: REVIEW_COMMENTS.sample,
      rate: rand(1..5),
      recipe: recipe,
      user: reviewer
    )
  end
end

# Create random reviews for all recipes, authored by either user or generic_user
[recipe_1, recipe_2, recipe_3, recipe_4, recipe_5,
 recipe_6, recipe_7, recipe_8, recipe_9, recipe_10,
 recipe_11, recipe_12].each do |rec|
  create_recipe_reviews(rec, user, generic_user)
end

# Force recipe_9 (Stir-Fry) to have specific low reviews owned by the main user
3.times do
  Review.create!(
    title: "Terrible",
    comment: "Really bland and disappointing.",
    rate: 1,
    recipe: recipe_9,
    user: user # Main user owns these for easy testing of the delete button
  )
end

# Force recipe_12 (Pancakes) to have specific high reviews owned by the main user
3.times do
  Review.create!(
    title: "Best ever!",
    comment: "Perfect pancakes every time!",
    rate: 5,
    recipe: recipe_12,
    user: user # Main user owns these for easy testing of the delete button
  )
end

puts "Created #{Review.count} total reviews."


# ---------------------------
# CHAT + MESSAGES
# ---------------------------

puts "Creating Chat and Messages..."

chat = Chat.create!(user: user, title: "Botifarra Ideas")

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

Badge.destroy_all

Badge.create!([
  {
    name: "Beginner Recipes",
    rule_key: "recipe_beginner",
    description: "Earned by completing Beginner-level recipes."
  },
  {
    name: "Intermediate Recipes",
    rule_key: "recipe_intermediate",
    description: "Earned by mastering Intermediate-level recipes."
  },
  {
    name: "Expert Recipes",
    rule_key: "recipe_expert",
    description: "Awarded for finishing challenging Expert-level recipes."
  },
  {
    name: "Saved Recipes",
    rule_key: "saved_recipes",
    description: "Earned by saving many recipes to your cookbook."
  },
  {
    name: "Skills Completed",
    rule_key: "skills_completed",
    description: "Unlocked by learning different cooking skills."
  },
  {
    name: "Consistency",
    rule_key: "streak",
    description: "Earned by being consistently active day after day."
  }
])
