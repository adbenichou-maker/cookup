# db/seeds.rb

# --- 1. Clean up existing data ---
puts "Cleaning up existing data..."
Step.destroy_all
Recipe.destroy_all
Skill.destroy_all
User.destroy_all # Assuming a 'users' table exists.

# --- 2. Create Skills ---
puts "Creating Skills..."

skill_knife = Skill.create!(
  title: "Basic Knife Skills",
  description: "Learn the proper grip and basic cuts like chop, dice, and mince.",
  video: "dice-chop-mince.mp4",
  skill_level: 0 # beginner
)

skill_sauce = Skill.create!(
  title: "Making Béchamel Sauce",
  description: "Master the classic French white sauce by creating a roux.",
  video: "bechamel.mp4",
  skill_level: 1 # intermediate
)

skill_bread = Skill.create!(
  title: "Kneading and Proofing Dough",
  description: "Develop the gluten structure in bread dough for a perfect rise.",
  video: "dough-preparation.mp4",
  skill_level: 2 # expert
)

skill_temp = Skill.create!(
  title: "Checking Meat Internal Temperature",
  description: "Use a thermometer to ensure meat is cooked to safe and desired doneness.",
  video: "meat-temperature.mp4",
  skill_level: 0 # beginner
)

skill_whisk = Skill.create!(
  title: "Emulsifying Vinaigrette",
  description: "Combine oil and vinegar to create a stable, creamy dressing.",
  video: "emulsified-vinaigrette.mp4",
  skill_level: 1 # intermediate
)

# New Skill Added
skill_onion_dice = Skill.create!(
    title: "Dicing an Onion",
    description: "Learn the professional technique for uniformly dicing an onion quickly and safely.",
    video: "dice-onion.mp4",
    skill_level: 0 # beginner
)

skills = [skill_knife, skill_sauce, skill_bread, skill_temp, skill_whisk, skill_onion_dice]
puts "Created #{Skill.count} skills."

# --- 3. Create a User (Placeholder) ---
# Assuming a User model/table exists for recipe ownership.
puts "Creating a User..."
user = User.create!(
    email: "tester@test.com",
    password: "password",
    username: "test_user"
    # Add other necessary user attributes here
)

puts "Created User: #{user.email}"

# --- 4. Create Recipes and Steps ---
puts "Creating Recipes and Steps..."

# Recipe 1: Simple Scrambled Eggs (Beginner)
recipe_1 = Recipe.create!(
  title: "Fluffy Scrambled Eggs",
  description: "A quick and easy classic, perfect for breakfast.",
  ingredients: {
    "eggs": "2 large",
    "butter": "5 g",
    "milk": "15 ml",
    "salt_pepper": "to taste"
  },
  recipe_level: 0, # beginner

)
Step.create!(title: "Crack Eggs", content: "Crack the eggs into a bowl and add milk, salt, and pepper. Whisk until uniform.", recipe: recipe_1, skill: nil)
Step.create!(title: "Melt Butter", content: "Melt butter in a non-stick pan over medium-low heat.", recipe: recipe_1, skill: nil)
Step.create!(title: "Cook Eggs", content: "Pour in the egg mixture and cook, stirring slowly with a spatula until curds form and eggs are just set.", recipe: recipe_1, skill: nil)

# Recipe 2: Classic Tomato Soup (Beginner/Intermediate)
recipe_2 = Recipe.create!(
  title: "Roasted Tomato Soup",
  description: "A comforting soup with deep roasted flavor.",
  ingredients: {
    "tomatoes": "1 kg",
    "onion": "200 g (1 large)",
    "garlic": "4 cloves",
    "vegetable_broth": "1 L"
  },
  recipe_level: 0,

)
Step.create!(title: "Prep Vegetables", content: "Roughly chop tomatoes, onion, and garlic. Toss with olive oil, salt, and pepper.", recipe: recipe_2, skill: skill_onion_dice) # Uses Dicing Onion Skill
Step.create!(title: "Roast", content: "Roast vegetables at **200°C** for 30 minutes until soft and caramelized.", recipe: recipe_2, skill: nil)
Step.create!(title: "Simmer", content: "Transfer roasted vegetables to a pot, add broth, and simmer for 10 minutes.", recipe: recipe_2, skill: nil)
Step.create!(title: "Blend", content: "Carefully blend the soup until smooth using an immersion blender or standing blender.", recipe: recipe_2, skill: nil)


# Recipe 3: Creamy Chicken Alfredo (Intermediate)
recipe_3 = Recipe.create!(
  title: "Creamy Chicken Alfredo",
  description: "Fettuccine pasta with a rich, buttery, and cheesy cream sauce.",
  ingredients: {
    "fettuccine": "225 g",
    "chicken_breast": "450 g (2 small)",
    "heavy_cream": "250 ml",
    "parmesan": "50 g grated"
  },
  recipe_level: 1, # intermediate

)
Step.create!(title: "Cook Chicken", content: "Season and cook the chicken breasts. Check internal temperature to ensure safety.", recipe: recipe_3, skill: skill_temp) # Uses Meat Temperature Skill
Step.create!(title: "Cook Pasta", content: "Boil fettuccine according to package directions.", recipe: recipe_3, skill: nil)
Step.create!(title: "Make Sauce", content: "Combine **100 g** of butter, heavy cream, and Parmesan cheese in a pan over low heat until melted and smooth.", recipe: recipe_3, skill: skill_sauce) # Uses Béchamel Sauce (close analog)
Step.create!(title: "Combine", content: "Toss the cooked pasta and sliced chicken with the Alfredo sauce.", recipe: recipe_3, skill: nil)

# Recipe 4: Rustic Sourdough Loaf (Expert)
recipe_4 = Recipe.create!(
  title: "Rustic Sourdough Loaf",
  description: "A crusty, tangy sourdough bread requiring patience and technique.",
  ingredients: {
    "sourdough_starter": "250 g",
    "bread_flour": "500 g",
    "water": "350 ml",
    "salt": "10 g"
  },
  recipe_level: 2, # expert

)
Step.create!(title: "Mix Dough", content: "Combine starter, water, flour, and salt. Mix until a shaggy mass forms.", recipe: recipe_4, skill: nil)
Step.create!(title: "Knead and Bulk Ferment", content: "Knead the dough until it passes the windowpane test, then allow it to rise (bulk fermentation).", recipe: recipe_4, skill: skill_bread) # Uses Kneading/Proofing Skill
Step.create!(title: "Shape and Proof", content: "Shape the dough into a boule or batard and cold proof overnight in a banneton.", recipe: recipe_4, skill: skill_bread)
Step.create!(title: "Bake", content: "Bake in a preheated Dutch oven for a maximum oven spring and crust.", recipe: recipe_4, skill: nil)

# Recipe 5: Lemon Vinaigrette Salad Dressing (Intermediate)
recipe_5 = Recipe.create!(
  title: "Fresh Lemon Vinaigrette",
  description: "A bright and zesty dressing for any salad.",
  ingredients: {
    "olive_oil": "125 ml",
    "lemon_juice": "60 ml",
    "dijon_mustard": "5 ml",
    "salt_pepper": "to taste"
  },
  recipe_level: 1,

)
Step.create!(title: "Combine Ingredients", content: "In a bowl, combine lemon juice, mustard, salt, and pepper.", recipe: recipe_5, skill: nil)
Step.create!(title: "Emulsify", content: "Slowly whisk in the olive oil until the mixture thickens and emulsifies.", recipe: recipe_5, skill: skill_whisk) # Uses Emulsifying Skill
Step.create!(title: "Serve", content: "Taste and adjust seasoning. Serve over your favorite greens.", recipe: recipe_5, skill: nil)


puts "Created #{Recipe.count} recipes with #{Step.count} steps."

def generate_markdown_content(data)
  markdown = "# #{data[:title]}\n\n"
  markdown += "**Description:** #{data[:description]}\n\n"
  markdown += "**Cooking Time:** #{data[:cooking_time]} minutes\n\n"

  markdown += "## Ingredients\n\n"

  data[:ingredients].each do |name, amount|
    markdown += "- **#{name.to_s.humanize}:** #{amount}\n"
  end

  markdown += "\n## Instructions\n\n"

  data[:steps].each_with_index do |step, index|
    markdown += "#{index + 1}. #{step}\n"
  end

  markdown
end


# --- START: CHAT AND MESSAGE CREATION ---
puts "Creating one initial Chat and Message..."
# Create the chat thread
chat = Chat.create!(user: user, title: "Botifara Ideas")

# Create the user's initial message that prompts the AI to suggest recipes
# NOTE: Removed 'user: user' and replaced with 'role: "user"' to match the schema
first_message = Message.create!(
  chat: chat,
  role: 'user',
  content: "I have carrots, beetroot, and botifarra. What can I cook? I need 5 ideas."
)

# The ID of this message will be linked to all 5 recipes
message_id_for_recipes = first_message.id

# AI response to continue the thread
# NOTE: Removed 'user: nil' and replaced with 'role: "ai"'
Message.create!(
  chat: chat,
  role: 'ai',
  content: "Great! Based on those three ingredients, here are five distinct recipe ideas. I'll save them to your cookbook for you!"
)
# --- END: CHAT AND MESSAGE CREATION ---


puts "Seed data successfully created!"
