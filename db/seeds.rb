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

puts "Creating Recipes and Steps with **LONGER CONTENT**..."

# The Recipe Author (if needed for moderation logic)
recipe_author = user

# ========= RECIPE 1: Fluffy Scrambled Eggs (Beginner) =========
recipe_1 = Recipe.create!(
  title: "Fluffy Scrambled Eggs",
  description: "A quick and easy classic, perfect for breakfast.",
  ingredients: { "eggs": "2 large", "butter": "5 g", "milk": "15 ml", "salt_pepper": "to taste" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 10
)
Step.create!(title: "Crack and Whisk Eggs", content: "Crack the eggs into a bowl. Add the milk, salt, and pepper. Whisk vigorously for about 30 seconds until the mixture is pale yellow and slightly frothy.", recipe: recipe_1)
Step.create!(title: "Melt Butter", content: "Place a non-stick pan over medium-low heat. Add the butter and swirl the pan until the butter is completely melted and bubbling lightly.", recipe: recipe_1)
Step.create!(title: "Cook and Stir Eggs", content: "Pour the egg mixture into the pan. Let the edges set for a few seconds, then use a rubber spatula to push the eggs from the edges to the center, creating soft, large curds. Continue stirring gently until the eggs are mostly set but still slightly moist.", recipe: recipe_1)


# ========= RECIPE 2: Roasted Tomato Soup (Beginner) =========
recipe_2 = Recipe.create!(
  title: "Roasted Tomato Soup",
  description: "A comforting soup with deep roasted flavor.",
  ingredients: { "tomatoes": "1 kg", "onion": "200 g", "garlic": "4 cloves", "vegetable_broth": "1 L" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 45
)
Step.create!(title: "Prep and Season Veggies", content: "Preheat oven to 200°C. Roughly chop the tomatoes and onion. Peel the garlic cloves. Place all vegetables on a baking sheet, drizzle generously with olive oil, and season with salt and pepper.", recipe: recipe_2, skill: skill_onion_dice)
Step.create!(title: "Roast Veggies", content: "Roast for 30 minutes until the vegetables are soft and slightly caramelized around the edges. This deepens the flavor of the tomatoes.", recipe: recipe_2)
Step.create!(title: "Simmer Soup", content: "Transfer the roasted vegetables to a large pot. Pour in the vegetable broth and bring the mixture to a simmer over medium heat for 10 minutes, allowing the flavors to marry.", recipe: recipe_2)
Step.create!(title: "Blend Soup", content: "Carefully transfer the soup mixture to a blender (or use an immersion blender) and blend until it is completely smooth and creamy. Adjust salt and pepper to taste.", recipe: recipe_2)


# ========= RECIPE 3: Creamy Chicken Alfredo (Intermediate) =========
recipe_3 = Recipe.create!(
  title: "Creamy Chicken Alfredo",
  description: "Fettuccine pasta in a rich cream sauce.",
  ingredients: { "fettuccine": "225 g", "chicken_breast": "450 g", "heavy_cream": "250 ml", "parmesan": "50 g" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 30
)
Step.create!(title: "Cook Chicken", content: "Slice the chicken breast into strips. Sear in a pan with a little butter or oil until golden brown and cooked through. Use a thermometer to ensure the internal temperature reaches 74°C.", recipe: recipe_3, skill: skill_temp)
Step.create!(title: "Cook Pasta", content: "Boil the fettuccine pasta in salted water according to package directions until it is perfectly al dente. Reserve about 1 cup of the pasta water before draining.", recipe: recipe_3)
Step.create!(title: "Make Sauce", content: "In a separate saucepan, combine the heavy cream, butter, and grated Parmesan cheese. Heat gently over low heat, stirring constantly until the cheese is melted and the sauce is smooth and velvety. Do not boil.", recipe: recipe_3, skill: skill_sauce)
Step.create!(title: "Combine All", content: "Transfer the drained pasta and cooked chicken to the sauce. Toss well to coat everything evenly. Add a splash of the reserved pasta water if the sauce is too thick.", recipe: recipe_3)


# ========= RECIPE 4: Rustic Sourdough Loaf (Expert) =========
recipe_4 = Recipe.create!(
  title: "Rustic Sourdough Loaf",
  description: "A crusty, tangy bread requiring patience.",
  ingredients: { "sourdough_starter": "250 g", "bread_flour": "500 g", "water": "350 ml", "salt": "10 g" },
  recipe_level: 2,
  user: recipe_author,
  meal_prep_time: 180
)
Step.create!(title: "Mix Dough", content: "In a large bowl, combine the active sourdough starter, bread flour, and water until just combined. Let the shaggy dough rest for 30 minutes (autolyse) before adding the salt.", recipe: recipe_4)
Step.create!(title: "Knead and Stretch", content: "Add the salt and knead the dough by folding it over itself repeatedly for 10 minutes until the gluten is developed and the dough is elastic and smooth.", recipe: recipe_4, skill: skill_bread)
Step.create!(title: "Bulk Fermentation (Proof)", content: "Place the dough in a clean bowl, cover, and let it rise in a cool spot (or refrigerator) overnight for 12-18 hours until doubled in size.", recipe: recipe_4)
Step.create!(title: "Bake Bread", content: "Preheat your oven and Dutch oven to 230°C. Score the dough and bake, covered, for 20 minutes, then uncovered for 25-30 minutes until deeply golden brown.", recipe: recipe_4)


# ========= RECIPE 5: Fresh Lemon Vinaigrette (Intermediate) =========
recipe_5 = Recipe.create!(
  title: "Fresh Lemon Vinaigrette",
  description: "A bright, zesty salad dressing.",
  ingredients: { "olive_oil": "125 ml", "lemon_juice": "60 ml", "dijon_mustard": "5 ml", "salt_pepper": "to taste" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 15
)
Step.create!(title: "Combine Base", content: "In a medium bowl, whisk together the fresh lemon juice, Dijon mustard, salt, and pepper. The mustard will act as the emulsifier.", recipe: recipe_5)
Step.create!(title: "Whisk In Oil", content: "While continuously whisking, slowly drizzle in the olive oil until the mixture thickens and achieves a creamy, uniform consistency (emulsion).", recipe: recipe_5, skill: skill_whisk)
Step.create!(title: "Serve", content: "Taste the vinaigrette and adjust the seasoning if needed. If it's too thick, whisk in a tablespoon of water. Serve immediately over your favorite greens.", recipe: recipe_5)


# ========= RECIPE 6: Spicy Chickpea Curry (Intermediate) =========
recipe_6 = Recipe.create!(
  title: "Spicy Chickpea Curry",
  description: "A warming curry packed with bold spices.",
  ingredients: { "chickpeas": "400 g", "onion": "1", "garlic": "3 cloves", "ginger": "1 tbsp", "coconut_milk": "200 ml" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 35
)
Step.create!(title: "Dice Aromatics", content: "Finely dice the onion, mince the garlic cloves, and grate the ginger. These form the aromatic base of the curry.", recipe: recipe_6, skill: skill_onion_dice)
Step.create!(title: "Cook Base", content: "Heat oil in a pot. Add the diced onion and cook until soft and translucent. Add the garlic and ginger, cooking for 1 minute until fragrant.", recipe: recipe_6)
Step.create!(title: "Simmer Curry", content: "Add your preferred curry powder or spices, then add the drained chickpeas and coconut milk. Bring to a gentle simmer and cook for 20 minutes to thicken.", recipe: recipe_6)


# ========= RECIPE 7: Crispy Pan-Fried Salmon (Intermediate) =========
recipe_7 = Recipe.create!(
  title: "Crispy Pan-Fried Salmon",
  description: "A simple salmon dish with a perfect crust.",
  ingredients: { "salmon": "2 fillets", "lemon": "1", "oil": "1 tbsp" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 20
)
Step.create!(title: "Season Salmon", content: "Pat the salmon fillets dry with a paper towel. Season the skin side heavily with salt and pepper. Scoring the skin lightly helps it crisp up.", recipe: recipe_7)
Step.create!(title: "Sear Fish", content: "Heat oil in a pan over medium-high heat. Place salmon, skin side down, and cook undisturbed for 4-6 minutes until the skin is golden and crispy.", recipe: recipe_7)
Step.create!(title: "Finish", content: "Flip the salmon and cook for 2-3 minutes on the flesh side, or until the fish flakes easily. Remove from heat and squeeze fresh lemon juice over the top.", recipe: recipe_7)


# ========= RECIPE 8: Garlic Butter Shrimp Pasta (Beginner) =========
recipe_8 = Recipe.create!(
  title: "Garlic Butter Shrimp Pasta",
  description: "A quick 15-minute pasta loaded with garlic.",
  ingredients: { "spaghetti": "200 g", "shrimp": "250 g", "garlic": "4 cloves" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 15
)
Step.create!(title: "Boil Pasta", content: "Cook spaghetti according to package instructions. Reserve about 1/2 cup of the starchy pasta water before draining.", recipe: recipe_8)
Step.create!(title: "Cook Shrimp", content: "Melt butter in a skillet over medium heat. Add minced garlic and sauté for 1 minute. Add the shrimp and cook for 2-3 minutes per side until pink and opaque.", recipe: recipe_8)
Step.create!(title: "Combine", content: "Add the drained pasta to the skillet with the shrimp and garlic butter. Toss to coat. Add a small splash of the reserved pasta water to create a light sauce.", recipe: recipe_8)


# ========= RECIPE 9: Vegetable Stir-Fry (Beginner) =========
recipe_9 = Recipe.create!(
  title: "Vegetable Stir-Fry",
  description: "A vibrant stir-fry with savory sauce.",
  ingredients: { "broccoli": "200 g", "carrots": "2", "bell_pepper": "1" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 25
)
Step.create!(title: "Prep Veg", content: "Chop all vegetables into bite-sized pieces, ensuring the harder vegetables (like carrots/broccoli) are cut smaller than the softer ones (like peppers).", recipe: recipe_9, skill: skill_knife)
Step.create!(title: "Stir Fry", content: "Heat a wok or large pan to high heat. Add the harder vegetables first and stir-fry for 3 minutes before adding the softer vegetables for the remaining 2 minutes.", recipe: recipe_9)
Step.create!(title: "Add Sauce", content: "Pour your pre-mixed soy glaze or sauce over the vegetables. Toss constantly until the sauce thickens and coats all the vegetables. Serve immediately.", recipe: recipe_9)


# ========= RECIPE 10: Slow-Cooked Beef Stew (Expert) =========
recipe_10 = Recipe.create!(
  title: "Slow-Cooked Beef Stew",
  description: "A rich stew simmered for hours.",
  ingredients: { "beef": "500 g", "potatoes": "3", "carrots": "2" },
  recipe_level: 2,
  user: recipe_author,
  meal_prep_time: 210
)
Step.create!(title: "Brown Beef", content: "Season beef chunks with salt and pepper. Sear the beef in batches in a hot pan with oil until deeply browned on all sides. This step is crucial for flavor.", recipe: recipe_10)
Step.create!(title: "Prep Vegetables", content: "Roughly chop the potatoes, carrots, and any other root vegetables. Use a sturdy knife to ensure even pieces.", recipe: recipe_10, skill: skill_knife)
Step.create!(title: "Slow Cook", content: "Combine the browned beef, vegetables, beef stock, and seasonings in a large pot or slow cooker. Cook on low for 3-4 hours until the beef is fork-tender.", recipe: recipe_10)


# ========= RECIPE 11: Avocado Toast Deluxe (Beginner) =========
recipe_11 = Recipe.create!(
  title: "Avocado Toast Deluxe",
  description: "Creamy avocado toast with chili flakes.",
  ingredients: { "bread": "2 slices", "avocado": "1" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 5
)
Step.create!(title: "Toast Bread", content: "Toast your bread slices to your preferred level of crispiness. A sturdy, rustic bread works best to support the toppings.", recipe: recipe_11)
Step.create!(title: "Mash Avocado", content: "Halve the avocado, scoop out the flesh, and mash it gently in a small bowl. Add a squeeze of lemon juice and a pinch of salt and pepper.", recipe: recipe_11)
Step.create!(title: "Assemble", content: "Spread the mashed avocado generously over the toasted bread. Top with optional chili flakes, microgreens, or a drizzle of olive oil.", recipe: recipe_11)


# ========= RECIPE 12: Homemade Pancakes (Beginner) =========
recipe_12 = Recipe.create!(
  title: "Homemade Pancakes",
  description: "Fluffy pancakes perfect for weekends.",
  ingredients: { "flour": "200 g", "milk": "250 ml", "egg": "1" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 20
)
Step.create!(title: "Mix Batter", content: "In one bowl, combine the dry ingredients (flour, sugar, baking powder). In another, whisk the wet ingredients (milk, egg, melted butter). Gently combine the wet and dry mixtures until just mixed (lumps are okay!).", recipe: recipe_12)
Step.create!(title: "Heat Pan", content: "Heat a non-stick skillet or griddle over medium heat. Lightly grease the surface with butter or oil.", recipe: recipe_12)
Step.create!(title: "Cook Cakes", content: "Pour 1/4 cup of batter per pancake onto the hot surface. Cook until bubbles appear on the surface and the edges look set (about 2 minutes). Flip and cook the other side for 1-2 minutes until golden brown.", recipe: recipe_12)


# ---------------------------
# NEW MEDITERRANEAN RECIPES
# ---------------------------

# ========= RECIPE 13: Greek Lemon Potatoes (Beginner) =========
recipe_13 = Recipe.create!(
  title: "Greek Lemon Potatoes",
  description: "Crispy and tender potatoes roasted in lemon, oregano, and olive oil.",
  ingredients: { "potatoes": "1 kg", "lemon_juice": "120 ml", "chicken_broth": "250 ml", "oregano": "1 tsp", "olive_oil": "60 ml" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 60
)
Step.create!(title: "Prep Potatoes", content: "Peel and cut potatoes into large wedges or quarters. Place them in a large roasting pan.", recipe: recipe_13, skill: skill_knife)
Step.create!(title: "Make Marinade", content: "In a bowl, whisk together the lemon juice, chicken broth, olive oil, and oregano. Season generously with salt and pepper.", recipe: recipe_13, skill: skill_whisk)
Step.create!(title: "Roast", content: "Pour the marinade over the potatoes, tossing to coat. Roast at 200°C for 50-60 minutes, stirring occasionally, until tender and golden brown.", recipe: recipe_13)


# ========= RECIPE 14: Homemade Hummus (Beginner) =========
recipe_14 = Recipe.create!(
  title: "Homemade Hummus",
  description: "Smooth, creamy Middle Eastern chickpea dip.",
  ingredients: { "chickpeas": "400 g can", "tahini": "60 g", "lemon_juice": "60 ml", "garlic": "1 clove", "ice_water": "2 tbsp" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 10
)
Step.create!(title: "Prep Chickpeas", content: "Drain and rinse the chickpeas. For the smoothest hummus, gently rub the chickpeas to remove some of the skins.", recipe: recipe_14)
Step.create!(title: "Blend Tahini and Lemon", content: "In a food processor, blend the tahini, lemon juice, garlic, and salt for 1 minute until it becomes thick and pale.", recipe: recipe_14)
Step.create!(title: "Add Chickpeas and Water", content: "Add the chickpeas to the mixture. Process until completely smooth, scraping down the sides. Add ice water one tablespoon at a time until desired consistency is reached.", recipe: recipe_14)


# ========= RECIPE 15: Tzatziki Dip (Beginner) =========
recipe_15 = Recipe.create!(
  title: "Tzatziki Dip",
  description: "Refreshing Greek yogurt and cucumber dip, perfect for grilling.",
  ingredients: { "greek_yogurt": "500 g", "cucumber": "1 large", "garlic": "2 cloves", "dill": "1 tbsp" },
  recipe_level: 0,
  user: recipe_author,
  meal_prep_time: 15
)
Step.create!(title: "Grate and Drain Cucumber", content: "Grate the cucumber and place it in a fine-mesh sieve or cheesecloth. Squeeze out as much liquid as possible—this is key to a thick dip.", recipe: recipe_15)
Step.create!(title: "Mince Garlic and Chop Dill", content: "Finely mince the garlic cloves and chop the fresh dill.", recipe: recipe_15)
Step.create!(title: "Combine", content: "In a bowl, gently fold the grated cucumber, garlic, and dill into the Greek yogurt. Season with salt and pepper and refrigerate for 30 minutes to allow the flavors to blend.", recipe: recipe_15)


# ========= RECIPE 16: Seared Halloumi with Roasted Vegetables (Intermediate) =========
recipe_16 = Recipe.create!(
  title: "Seared Halloumi with Roasted Vegetables",
  description: "A satisfying vegetarian meal featuring salty, squeaky halloumi cheese.",
  ingredients: { "halloumi": "250 g", "zucchini": "1", "bell_pepper": "1", "cherry_tomatoes": "150 g", "pesto": "2 tbsp" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 40
)
Step.create!(title: "Prep and Roast Vegetables", content: "Chop the zucchini and bell pepper. Toss with cherry tomatoes, olive oil, and seasoning. Roast at 200°C for 25 minutes until tender.", recipe: recipe_16, skill: skill_knife)
Step.create!(title: "Sear Halloumi", content: "Slice the halloumi into 1/2-inch thick pieces. Heat a non-stick pan over medium-high heat (no oil needed!). Sear the slices for 2-3 minutes per side until deeply golden and crispy.", recipe: recipe_16)
Step.create!(title: "Assemble", content: "Serve the hot roasted vegetables immediately. Top with the seared halloumi slices and drizzle with fresh pesto.", recipe: recipe_16)


# ========= RECIPE 17: Fasolada (Greek White Bean Soup) (Intermediate) =========
recipe_17 = Recipe.create!(
  title: "Fasolada (Greek White Bean Soup)",
  description: "A simple, hearty, and healthy traditional Greek dish.",
  ingredients: { "dried_navy_beans": "250 g", "carrots": "2", "celery_stalks": "2", "onion": "1", "olive_oil": "125 ml" },
  recipe_level: 1,
  user: recipe_author,
  meal_prep_time: 90
)
Step.create!(title: "Prep Beans (Overnight)", content: "Soak the dried beans in water overnight. The next day, drain and rinse them thoroughly.", recipe: recipe_17)
Step.create!(title: "Sauté Aromatics", content: "Finely chop the onion, carrots, and celery. Sauté them in a large pot with the olive oil until soft and fragrant.", recipe: recipe_17, skill: skill_onion_dice)
Step.create!(title: "Simmer Soup", content: "Add the soaked beans, water to cover, and salt. Bring to a boil, then reduce heat and simmer, covered, for 1.5 to 2 hours until the beans are very tender.", recipe: recipe_17)


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
recipe_11, recipe_12, recipe_13, recipe_14, recipe_15,
recipe_16, recipe_17].each do |rec| # ADDED NEW RECIPES
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
