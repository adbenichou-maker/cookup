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

# Primary users for reviews
user_santi = User.create!(email: "santi@lewagon.com", password: "password", username: "Santi") # Original user
user_john = User.create!(email: "john.doe@test.com", password: "password", username: "John Doe")
user_maria = User.create!(email: "maria.g@test.com", password: "password", username: "Maria G")
user_david = User.create!(email: "david.c@test.com", password: "password", username: "David C")
user_elena = User.create!(email: "elena.r@test.com", password: "password", username: "Elena R")

# The author of most recipes
recipe_author = user_santi

# Array of all users for random review assignment
review_users = [user_santi, user_john, user_maria, user_david, user_elena]

puts "Created #{User.count} users."

# ---------------------------
# RECIPES + STEPS
# ---------------------------

puts "Creating Recipes and Steps..."

# ========= RECIPE 1: Fluffy Scrambled Eggs (Beginner) =========
recipe_1 = Recipe.create!(
  title: "Fluffy Scrambled Eggs",
  description: "A quick and easy classic, perfect for breakfast. The key is low heat and patience.",
  ingredients: { "eggs": "2 large", "butter": "5 g", "milk": "15 ml", "salt_pepper": "to taste" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 10
)
Step.create!(title: "Prepare Mixture", content: "Crack the eggs into a bowl. Add the milk, a pinch of salt, and pepper. Whisk vigorously until the mixture is uniform and slightly foamy.", recipe: recipe_1)
Step.create!(title: "Melt Butter", content: "Place the butter in a non-stick pan over medium-low heat. Wait until it is fully melted and foamy, but not browned.", recipe: recipe_1)
Step.create!(title: "Cook Eggs", content: "Pour the egg mixture into the pan. Stir constantly with a silicone spatula, scraping the bottom and sides to encourage the formation of small, soft curds. Remove from heat immediately when mostly set but still glistening.", recipe: recipe_1)


# ========= RECIPE 2: Roasted Tomato Soup (Beginner) =========
recipe_2 = Recipe.create!(
  title: "Roasted Tomato Soup",
  description: "A comforting soup with deep roasted flavor, far superior to canned soup.",
  ingredients: { "tomatoes": "1 kg", "onion": "200 g", "garlic": "4 cloves", "vegetable_broth": "1 L" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 45
)
Step.create!(title: "Prep & Roast Veggies", content: "Chop the tomatoes and onion roughly, and toss them along with the whole, unpeeled garlic cloves with olive oil, salt, and pepper on a baking sheet. Roast for 30 minutes at 200°C until edges are caramelized.", recipe: recipe_2, skill: skill_onion_dice)
Step.create!(title: "Simmer Soup Base", content: "Transfer the roasted vegetables (squeeze the garlic out of their skins) and all juices to a large pot. Pour in the vegetable broth and bring to a gentle simmer for 10 minutes to allow the flavors to meld.", recipe: recipe_2)
Step.create!(title: "Blend Soup", content: "Carefully transfer the soup mixture to a blender (or use an immersion blender) and blend until perfectly smooth. Taste and adjust salt and pepper if necessary.", recipe: recipe_2)


# ========= RECIPE 3: Creamy Chicken Alfredo (Intermediate) =========
recipe_3 = Recipe.create!(
  title: "Creamy Chicken Alfredo",
  description: "Fettuccine pasta in a rich cream sauce. This version relies on the starch from the pasta water for emulsification.",
  ingredients: { "fettuccine": "225 g", "chicken_breast": "450 g", "heavy_cream": "250 ml", "parmesan": "50 g" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 30
)
Step.create!(title: "Cook Chicken & Pasta", content: "Slice chicken breasts thinly and sauté until fully cooked, checking the internal temperature with a thermometer to ensure it reaches 74°C (165°F). Meanwhile, boil the fettuccine until al dente, reserving 1 cup of the starchy pasta water.", recipe: recipe_3, skill: skill_temp)
Step.create!(title: "Prepare Sauce Base", content: "In a separate pan, melt butter and add the heavy cream. Bring to a low simmer. Grate the Parmesan cheese finely and have it ready.", recipe: recipe_3)
Step.create!(title: "Emulsify Sauce", content: "Drain the pasta and immediately toss it into the cream mixture along with the cooked chicken. Gradually add the reserved pasta water, stirring vigorously. Finish by stirring in the Parmesan until a thick, creamy sauce forms.", recipe: recipe_3, skill: skill_sauce)


# ========= RECIPE 4: Rustic Sourdough Loaf (Expert) =========
recipe_4 = Recipe.create!(
  title: "Rustic Sourdough Loaf",
  description: "A crusty, tangy bread requiring patience and precise timing for proofing and baking.",
  ingredients: { "sourdough_starter": "250 g", "bread_flour": "500 g", "water": "350 ml", "salt": "10 g" },
  recipe_level: 2,
  user: recipe_author,
  meal_prep_time: 180
)
Step.create!(title: "Mix Autolyse", content: "Combine the flour and water in a large bowl and mix until just combined. Let it rest for 30 minutes to allow the flour to fully hydrate before adding the starter and salt.", recipe: recipe_4)
Step.create!(title: "Knead & Fold", content: "Add the active sourdough starter and salt to the dough. Mix well. Perform a series of stretch-and-folds every 30 minutes for the next 2 hours to develop the gluten structure.", recipe: recipe_4, skill: skill_bread)
Step.create!(title: "Bulk Fermentation & Proof", content: "Allow the dough to bulk ferment at room temperature until it has increased in volume by about 50%. Shape the dough, place it in a proofing basket, and refrigerate overnight for a slow, cold proof.", recipe: recipe_4)
Step.create!(title: "Bake Bread", content: "Preheat a Dutch oven inside your oven to 250°C. Score the cold dough, place it inside the hot Dutch oven, cover, and bake for 20 minutes. Remove the lid and bake for another 25 minutes until deep golden brown.", recipe: recipe_4)


# ========= RECIPE 5: Fresh Lemon Vinaigrette (Intermediate) =========
recipe_5 = Recipe.create!(
  title: "Fresh Lemon Vinaigrette",
  description: "A bright, zesty salad dressing that elevates any simple green salad.",
  ingredients: { "olive_oil": "125 ml", "lemon_juice": "60 ml", "dijon_mustard": "5 ml", "salt_pepper": "to taste" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 15
)
Step.create!(title: "Combine Base", content: "In a medium bowl, whisk together the fresh lemon juice, Dijon mustard, salt, and pepper. The mustard acts as the emulsifier in this recipe.", recipe: recipe_5)
Step.create!(title: "Whisk In Oil", content: "Slowly and steadily pour the olive oil into the bowl in a thin stream while whisking constantly. Continue whisking until the dressing thickens slightly and achieves a uniform, creamy consistency (an emulsion).", recipe: recipe_5, skill: skill_whisk)
Step.create!(title: "Serve", content: "Taste the vinaigrette and adjust the seasoning. If it is too thick, add a teaspoon of water. Serve immediately or store in the refrigerator.", recipe: recipe_5)


# ========= RECIPE 6: Spicy Chickpea Curry (Intermediate) =========
recipe_6 = Recipe.create!(
  title: "Spicy Chickpea Curry",
  description: "A warming, quick weeknight curry packed with bold, satisfying spices.",
  ingredients: { "chickpeas": "400 g", "onion": "1", "garlic": "3 cloves", "ginger": "1 tbsp", "coconut_milk": "200 ml" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 35
)
Step.create!(title: "Dice Aromatics", content: "Peel and dice the onion and mince the garlic and ginger finely. Consistency in cutting will ensure even cooking and better flavor integration.", recipe: recipe_6, skill: skill_onion_dice)
Step.create!(title: "Cook Base", content: "Heat a tablespoon of oil in a pot. Add the onion and cook until softened. Add the garlic, ginger, and your choice of curry spices (e.g., cumin, coriander, turmeric). Cook for 1 minute until fragrant.", recipe: recipe_6)
Step.create!(title: "Simmer Curry", content: "Add the drained chickpeas and coconut milk. Bring the mixture to a low simmer and cook for 20 minutes, stirring occasionally, until the sauce has thickened slightly.", recipe: recipe_6)


# ========= RECIPE 7: Crispy Pan-Fried Salmon (Intermediate) =========
recipe_7 = Recipe.create!(
  title: "Crispy Pan-Fried Salmon",
  description: "A simple salmon dish with a perfect, salty crust achieved through high-heat searing.",
  ingredients: { "salmon": "2 fillets", "lemon": "1", "oil": "1 tbsp" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 20
)
Step.create!(title: "Season Salmon", content: "Pat the salmon fillets very dry with paper towels—this is essential for crisp skin. Season the skin aggressively with salt and pepper.", recipe: recipe_7)
Step.create!(title: "Sear Fish", content: "Heat a skillet over high heat with the oil until shimmering. Place the salmon in the pan, skin-side down. Press down gently for 10 seconds to prevent curling. Cook for 4-5 minutes without moving.", recipe: recipe_7)
Step.create!(title: "Finish Cook", content: "Flip the fillets and cook for 1-2 minutes on the flesh side until the internal temperature is 63°C (145°F). Remove from heat and squeeze fresh lemon juice over the top.", recipe: recipe_7, skill: skill_temp)


# ========= RECIPE 8: Garlic Butter Shrimp Pasta (Beginner) =========
recipe_8 = Recipe.create!(
  title: "Garlic Butter Shrimp Pasta",
  description: "A quick 15-minute pasta loaded with garlic and white wine, a true weeknight hero.",
  ingredients: { "spaghetti": "200 g", "shrimp": "250 g", "garlic": "4 cloves" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 15
)
Step.create!(title: "Boil Pasta", content: "Bring a large pot of salted water to a rolling boil. Add the spaghetti and cook according to package directions, reserving half a cup of pasta water before draining.", recipe: recipe_8)
Step.create!(title: "Cook Shrimp", content: "While pasta cooks, melt butter in a separate pan. Add minced garlic and shrimp. Cook until the shrimp are pink and opaque (about 3 minutes).", recipe: recipe_8)
Step.create!(title: "Combine", content: "Add the drained pasta and the reserved pasta water to the shrimp pan. Toss vigorously to create a light sauce that coats the spaghetti.", recipe: recipe_8)


# ========= RECIPE 9: Vegetable Stir-Fry (Beginner) =========
recipe_9 = Recipe.create!(
  title: "Vegetable Stir-Fry",
  description: "A customizable dish showcasing basic cutting and high-heat cooking.",
  ingredients: { "broccoli": "200 g", "carrots": "2", "bell_pepper": "1" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 25
)
Step.create!(title: "Prep Veg", content: "Wash and chop all vegetables into roughly similar, bite-sized pieces. Use a proper knife grip for efficiency and safety.", recipe: recipe_9, skill: skill_knife)
Step.create!(title: "Stir Fry", content: "Heat a wok or large skillet over high heat until smoking. Add a high-smoke-point oil. Add the hardest vegetables (like carrots/broccoli) first, cooking for 2 minutes before adding softer vegetables.", recipe: recipe_9)
Step.create!(title: "Add Sauce", content: "Pour a mixture of soy sauce, sugar, and water over the vegetables. Toss until the sauce thickens and coats all the ingredients evenly.", recipe: recipe_9)


# ========= RECIPE 10: Slow-Cooked Beef Stew (Expert) =========
recipe_10 = Recipe.create!(
  title: "Slow-Cooked Beef Stew",
  description: "A rich, deeply flavored stew that requires long, gentle cooking for incredibly tender meat.",
  ingredients: { "beef": "500 g", "potatoes": "3", "carrots": "2" },
  recipe_level: 2,
  user: recipe_author,
  meal_prep_time: 210
)
Step.create!(title: "Sear Beef", content: "Cut the beef into 1-inch cubes and pat dry. Season heavily. Sear the beef in batches in a Dutch oven until deeply browned on all sides, then remove and set aside.", recipe: recipe_10)
Step.create!(title: "Prep Vegetables", content: "Roughly chop the potatoes and carrots. Ensure consistent sizing for even cooking throughout the stew. Sauté them briefly in the Dutch oven to start releasing their flavors.", recipe: recipe_10, skill: skill_knife)
Step.create!(title: "Slow Cook", content: "Return the beef to the pot. Add beef broth and desired herbs (like bay leaves and thyme). Bring to a simmer, cover, and transfer to a preheated oven (160°C/325°F). Cook for 3 hours until the meat is fork-tender.", recipe: recipe_10)


# --- NEW RECIPES UTILIZING NEW SKILLS ---

# ========= RECIPE 13: Simple Pan Sauce (Beginner) =========
recipe_13 = Recipe.create!(
  title: "Simple Pan Sauce",
  description: "A classic weeknight sauce made directly in the pan after searing meat, using a basic roux.",
  ingredients: { "butter": "2 tbsp", "flour": "2 tbsp", "beef_broth": "1 cup", "red_wine": "1/4 cup" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 10
)
Step.create!(title: "Deglaze Pan", content: "After removing seared meat, pour the red wine into the hot pan. Scrape up any browned bits (fond) from the bottom. Reduce the wine slightly.", recipe: recipe_13)
Step.create!(title: "Make Roux", content: "Reduce the heat to medium-low. Add the butter until melted, then sprinkle in the flour. Whisk continuously for 1-2 minutes until a thick, light-blonde paste forms.", recipe: recipe_13, skill: skill_roux)
Step.create!(title: "Finish Sauce", content: "Gradually whisk in the beef broth. Bring the mixture to a simmer, stirring until the sauce thickens and coats the back of a spoon. Season to taste.", recipe: recipe_13)


# ========= RECIPE 14: Classic Osso Buco (Intermediate) =========
recipe_14 = Recipe.create!(
  title: "Classic Osso Buco",
  description: "Tender braised veal shanks served with its own flavorful, rich sauce.",
  ingredients: { "veal_shanks": "4", "white_wine": "1/2 cup", "beef_broth": "2 cups", "diced_vegetables": "1 cup" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 150
)
Step.create!(title: "Sear Shanks", content: "Dust the veal shanks lightly in flour. Sear them in a large, heavy pot or Dutch oven until deep brown on all sides. Remove and set aside.", recipe: recipe_14)
Step.create!(title: "Prepare Braising Liquid", content: "Add the diced vegetables to the pot and cook until soft. Deglaze with white wine, then add the beef broth, ensuring the liquid is below the top of the shanks.", recipe: recipe_14)
Step.create!(title: "Braise", content: "Return the shanks to the pot. Cover tightly and cook in a low oven (160°C/325°F) for 2 to 2.5 hours until the meat is extremely tender and falling off the bone.", recipe: recipe_14, skill: skill_braise)


# ========= RECIPE 15: Mushroom Risotto (Expert) =========
recipe_15 = Recipe.create!(
  title: "Mushroom Risotto",
  description: "A deeply savory, creamy rice dish that requires continuous attention and proper technique for the best texture.",
  ingredients: { "Arborio_rice": "300 g", "mushrooms": "200 g", "chicken_stock": "1.5 L", "parmesan": "50 g", "white_wine": "1/2 cup" },
  recipe_level: 2,
  user: recipe_author,
  meal_prep_time: 45
)
Step.create!(title: "Sauté Base", content: "Sauté the mushrooms and shallots until golden brown. Add the Arborio rice and toast for 2 minutes until the edges are translucent.", recipe: recipe_15)
Step.create!(title: "Toast & Wine", content: "Pour in the white wine and stir until it is completely absorbed by the rice. Keep the stock hot in a separate pot—cold stock will shock the rice.", recipe: recipe_15)
Step.create!(title: "Add Stock Slowly", content: "Add one ladle of hot stock to the rice. Stir constantly until the stock is almost fully absorbed, then add the next ladle. Repeat this process for about 20 minutes until the rice is creamy on the outside and firm (al dente) in the center.", recipe: recipe_15, skill: skill_risotto)
Step.create!(title: "Mantecare", content: "Remove the pot from the heat. Stir in a knob of butter and grated Parmesan cheese vigorously—this is the 'mantecare' step that gives risotto its characteristic creaminess and gloss.", recipe: recipe_15)


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

def create_recipe_reviews(recipe, review_users)
  rand(3..7).times do
    # Randomly assign author from the expanded user list
    reviewer = review_users.sample

    Review.create!(
      title: REVIEW_TITLES.sample,
      comment: REVIEW_COMMENTS.sample,
      rate: rand(1..5),
      recipe: recipe,
      user: reviewer
    )
  end
end

# Create random reviews for all recipes, authored by the expanded user list
[recipe_1, recipe_2, recipe_3, recipe_4, recipe_5,
recipe_6, recipe_7, recipe_8, recipe_9, recipe_10,
recipe_13, recipe_14, recipe_15].each do |rec|
  create_recipe_reviews(rec, review_users)
end

# Force recipe_9 (Stir-Fry) to have specific low reviews owned by the main user (Santi)
3.times do
  Review.create!(
    title: "Terrible",
    comment: "Really bland and disappointing. Needs more instruction on heat management.",
    rate: 1,
    recipe: recipe_9,
    user: user_santi # Main user owns these for easy testing of the delete button
  )
end

# Force recipe_15 (Risotto) to have specific high reviews owned by a different user (Elena)
3.times do
  Review.create!(
    title: "The Cremè de la Cremè",
    comment: "The stirring technique worked perfectly! So creamy and rich.",
    rate: 5,
    recipe: recipe_15,
    user: user_elena
  )
end


puts "Created #{Review.count} total reviews."


# ---------------------------
# CHAT + MESSAGES
# ---------------------------

puts "Creating Chat and Messages..."

chat = Chat.create!(user: user_santi, title: "Botifarra Ideas")

first_message = Message.create!(
  chat: chat,
  role: "user",
  content: "I have carrots, beetroot, and botifarra. What can I cook? I need it to be intermediate level."
)

Message.create!(
  chat: chat,
  role: "ai",
  content: "Here are 5 recipe ideas using those ingredients, tailored to an intermediate skill level!"
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
