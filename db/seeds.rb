# db/seeds.rb
puts "Starting seed (75 chef-y recipes with expanded steps and 4-7 reviews each)..."

# ---- CLEANUP (respect dependencies) ----
puts "Cleaning up existing data..."

Review.destroy_all
Step.destroy_all
Message.destroy_all
UserSkill.destroy_all
UserRecipeCompletion.destroy_all
Favorite.destroy_all
UserBadge.destroy_all

Chat.destroy_all
Recipe.destroy_all
Skill.destroy_all
Badge.destroy_all
User.destroy_all

puts "Destroyed all records."

# ---------------------------
# SKILLS
# ---------------------------
puts "Creating Skills..."

Skill.create!([
  { title: "Basic Knife Skills", description: "Learn the proper grip and basic cuts like chop, dice, and mince.", video: "ypjsz5i7fozswa6l5rxy.mp4", skill_level: 0 },
  { title: "Dicing an Onion", description: "Learn proper professional onion dicing technique.", video: "brbvydzx58divep5it19.mp4", skill_level: 0 },
  { title: "Cutting Julienne", description: "Achieve the precise matchstick cut for vegetables.", video: "pbsxy3ersnifmexgpgro.mp4", skill_level: 1 },
  { title: "Cutting Brunoise", description: "Master the fine dice (tiny cubes) used for garnishes and aromatic bases.", video: "i5b0keozhjizlaaygudl.mp4", skill_level: 2 },
  { title: "Emulsifying Vinaigrette", description: "Create a stable, creamy dressing from oil and vinegar.", video: "b6uzzmdngdf62hdhpijc.mp4", skill_level: 1 },
  { title: "Making a Basic Roux", description: "Combining butter and flour to create a thickening agent for sauces and soups.", video: "t0chjvppjipozpnlhkvx.mp4", skill_level: 0 },
  { title: "Making Béchamel Sauce", description: "Master the classic French white sauce and general sauce-building techniques.", video: "crawulksr4evydltk5qs.mp4", skill_level: 1 },
  { title: "Kneading and Proofing Dough", description: "Develop the gluten structure for a perfect rise.", video: "nxjrshfbpodqaxvh4kp3.mp4", skill_level: 2 },
  { title: "Cooking Risotto (Proper Stirring)", description: "Add stock slowly while stirring to achieve creamy risotto.", video: "lpvbvkjr09qpu0sjv5wa.mp4", skill_level: 2 },
  { title: "Checking Meat Internal Temperature", description: "Use a thermometer to ensure meat is cooked properly.", video: "luhlhziraf08afsknfj8.mp4", skill_level: 0 },
  { title: "Braising Meat", description: "Slow-cooking meat in liquid for maximum tenderness and flavor.", video: "gamrvinxg6hxfwrtdeqi.mp4", skill_level: 1 },
  { title: "Making Hollandaise Sauce", description: "Master the classic French emulsion sauce made from egg yolks, melted butter, and lemon juice.", video: "hhinzxu2qyahhouygjro.mp4", skill_level: 1 }
])

puts "Created #{Skill.count} skills."

# ---------------------------
# USERS
# ---------------------------
puts "Creating Users..."

# Primary users for reviews
user_santi = User.create!(email: "santi@lewagon.com", password: "password", username: "Santi")
user_john = User.create!(email: "john.doe@test.com", password: "password", username: "John Doe")
user_maria = User.create!(email: "maria.g@test.com", password: "password", username: "Maria G")
user_david = User.create!(email: "david.c@test.com", password: "password", username: "David C")
user_elena = User.create!(email: "elena.r@test.com", password: "password", username: "Elena R")
user_adam = User.create!(email: "adam@lewagon.com", password: "password", username: "Adam", level: 5, xp: 125)
generic_user = User.create!(email: "generic@test.com", password: "password", username: "Maria Doe") # Added generic user

recipe_author = user_santi
review_users = [user_santi, user_john, user_maria, user_david, user_elena, user_adam, generic_user]

puts "Created #{User.count} users."


# ---------------------------
# HELPERS
# ---------------------------

# Expand a short step into a more detailed chef-style 2-3 sentence instruction (~20-40 words)
def expand_step(text)
  base = text.to_s.strip
  base = base.chomp(".") + "."

  templates = [
    "#{base} Start by preparing your mise en place so you have everything at hand; pay attention to heat and timing. Work deliberately and adjust seasoning as you go for balanced flavor.",
    "#{base} Heat the appropriate pan or oven to the right temperature before starting, then proceed keeping an eye on texture and color. Move quickly when necessary and rest components where the recipe requires.",
    "#{base} Use correct technique and pace: watch for color, aroma and texture changes as you cook. Make small adjustments to heat and seasoning, and allow components to rest when directed to preserve juices and texture.",
    "#{base} Prepare tools and ingredients in advance, sear or cook to the recommended color without overcooking, then remove to a resting tray if needed. Finish by checking seasoning and temperature before assembly.",
    "#{base} Focus on developing flavor and texture at each stage — build fond, reduce liquids or keep components crisp as required. Taste and tweak small seasoning changes so the final dish is balanced."
  ]

  idx = base.hash.abs % templates.length
  templates[idx]
end

# automatic skill assignment based on step text (CORRECTED & PRIORITIZED)
def find_skill_for_step(text)
  t = text.to_s.downcase

  # 1. HOLLANDAISE CHECK
  if t.match?(/whisk|emulsify/) && t.match?(/yolks|butter|gentle\sheat|hollandaise/)
    return Skill.find_by(title: "Making Hollandaise Sauce")
  end

  # 2. VINAIGRETTE CHECK
  if t.match?(/whisk|emulsify/) && t.match?(/vinegar|oil|acid/)
    return Skill.find_by(title: "Emulsifying Vinaigrette")
  end

  # --- General/Other Skills ---
  return Skill.find_by(title: "Dicing an Onion") if t.match?(/\bonion\b|\bdice\b|\bdicing\b/)
  return Skill.find_by(title: "Basic Knife Skills") if t.match?(/\bchop\b|\bslice\b|\bcut\b|\bmince\b|\bknife\b|\bpeel\b/)
  return Skill.find_by(title: "Cutting Julienne") if t.match?(/\bjulienne\b|\bmatchstick\b/)
  return Skill.find_by(title: "Cutting Brunoise") if t.match?(/\bbrunoise\b|\bfine dice\b|\btiny cubes\b/)
  return Skill.find_by(title: "Making a Basic Roux") if t.match?(/\broux\b|\bflour and butter\b|\bthicken\b/)
  return Skill.find_by(title: "Making Béchamel Sauce") if t.match?(/\bbechamel\b|\bwhite sauce\b|\bvelouté\b/)
  return Skill.find_by(title: "Kneading and Proofing Dough") if t.match?(/\bknead\b|\bproof\b|\bdough\b|\bstarter\b|\bferment/)
  return Skill.find_by(title: "Cooking Risotto (Proper Stirring)") if t.match?(/\brisotto\b|\bstir\b|\badd stock\b/)
  return Skill.find_by(title: "Braising Meat") if t.match?(/\bbraise\b|\bslow-cook\b|\bbraising\b/)
  return Skill.find_by(title: "Checking Meat Internal Temperature") if t.match?(/\btemperature\b|\bthermometer\b|\binternal temperature\b|\b74°C\b|\b165°F\b/)

  nil
end

def create_steps_for_recipe(recipe, steps_data)
  steps_data.each do |s|
    skill = find_skill_for_step(s[:content]) rescue nil
    Step.create!(
      title: s[:title],
      content: expand_step(s[:content]),
      recipe: recipe,
      skill: skill
    )
  end
end

REVIEW_TITLES = [
  "Amazing!", "Loved it!", "Pretty good", "Needs improvement",
  "Not bad", "Delicious!", "Would cook again", "A bit bland",
  "Great flavor", "Too complicated", "Perfect for beginners",
  "Total comfort food", "Presentation challenge"
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

# Function to generate unique review content based on recipe type
def generate_review_content(recipe_title, is_special_user)
  case recipe_title
  when "Porcini & Truffle Risotto"
    # Special criteria for Risotto: focus on stirring technique and texture
    if is_special_user
      return { rating: 5, title: "Silky and Perfect!", comment: "The continuous stirring paid off; the rice achieved the perfect creamy texture (all'onda) without being gluey. Excellent recipe for mastering risotto." }
    else
      return { rating: [4, 5].sample, title: "Creamy Comfort", comment: "Great flavor, though it took a lot of wrist work! I focused on adding stock slowly, and the result was delicious." }
    end
  when "Classic Hollandaise (Whisk Method)"
    # Special criteria for Hollandaise: focus on emulsification/difficulty
    if is_special_user
      return { rating: 5, title: "Emulsion Mastered!", comment: "The method for controlling heat with the double boiler was flawless; the emulsion held perfectly, yielding a rich, stable sauce. Highly recommend!" }
    else
      return { rating: [3, 4].sample, title: "A Bit Tricky", comment: "The whisking was tough, and mine almost broke! Managed to rescue it, but it requires full concentration. Good flavor." }
    end
  else
    # Generic content for other recipes
    return {
      rating: [3, 4, 5].sample,
      title: REVIEW_TITLES.sample,
      comment: REVIEW_COMMENTS.sample
    }
  end
end

# Function to create reviews, ensuring one unique review per user per recipe
def create_reviews_for_recipe(recipe, users_array, recipe_author)
  # Ensure the recipe author is not reviewing their own recipe, if possible
  reviewers = users_array.reject { |u| u == recipe_author }.uniq

  # Determine number of reviews (4 to 7)
  num_reviews = rand(4..[7, reviewers.length].min)

  # Select a unique subset of reviewers
  selected_reviewers = reviewers.sample(num_reviews)

  selected_reviewers.each_with_index do |user, index|
    # Determine if this user is a "special" user (Adam is high level, index 0 gets priority)
    is_special_user = (user.username == "Adam" || index == 0)

    review_data = generate_review_content(recipe.title, is_special_user)

    # Create the review only if the user hasn't reviewed the recipe yet (safeguard)
    unless Review.exists?(user: user, recipe: recipe)
      Review.create!(
        # **FIXED: Using 'rate' instead of 'rating' here**
        rate: review_data[:rating],
        title: review_data[:title],
        comment: review_data[:comment],
        recipe: recipe,
        user: user
      )
    end
  end
end

# ---------------------------
# RECIPES (source list you provided)
# ---------------------------
puts "Preparing recipe templates..."

recipes_data = [
  # Recipes 1/31
  {
    title: "Sourdough Boule (Basic)",
    description: "A rustic sourdough boule with crisp crust and open crumb.",
    ingredients: { "active_starter" => "150 g", "bread_flour" => "500 g", "water" => "350 g", "salt" => "10 g" },
    recipe_level: 2,
    meal_prep_time: 1440,
    tips: "Use a mature starter and cold fermentation for best flavor. Handle dough gently to preserve air; score just before baking to guide the oven spring.",
    steps: [
      { title: "Mix & Autolyse", content: "Combine flour and water and rest for 30 minutes; then add starter and salt and mix until incorporated." },
      { title: "Stretch & Fold", content: "Perform a series of stretch-and-folds over a 3–4 hour bulk ferment." },
      { title: "Shape & Bake", content: "Shape gently, proof refrigerated overnight, then bake on a hot steel or Dutch oven until deeply colored." }
    ]
  },
  # Recipe 2/31
  {
    title: "Pain au Levain (Overnight)",
    description: "Country-style loaf with deep flavor developed from a long ferment.",
    ingredients: { "starter" => "200 g", "bread_flour" => "600 g", "water" => "400 g", "salt" => "12 g" },
    recipe_level: 2,
    meal_prep_time: 1440,
    tips: "Long, cool ferment develops complex flavors. Use steam for the first 15 minutes of baking to encourage crust development.",
    steps: [
      { title: "Prepare Dough", content: "Mix starter, flour and water until combined; autolyse and then add salt." },
      { title: "Bulk Ferment", content: "Bulk ferment with periodic folds until doubled." },
      { title: "Bake", content: "Shape, bench rest, final proof and bake with steam for a crisp crust." }
    ]
  },
  # Recipe 3/31
  {
    title: "Lamb Shoulder Confit with Herb Jus",
    description: "Slow-cooked lamb shoulder confit, finished with a concentrated herb jus.",
    ingredients: { "lamb_shoulder" => "1.5 kg", "olive_oil" => "200 ml", "garlic" => "4 cloves", "rosemary" => "2 sprigs" },
    recipe_level: 2,
    meal_prep_time: 480,
    tips: "Cook low and slow until meat yields; then reduce cooking fat and make a jus with pan fond and fresh herbs for a glossy finish.",
    steps: [
      { title: "Season & Slow-Cook", content: "Season shoulder, submerge in oil and cook at low temperature until tender." },
      { title: "Reduce & Finish", content: "Remove meat, reduce cooking liquid and pan juices with herbs to create a concentrated sauce." },
      { title: "Serve", content: "Shred lamb and serve with jus and seasonal sides." }
    ]
  },
  # Recipe 4/31
  {
    title: "Handmade Tagliatelle with Brown Butter Mushrooms",
    description: "Fresh egg tagliatelle tossed with nutty brown butter and sautéed wild mushrooms.",
    ingredients: { "00_flour" => "300 g", "eggs" => "3", "mushrooms" => "300 g", "butter" => "80 g" },
    recipe_level: 2,
    meal_prep_time: 90,
    tips: "Roll pasta thin and dust with semolina to avoid sticking. Brown butter slowly to develop a nutty aroma, add sage if desired.",
    steps: [
      { title: "Make Dough", content: "Combine flour and eggs and knead until smooth; rest 30 minutes." },
      { title: "Roll & Cut", content: "Roll thin then cut into tagliatelle and dust with semolina." },
      { title: "Cook & Toss", content: "Cook pasta and toss with brown butter and sautéed mushrooms." }
    ]
  },
  # Recipe 5/31
  {
    title: "Beef Wellington (Classic)",
    description: "Individual beef wellingtons with mushroom duxelles and prosciutto encased in flaky puff pastry.",
    ingredients: { "beef_fillet" => "800 g", "puff_pastry" => "500 g", "mushrooms" => "300 g", "prosciutto" => "8 slices" },
    recipe_level: 2,
    meal_prep_time: 180,
    tips: "Sear beef quickly to color but keep it rare; chill before wrapping to prevent pastry sogginess. Brush pastry with egg wash for a glossy finish.",
    steps: [
      { title: "Sear Beef", content: "Sear fillet on all sides and cool." },
      { title: "Make Duxelles", content: "Finely chop mushrooms and cook until dry, then cool." },
      { title: "Assemble & Bake", content: "Wrap beef with duxelles and prosciutto in pastry and bake until golden." }
    ]
  },
  # Recipe 6/31
  {
    title: "Confit Duck Leg with Lentils",
    description: "Crisp duck leg confit paired with a mustardy puy lentil salad.",
    ingredients: { "duck_legs" => "4", "duck_fat" => "500 g", "puy_lentils" => "200 g", "shallot" => "1" },
    recipe_level: 2,
    meal_prep_time: 300,
    tips: "Crisp confit skin in a hot oven or pan before serving. Dress lentils with mustard vinaigrette for balance.",
    steps: [
      { title: "Confit Legs", content: "Cook duck legs slowly in fat until tender." },
      { title: "Cook Lentils", content: "Cook puy lentils until tender and toss with vinaigrette." },
      { title: "Crisp & Serve", content: "Crisp duck legs then serve atop lentils." }
    ]
  },
  # Recipe 7/31
  {
    title: "Lobster Thermidor (Restaurant Style)",
    description: "Creamy lobster gratin finished under the broiler with a golden crust.",
    ingredients: { "lobster" => "2 whole", "cream" => "200 ml", "parmesan" => "50 g", "mustard" => "1 tsp" },
    recipe_level: 2,
    meal_prep_time: 90,
    tips: "Cook lobster briefly then remove meat and make a rich cream sauce with brandy and mustard. Top with cheese and gratinate short under high heat.",
    steps: [
      { title: "Cook Lobster", content: "Poach lobsters briefly then extract meat." },
      { title: "Make Thermidor Sauce", content: "Make cream-based sauce, mix with lobster, fill shells and top with cheese." },
      { title: "Gratinate", content: "Broil briefly until golden and bubbling." }
    ]
  },
  # Recipe 8/31 (Risotto - Special Review Target)
  {
    title: "Porcini & Truffle Risotto",
    description: "Silky risotto with rehydrated porcini and a touch of truffle oil.",
    ingredients: { "arborio_rice" => "300 g", "porcini" => "30 g", "parmesan" => "50 g", "truffle_oil" => "1 tsp" },
    recipe_level: 2,
    meal_prep_time: 40,
    tips: "Toast rice before adding stock and add warm stock ladle by ladle while stirring constantly. Finish with butter and parmesan for glossy texture.",
    steps: [
      { title: "Rehydrate Porcini", content: "Soak dried porcini in hot water and reserve soaking liquid." },
      { title: "Toast & Cook Rice", content: "Toast rice, add wine then warm stock gradually while stirring." },
      { title: "Finish", content: "Fold in porcini, butter and parmesan; finish with truffle oil." }
    ]
  },
  # Recipe 9/31
  {
    title: "Sous Vide Short Ribs with Red Wine Reduction",
    description: "Fall-off-the-bone short ribs cooked sous-vide and finished with a glossy red-wine reduction.",
    ingredients: { "beef_short_ribs" => "1.2 kg", "red_wine" => "300 ml", "beef_stock" => "500 ml", "thyme" => "2 sprigs" },
    recipe_level: 2,
    meal_prep_time: 2880,
    tips: "Sous-vide gives perfect tenderness—finish by searing and reducing braising liquid to an intense sauce.",
    steps: [
      { title: "Season & Bag", content: "Season short ribs and vacuum-seal with aromatics." },
      { title: "Sous Vide", content: "Cook sous-vide for 48–72 hours at around 62°C for a tender result." },
      { title: "Finish & Sauce", content: "Sear ribs and reduce braising liquid into a glossy sauce to serve." }
    ]
  },
  # Recipe 10/31
  {
    title: "Beetroot & Goat Cheese Terrine",
    description: "Layered cold terrine of roasted beetroot and whipped goat cheese for elegant starters.",
    ingredients: { "beetroot" => "600 g", "goat_cheese" => "200 g", "gelatin" => "2 sheets", "cream" => "100 ml" },
    recipe_level: 2,
    meal_prep_time: 180,
    tips: "Line terrine tin carefully, press layers firmly and chill thoroughly to set. Slice thinly with a hot knife.",
    steps: [
      { title: "Roast Beets", content: "Roast beets until tender and slice thinly." },
      { title: "Make Cheese Layer", content: "Whip goat cheese with cream and bloom gelatin, combine." },
      { title: "Assemble & Chill", content: "Layer beet and cheese, press and refrigerate until set." }
    ]
  },
  # Recipe 11/31
  {
    title: "Slow-Roasted Prime Rib with Herb Butter",
    description: "Perfectly roasted prime rib served with a compound herb butter.",
    ingredients: { "prime_rib" => "2.5 kg", "butter" => "150 g", "garlic" => "4 cloves", "thyme" => "1 bunch" },
    recipe_level: 2,
    meal_prep_time: 240,
    tips: "Bring roast to room temperature before cooking; reverse sear for best crust and even doneness. Rest long before carving.",
    steps: [
      { title: "Season & Roast Low", content: "Season beef and roast low until near desired temp." },
      { title: "Sear", content: "Sear at high heat to develop crust." },
      { title: "Rest & Serve", content: "Rest and serve with compound herb butter." }
    ]
  },
  # Recipe 12/31
  {
    title: "Gnocchi from Scratch with Sage Brown Butter",
    description: "Pillowy potato gnocchi tossed in sage-infused brown butter.",
    ingredients: { "potatoes" => "800 g", "flour" => "200 g", "egg" => "1", "sage" => "10 leaves" },
    recipe_level: 1,
    meal_prep_time: 60,
    tips: "Use riced potatoes and minimal flour to keep gnocchi tender. Cook in plenty of salted water and toss with hot butter immediately.",
    steps: [
      { title: "Make Gnocchi Dough", content: "Bake potatoes, rice them, mix with flour and egg gently." },
      { title: "Shape & Cook", content: "Cut into pieces, press with a fork and cook until they float." },
      { title: "Brown Butter", content: "Brown butter with sage and toss gnocchi to coat." }
    ]
  },
  # Recipe 13/31
  {
    title: "Charred Octopus with Romesco",
    description: "Tender octopus finished with high-heat charring and smoky romesco sauce.",
    ingredients: { "octopus" => "1.2 kg", "almonds" => "50 g", "roasted_peppers" => "2", "garlic" => "2 cloves" },
    recipe_level: 2,
    meal_prep_time: 180,
    tips: "Simmer octopus gently before charring to ensure tenderness. Use the cooking liquid to reduce and season other components.",
    steps: [
      { title: "Simmer Octopus", content: "Simmer octopus until tender with aromatics then cool." },
      { title: "Make Romesco", content: "Blend roasted peppers, almonds, garlic and olive oil into a sauce." },
      { title: "Char & Serve", content: "Char octopus over high heat and serve with romesco." }
    ]
  },
  # Recipe 14/31
  {
    title: "Whole Roast Branzino with Salsa Verde",
    description: "Simple Mediterranean whole fish roasted with lemon and topped with vibrant salsa verde.",
    ingredients: { "branzino" => "2 whole", "lemon" => "2", "parsley" => "1 bunch", "capers" => "1 tbsp" },
    recipe_level: 1,
    meal_prep_time: 35,
    tips: "Ensure cavity is dry and score skin for even cooking. Add bright salsa verde right before serving to keep herbs fresh.",
    steps: [
      { title: "Prepare Fish", content: "Score and season fish, stuff with herbs and lemon." },
      { title: "Roast", content: "Roast at high heat until skin is crisp and flesh flakes." },
      { title: "Make Salsa Verde", content: "Chop herbs, capers, garlic and mix with olive oil to dress fish." }
    ]
  },
  # Recipe 15/31
  {
    title: "Wild Mushroom Tart with Caramelized Onions",
    description: "Buttery tart filled with caramelized onions, roasted mushrooms and thyme.",
    ingredients: { "puff_pastry" => "1 sheet", "mushrooms" => "300 g", "onions" => "3", "thyme" => "1 tsp" },
    recipe_level: 1,
    meal_prep_time: 60,
    tips: "Caramelize onions slowly for sweetness. Roast mushrooms separately to concentrate flavor and avoid soggy pastry.",
    steps: [
      { title: "Caramelize Onions", content: "Cook onions slowly until deep brown." },
      { title: "Roast Mushrooms", content: "Toss mushrooms with oil and roast to concentrate flavor." },
      { title: "Assemble & Bake", content: "Line tart, add onions and mushrooms, bake until pastry is golden." }
    ]
  },
  # Recipe 16/31
  {
    title: "Seared Scallops with Cauliflower Purée",
    description: "Sweet caramelized scallops resting on silky cauliflower purée and brown butter.",
    ingredients: { "scallops" => "8", "cauliflower" => "1 head", "butter" => "50 g", "cream" => "50 ml" },
    recipe_level: 1,
    meal_prep_time: 30,
    tips: "Pat scallops dry for a good sear. Purée cauliflower until very smooth and warm before plating to keep texture glossy.",
    steps: [
      { title: "Make Purée", content: "Cook cauliflower until tender, blend with cream and butter until silky." },
      { title: "Sear Scallops", content: "Sear scallops in a hot pan quickly until golden." },
      { title: "Plate", content: "Spoon purée, place scallops and drizzle with brown butter." }
    ]
  },
  # Recipe 17/31
  {
    title: "Beet-Cured Salmon Gravlax",
    description: "Cured salmon with beet and dill for striking color and flavor.",
    ingredients: { "salmon" => "800 g", "beetroot" => "200 g", "salt" => "80 g", "sugar" => "40 g", "dill" => "1 bunch" },
    recipe_level: 2,
    meal_prep_time: 72,
    tips: "Press and cure salmon properly in the fridge, flipping occasionally. Slice thinly with a sharp knife to serve.",
    steps: [
      { title: "Prepare Cure", content: "Grate beet and mix with salt, sugar and dill." },
      { title: "Cure Salmon", content: "Press cure onto salmon and refrigerate 48–72 hours." },
      { title: "Slice & Serve", content: "Rinse, pat dry and slice thinly to serve with mustard sauce." }
    ]
  },
  # Recipe 18/31
  {
    title: "Squash Blossoms Fritters (Seasonal)",
    description: "Lightly battered and fried squash blossoms filled with ricotta and herbs.",
    ingredients: { "squash_blossoms" => "12", "ricotta" => "100 g", "flour" => "100 g", "egg" => "1" },
    recipe_level: 1,
    meal_prep_time: 25,
    tips: "Keep batter cold and fry in small batches for a light crisp fritter. Serve immediately for best texture.",
    steps: [
      { title: "Prepare Filling", content: "Mix ricotta with herbs and season." },
      { title: "Batter Blossoms", content: "Dip filled blossoms in batter and fry until golden." },
      { title: "Serve", content: "Drain and serve hot with lemon." }
    ]
  },
  # Recipe 19/31
  {
    title: "Meyer Lemon Tart with Almond Crust",
    description: "Bright, velvety lemon curd in a delicate almond crust.",
    ingredients: { "flour" => "200 g", "almond_powder" => "50 g", "butter" => "100 g", "meyer_lemons" => "3" },
    recipe_level: 1,
    meal_prep_time: 90,
    tips: "Blind-bake the crust to avoid sogginess. Strain lemon curd for silky texture and chill to set firmly before slicing.",
    steps: [
      { title: "Make Crust", content: "Combine flour, ground almonds and butter, press into tart pan and blind-bake." },
      { title: "Make Lemon Curd", content: "Cook lemon juice, zest, sugar and eggs until thick, then strain." },
      { title: "Assemble & Chill", content: "Fill baked shell and chill until firm before serving." }
    ]
  },
  # Recipe 20/31
  {
    title: "Whole Roasted Cauliflower with Tahini & Pomegranate",
    description: "Impressive whole head of roasted cauliflower dressed with tahini and pomegranate seeds.",
    ingredients: { "cauliflower" => "1 head", "tahini" => "60 g", "pomegranate" => "1", "lemon" => "1" },
    recipe_level: 1,
    meal_prep_time: 60,
    tips: "Score the cauliflower base so heat penetrates. Roast until tender and caramelized; spoon tahini sauce and sprinkle pomegranate for contrast.",
    steps: [
      { title: "Prep Cauliflower", content: "Trim base so cauliflower sits flat and rub with oil and spices." },
      { title: "Roast", content: "Roast at high temp until deeply browned." },
      { title: "Dress & Serve", content: "Whisk tahini with lemon, drizzle and finish with pomegranate seeds." }
    ]
  },
  # Recipe 21/31
  {
    title: "Smoked Trout Rillettes on Toast",
    description: "Silky smoked trout mixed with crème fraîche and herbs served on toasted sourdough.",
    ingredients: { "smoked_trout" => "300 g", "creme_fraiche" => "100 g", "lemon" => "1", "dill" => "1 tbsp" },
    recipe_level: 1,
    meal_prep_time: 20,
    tips: "Flake trout and fold gently with crème fraîche; season to taste and serve on well-toasted bread.",
    steps: [
      { title: "Flake Trout", content: "Remove skin and bones and flake trout into pieces." },
      { title: "Mix Rillette", content: "Fold in crème fraîche, lemon and herbs until spreadable." },
      { title: "Serve", content: "Spread on toast and garnish with dill." }
    ]
  },
  # Recipe 22/31
  {
    title: "Charred Broccoli with Anchovy & Lemon",
    description: "High-heat charred broccoli tossed with a punchy anchovy-lemon dressing.",
    ingredients: { "broccoli" => "400 g", "anchovy_fillets" => "2", "lemon" => "1", "olive_oil" => "2 tbsp" },
    recipe_level: 0,
    meal_prep_time: 20,
    tips: "High heat brings out smoky notes; toss with anchovy and lemon for umami brightness. Cook until edges char slightly but stems remain tender.",
    steps: [
      { title: "Char Broccoli", content: "Sear broccoli in a hot skillet or under broiler until charred." },
      { title: "Make Dressing", content: "Whisk anchovy, lemon and olive oil into a coarse dressing." },
      { title: "Toss & Serve", content: "Toss broccoli in dressing and serve hot." }
    ]
  },
  # Recipe 23/31
  {
    title: "Herb-Crusted Rack of Lamb",
    description: "Juicy rack of lamb with a fragrant herb and breadcrumb crust.",
    ingredients: { "rack_of_lamb" => "1 kg", "breadcrumbs" => "50 g", "parsley" => "30 g", "garlic" => "2 cloves" },
    recipe_level: 2,
    meal_prep_time: 60,
    tips: "Frenched racks roast beautifully—sear then coat with herb crust and finish in the oven for a golden finish.",
    steps: [
      { title: "Sear Rack", content: "Season and sear rack quickly to color." },
      { title: "Make Crust", content: "Combine herbs and breadcrumbs and press onto meat." },
      { title: "Roast & Rest", content: "Roast to desired doneness and rest before slicing." }
    ]
  },
  # Recipe 24/31
  {
    title: "Fermented Hot Sauce (Small Batch)",
    description: "A pantry-friendly fermented hot sauce with depth and tang.",
    ingredients: { "chillies" => "300 g", "salt" => "15 g", "garlic" => "2 cloves", "water" => "200 ml" },
    recipe_level: 2,
    meal_prep_time: 720,
    tips: "Keep fermentation vessel clean and monitor daily; taste as it develops and then blend and bottle. Use salted brine proportionally for food safety.",
    steps: [
      { title: "Prepare Chillies", content: "Chop chillies and mix with salt and garlic, pack into jar with brine." },
      { title: "Ferment", content: "Allow to ferment at room temperature for 3–7 days until tangy." },
      { title: "Blend & Bottle", content: "Blend and strain if desired and bottle for storage." }
    ]
  },
  # Recipe 25/31
  {
    title: "Duck à l'Orange",
    description: "Classic roast duck with a glossy orange sauce.",
    ingredients: { "whole_duck" => "2 kg", "orange_juice" => "200 ml", "stock" => "200 ml", "sugar" => "2 tbsp" },
    recipe_level: 2,
    meal_prep_time: 150,
    tips: "Render skin slowly before finishing at higher heat for crispness. Balance sauce with vinegar for acidity and sugar for sweetness to taste.",
    steps: [
      { title: "Prepare Duck", content: "Score skin and render fat by roasting at moderate heat." },
      { title: "Make Sauce", content: "Reduce orange juice, stock and aromatics until glossy." },
      { title: "Finish & Serve", content: "Carve duck and spoon orange sauce over slices." }
    ]
  },
  # Recipe 26/31
  {
    title: "Oxtail Ragu with Pappardelle",
    description: "Long-simmered oxtail ragu rich in gelatin and flavor, served over broad pasta.",
    ingredients: { "oxtail" => "1.2 kg", "tomato" => "400 g", "red_wine" => "250 ml", "pappardelle" => "400 g" },
    recipe_level: 2,
    meal_prep_time: 360,
    tips: "Brown bones well for flavor, then simmer low and slow. Skim fat as needed and reduce sauce until glossy to serve with pasta.",
    steps: [
      { title: "Brown Oxtail", content: "Sear oxtail pieces until well-browned." },
      { title: "Simmer", content: "Add wine, tomatoes and aromatics and simmer until meat falls off the bone." },
      { title: "Finish & Serve", content: "Shred meat into sauce and serve with pappardelle." }
    ]
  },
  # Recipe 27/31 (Hollandaise - Special Review Target)
  {
    title: "Classic Hollandaise (Whisk Method)",
    description: "A rich, emulsified butter sauce perfect for eggs Benedict or steamed asparagus.",
    ingredients: { "egg_yolks" => "3", "butter" => "150 g", "lemon" => "1", "salt" => "to taste" },
    recipe_level: 2,
    meal_prep_time: 15,
    tips: "Use gentle heat and whisk continuously to prevent curdling; if broken, rescue with a warm water bath or by adding a spoon of hot water slowly while whisking.",
    steps: [
      { title: "Heat Butter", content: "Clarify butter and keep warm." },
      { title: "Whisk Yolks", content: "Whisk yolks over gentle heat then slowly incorporate butter to emulsify." },
      { title: "Season & Serve", content: "Season with lemon and salt and serve immediately." }
    ]
  },
  # Recipe 28/31
  {
    title: "Sunchoke Velouté with Crispy Pancetta",
    description: "Silky sunchoke soup finished with salty crispy pancetta and chives.",
    ingredients: { "sunchokes" => "400 g", "stock" => "800 ml", "butter" => "30 g", "pancetta" => "80 g" },
    recipe_level: 1,
    meal_prep_time: 45,
    tips: "Sautée aromatics until soft then add sunchokes and stock; blend until smooth and finish with butter for sheen.",
    steps: [
      { title: "Sauté Aromatics", content: "Sauté shallots and garlic in butter until translucent." },
      { title: "Simmer & Blend", content: "Add sunchokes and stock, simmer, then blend until silky." },
      { title: "Finish", content: "Fry pancetta until crisp and garnish with chives." }
    ]
  },
  # Recipe 29/31
  {
    title: "Grilled Octopus with Citrus & Herbs",
    description: "Tender grilled octopus with a bright citrus herb dressing.",
    ingredients: { "octopus" => "1 kg", "olive_oil" => "50 ml", "orange" => "1", "oregano" => "1 tbsp" },
    recipe_level: 1,
    meal_prep_time: 120,
    tips: "Cook octopus until tender before briefly grilling for char. Dress right before serving to keep herbs fresh.",
    steps: [
      { title: "Simmer Octopus", content: "Simmer octopus with aromatics until tender." },
      { title: "Grill", content: "Char on a hot grill then slice." },
      { title: "Dress", content: "Toss with citrus, oil and herbs and serve." }
    ]
  },
  # Recipe 30/31
  {
    title: "Lamb Merguez with Preserved Lemon Couscous",
    description: "Spiced merguez sausages served over couscous studded with preserved lemon and herbs.",
    ingredients: { "lamb" => "500 g", "couscous" => "200 g", "preserved_lemon" => "1", "cumin" => "1 tsp" },
    recipe_level: 1,
    meal_prep_time: 40,
    tips: "Pan-fry or grill merguez until nicely charred; fluff couscous with fork and stir in preserved lemon for brightness.",
    steps: [
      { title: "Cook Merguez", content: "Grill or fry sausages until charred and cooked through." },
      { title: "Prepare Couscous", content: "Steam or soak couscous then fluff and mix with chopped preserved lemon." },
      { title: "Assemble", content: "Serve sausages on the couscous with parsley." }
    ]
  },
  # Recipe 31/31
  {
    title: "Black Garlic & Beef Short Rib Tartine",
    description: "Rich shredded short rib on toasted country bread with black garlic aioli.",
    ingredients: { "short_rib" => "800 g", "bread" => "4 slices", "black_garlic" => "4 cloves", "mayonnaise" => "50 g" },
    recipe_level: 1,
    meal_prep_time: 240,
    tips: "Simmer short ribs until pullable and toss with reduced braising liquid; spread aioli on toast for contrast.",
    steps: [
      { title: "Braise Short Ribs", content: "Cook ribs low until pullable." },
      { title: "Make Aioli", content: "Blend black garlic with mayonnaise and season." },
      { title: "Assemble", content: "Toast bread, top with shredded short rib and aioli." }
    ]
  }
] # End of recipes_data array

puts "Creating Recipes and Steps..."

created_recipes = []

recipes_data.each do |r_data|
  # 1. Create Recipe
  recipe = Recipe.create!(
    title: r_data[:title],
    description: r_data[:description],
    ingredients: r_data[:ingredients],
    recipe_level: r_data[:recipe_level],
    meal_prep_time: r_data[:meal_prep_time],
    tips: r_data[:tips],
    user: recipe_author # Assign the primary author
  )

  # 2. Create Steps
  create_steps_for_recipe(recipe, r_data[:steps])

  created_recipes << recipe
end

puts "Created #{Recipe.count} recipes."

# ---------------------------
# REVIEWS
# ---------------------------
puts "Creating Reviews (4-7 unique reviews per recipe)..."

# Ensure all users are available for review assignment
all_review_users = [user_santi, user_john, user_maria, user_david, user_elena, user_adam, generic_user]

created_recipes.each do |recipe|
  create_reviews_for_recipe(recipe, all_review_users, recipe_author)
end

puts "Created #{Review.count} total reviews."
puts "Seed completed successfully!"
