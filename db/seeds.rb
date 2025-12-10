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
  { title: "Basic Knife Skills", description: "Learn the proper grip and basic cuts like chop, dice, and mince.", video: "ypjsz5i7fozswa6l5rxy.mp4", skill_level: 0 },
  { title: "Making Hollandaise Sauce", description: "Master the classic French emulsion sauce made from egg yolks, melted butter, and lemon juice.", video: "hhinzxu2qyahhouygjro.mp4", skill_level: 1
}
])


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
user = User.create!(
  email: "adam@lewagon.com",
  password: "password",
  username: "Adam",
  level: 5,
  xp: 125
)

generic_user = User.create!(
  email: "generic@test.com",
  password: "password",
  username: "Maria Doe"
)

puts "Created users: #{User.count}"

# ---------------------------
# HELPERS
# ---------------------------

# Expand a short step into a more detailed chef-style 2-3 sentence instruction (~20-40 words)
def expand_step(text)
  base = text.to_s.strip
  # Ensure base ends with a period for smooth concatenation
  base = base.chomp(".") + "."

  templates = [
    "#{base} Start by preparing your mise en place so you have everything at hand; pay attention to heat and timing. Work deliberately and adjust seasoning as you go for balanced flavor.",
    "#{base} Heat the appropriate pan or oven to the right temperature before starting, then proceed keeping an eye on texture and color. Move quickly when necessary and rest components where the recipe requires.",
    "#{base} Use correct technique and pace: watch for color, aroma and texture changes as you cook. Make small adjustments to heat and seasoning, and allow components to rest when directed to preserve juices and texture.",
    "#{base} Prepare tools and ingredients in advance, sear or cook to the recommended color without overcooking, then remove to a resting tray if needed. Finish by checking seasoning and temperature before assembly.",
    "#{base} Focus on developing flavor and texture at each stage — build fond, reduce liquids or keep components crisp as required. Taste and tweak small seasoning changes so the final dish is balanced."
  ]

  # Choose a template pseudo-randomly but deterministic per input text to reduce near duplicates:
  idx = base.hash.abs % templates.length
  templates[idx]
end

# automatic skill assignment based on step text
def find_skill_for_step(text)
  t = text.to_s.downcase
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
  return Skill.find_by(title: "Making Hollandaise Sauce") if t.match?(/whisk|emulsify/) && t.match?(/yolks|butter|gentle\sheat/)
  return Skill.find_by(title: "Emulsifying Vinaigrette") if t.match?(/whisk|emulsify/) && t.match?(/vinegar|oil|acid/)
  nil
end

def create_steps_for_recipe(recipe, steps_data)
  steps_data.each do |s|
    # note: find_skill_for_step expects the original (short) text to map skill; keep mapping stable
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

# ---------------------------
# RECIPES (source list you provided)
# ---------------------------
puts "Preparing recipe templates..."

recipes_data = [
  # Recipes 1..75 (full list you provided).
  # For brevity I include the same data you supplied exactly for titles/ingredients/tips,
  # but step content will be expanded by create_steps_for_recipe using expand_step.
  # (All items kept exactly as per your last seed body.)
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
  {
    title: "Black Garlic & Beef Short Rib Tartine",
    description: "Rich shredded short rib on toasted country bread with black garlic aioli.",
    ingredients: { "short_rib" => "800 g", "bread" => "4 slices", "black_garlic" => "4 cloves", "mayonnaise" => "50 g" },
    recipe_level: 1,
    meal_prep_time: 240,
    tips: "Simmer short ribs until pullable and toss with reduced braising liquid; spread aioli on toast for contrast.",
    steps: [
      { title: "Braise Short Ribs", content: "Cook ribs low until tender; shred." },
      { title: "Make Aioli", content: "Blend black garlic with mayo to make aioli." },
      { title: "Assemble", content: "Pile meat on toast and drizzle with aioli." }
    ]
  },
  {
    title: "Seared Foie Gras with Fig Compote",
    description: "Luscious foie gras pan-seared and served with a sweet-tart fig compote.",
    ingredients: { "foie_gras" => "200 g", "figs" => "200 g", "balsamic" => "1 tbsp", "sugar" => "20 g" },
    recipe_level: 2,
    meal_prep_time: 25,
    tips: "Score foie gras lightly and sear briefly on high heat; pair with a bright compote to cut richness.",
    steps: [
      { title: "Make Compote", content: "Cook figs with a bit of sugar and balsamic until jammy." },
      { title: "Sear Foie", content: "Sear foie gras slices quickly until browned." },
      { title: "Serve", content: "Plate foie with a spoonful of compote." }
    ]
  },
  {
    title: "Mackerel Escabeche with Pickled Shallots",
    description: "Pan-fried mackerel preserved briefly in bright vinegary escabeche with quick-pickled shallots.",
    ingredients: { "mackerel" => "2 fillets", "vinegar" => "100 ml", "shallot" => "2", "olive_oil" => "2 tbsp" },
    recipe_level: 1,
    meal_prep_time: 30,
    tips: "Quick-pickle shallots to add brightness and serve fish damp to absorb escabeche flavors.",
    steps: [
      { title: "Fry Fish", content: "Pan-fry mackerel until crisp." },
      { title: "Make Escabeche", content: "Warm vinegar with herbs and pour over fish with pickled shallots." },
      { title: "Rest & Serve", content: "Let flavors mingle briefly before serving." }
    ]
  },
  {
    title: "Pumpkin Ravioli with Sage Brown Butter",
    description: "Hand-rolled ravioli filled with roasted pumpkin, topped with sage brown butter and crispy hazelnuts.",
    ingredients: { "pumpkin" => "400 g", "ricotta" => "100 g", "pasta_dough" => "400 g", "hazelnuts" => "30 g" },
    recipe_level: 2,
    meal_prep_time: 120,
    tips: "Roast pumpkin to concentrate sweetness; keep filling dry to avoid soggy ravioli. Seal edges well and cook gently in simmering water.",
    steps: [
      { title: "Make Filling", content: "Puree roasted pumpkin, mix with ricotta and season." },
      { title: "Form Ravioli", content: "Roll dough thin and fill, sealing edges carefully." },
      { title: "Cook & Finish", content: "Cook ravioli briefly and toss with sage brown butter and hazelnuts." }
    ]
  },
  {
    title: "Preserved Lemon & Olive Chicken Tagine",
    description: "Moroccan-inspired tagine with preserved lemon, olives and tender braised chicken.",
    ingredients: { "chicken" => "1.2 kg", "preserved_lemon" => "1", "olives" => "100 g", "coriander" => "1 bunch" },
    recipe_level: 1,
    meal_prep_time: 90,
    tips: "Use a heavy pot for even simmering; balance salt due to preserved lemon and olives. Serve over couscous to soak the sauce.",
    steps: [
      { title: "Brown Chicken", content: "Sear chicken pieces until colored." },
      { title: "Simmer with Lemon", content: "Add preserved lemon, olives and stock then simmer until tender." },
      { title: "Finish", content: "Adjust seasoning and finish with fresh herbs." }
    ]
  },
  {
    title: "Sea Bream en Papillote with Fennel & Orange",
    description: "Delicate parcels of sea bream steamed with fennel and orange slices.",
    ingredients: { "sea_bream" => "2 fillets", "fennel" => "1 bulb", "orange" => "1", "olive_oil" => "2 tbsp" },
    recipe_level: 0,
    meal_prep_time: 25,
    tips: "Seal packets tightly and steam to gently cook fish; open at table for visual effect and fragrance.",
    steps: [
      { title: "Prepare Vegetables", content: "Thinly slice fennel and orange." },
      { title: "Assemble & Seal", content: "Place fish and vegetables in parchment and seal." },
      { title: "Bake", content: "Bake until fish is just cooked through." }
    ]
  },
  {
    title: "Saffron & Mussel Broth",
    description: "A fragrant broth with steamed mussels, saffron and garlic served with crusty bread.",
    ingredients: { "mussels" => "1 kg", "saffron" => "a pinch", "garlic" => "3 cloves", "white_wine" => "150 ml" },
    recipe_level: 1,
    meal_prep_time: 20,
    tips: "Clean mussels well and discard any that are open. Add saffron early to infuse the broth and serve with toasted bread to soak up juices.",
    steps: [
      { title: "Sauté Aromatics", content: "Sauté garlic and shallot then add wine and saffron." },
      { title: "Steam Mussels", content: "Add mussels and steam until they open." },
      { title: "Serve", content: "Ladle into bowls and serve with bread." }
    ]
  },
  {
    title: "Roasted Pork Belly with Apple Compote",
    description: "Crispy-skinned pork belly paired with a tart apple compote.",
    ingredients: { "pork_belly" => "1 kg", "apples" => "3", "vinegar" => "2 tbsp", "sugar" => "1 tbsp" },
    recipe_level: 2,
    meal_prep_time: 180,
    tips: "Score skin, dry thoroughly and roast low then high to render fat and crisp the skin. Balance richness with a bright apple compote.",
    steps: [
      { title: "Prep Skin", content: "Score the skin and pat dry; season." },
      { title: "Roast Low & High", content: "Roast slowly then finish at high heat to crisp." },
      { title: "Make Compote", content: "Cook apples with sugar and vinegar until broken down and tangy." }
    ]
  },
  {
    title: "Caramelized Onion & Gruyere Galette",
    description: "Rustic free-form tart filled with sweet onions and nutty Gruyère cheese.",
    ingredients: { "puff_pastry" => "1 sheet", "onions" => "3", "gruyere" => "100 g", "thyme" => "1 tsp" },
    recipe_level: 0,
    meal_prep_time: 60,
    tips: "Caramelize onions thoroughly for maximum sweetness; fold edges of pastry for a rustic look and brush with egg wash.",
    steps: [
      { title: "Caramelize Onions", content: "Cook onions slowly until deep golden." },
      { title: "Assemble Galette", content: "Spread onions onto pastry, sprinkle cheese and fold edges." },
      { title: "Bake", content: "Bake until pastry is golden and cheese melted." }
    ]
  },
  {
    title: "Mole Poblano with Roasted Chicken",
    description: "Complex Mexican mole sauce served over roasted chicken pieces.",
    ingredients: { "dried_chiles" => "60 g", "chocolate" => "20 g", "chicken" => "1.5 kg", "nuts" => "50 g" },
    recipe_level: 2,
    meal_prep_time: 180,
    tips: "Toast and grind spices and chilies for the deepest flavor; balance bittersweet chocolate with acidity and salt.",
    steps: [
      { title: "Toast Ingredients", content: "Toast chilies, seeds and nuts, then grind into a paste." },
      { title: "Simmer Sauce", content: "Cook sauce slowly with stock and chocolate until balanced." },
      { title: "Roast Chicken", content: "Roast chicken and coat with mole before serving." }
    ]
  },
  {
    title: "Smoked Bone Marrow with Parsley Salad",
    description: "Roasted bone marrow served with a bright parsley and caper salad on toasted bread.",
    ingredients: { "beef_marrow_bones" => "4", "parsley" => "1 bunch", "capers" => "1 tbsp", "bread" => "4 slices" },
    recipe_level: 2,
    meal_prep_time: 60,
    tips: "Roast marrow bones until bubbling and golden; balance the richness with a zippy parsley-caper salad and toasted bread.",
    steps: [
      { title: "Roast Marrow", content: "Roast bones until marrow is soft and spoonable." },
      { title: "Make Salad", content: "Chop parsley, capers and lemon to make a bright salad." },
      { title: "Serve", content: "Spoon marrow onto toast and top with salad." }
    ]
  },
  {
    title: "Vegan Miso Glazed Aubergine",
    description: "Sticky miso glaze caramelizes on roasted aubergine for an umami-rich vegetarian main.",
    ingredients: { "aubergine" => "2", "miso" => "2 tbsp", "mirin" => "1 tbsp", "sugar" => "1 tsp" },
    recipe_level: 0,
    meal_prep_time: 35,
    tips: "Score aubergine flesh to help glaze penetrate. Roast until very soft and brush glaze in final minutes to caramelize.",
    steps: [
      { title: "Prep Aubergine", content: "Halve and score aubergines, brush with oil." },
      { title: "Roast & Glaze", content: "Roast until tender, brush with miso glaze and roast until caramelized." },
      { title: "Serve", content: "Serve with sesame and scallions." }
    ]
  },
  {
    title: "Crispy Skin Salmon with Fennel & Apple Slaw",
    description: "Pan-seared salmon with a bright slaw of fennel and apple for contrast.",
    ingredients: { "salmon" => "2 fillets", "fennel" => "1", "apple" => "1", "lemon" => "1" },
    recipe_level: 0,
    meal_prep_time: 25,
    tips: "Dry skin thoroughly and sear skin-side down until golden and crisp. Keep slaw crisp by dressing at the last moment.",
    steps: [
      { title: "Prepare Slaw", content: "Thinly slice fennel and apple and toss with lemon and oil." },
      { title: "Sear Salmon", content: "Sear salmon skin-side down until crisp." },
      { title: "Serve", content: "Serve salmon over slaw with a squeeze of lemon." }
    ]
  },
  {
    title: "Pork Tenderloin with Mustard & Cider Sauce",
    description: "Juicy pork tenderloin roasted and finished with a pan sauce of cider and wholegrain mustard.",
    ingredients: { "pork_tenderloin" => "800 g", "cider" => "200 ml", "mustard" => "2 tbsp", "cream" => "50 ml" },
    recipe_level: 1,
    meal_prep_time: 45,
    tips: "Sear the pork first for color and finish in the oven. Deglaze the pan with cider and reduce to make a glossy sauce.",
    steps: [
      { title: "Sear Pork", content: "Season and sear pork on all sides." },
      { title: "Roast", content: "Roast until just cooked through and rest." },
      { title: "Sauce", content: "Deglaze pan with cider and whisk in mustard and cream to finish." }
    ]
  },
  {
    title: "Cured Egg Yolks over Burrata",
    description: "Intense umami cured yolks shaved over creamy burrata for an elegant starter.",
    ingredients: { "egg_yolks" => "6", "salt" => "200 g", "sugar" => "200 g", "burrata" => "1 ball" },
    recipe_level: 2,
    meal_prep_time: 1440,
    tips: "Cure yolks in a dense salt-sugar mix until firm, then rinse and dehydrate. Shave over burrata for a salty, savory accent.",
    steps: [
      { title: "Cure Yolks", content: "Separate yolks and cure in salt-sugar bed until firm." },
      { title: "Dry & Store", content: "Rinse and dry cured yolks then store in airtight container." },
      { title: "Serve", content: "Shave over burrata with olive oil and cracked pepper." }
    ]
  },
  {
    title: "Instant Pot Coq au Vin (Modern)",
    description: "Classic coq au vin adapted for pressure cooking with deep flavor in less time.",
    ingredients: { "chicken" => "1.2 kg", "red_wine" => "400 ml", "mushrooms" => "200 g", "bacon" => "100 g" },
    recipe_level: 1,
    meal_prep_time: 75,
    tips: "Use good quality wine for depth, and finish with a knob of butter for gloss. Deglaze the pot well before pressure cooking to capture all fond.",
    steps: [
      { title: "Brown Chicken & Bacon", content: "Sear chicken and bacon in pot to develop color." },
      { title: "Pressure Cook", content: "Add wine, stock and aromatics and cook under pressure until tender." },
      { title: "Finish", content: "Reduce sauce and add mushrooms, finish with butter." }
    ]
  },
  {
    title: "Smoked Paprika Roasted Eggplant with Yogurt",
    description: "Rich smoked paprika and roasted eggplant served with cool herbed yogurt.",
    ingredients: { "eggplant" => "2", "smoked_paprika" => "1 tbsp", "yogurt" => "150 g", "garlic" => "1 clove" },
    recipe_level: 0,
    meal_prep_time: 40,
    tips: "Char eggplant well for smokiness; blend with yogurt for a creamy contrast. Serve with grilled bread.",
    steps: [
      { title: "Roast Eggplant", content: "Roast or grill eggplant until charred and collapse." },
      { title: "Blend", content: "Blend roasted flesh with yogurt and smoked paprika." },
      { title: "Serve", content: "Serve with warm flatbread and herbs." }
    ]
  },
  {
    title: "Citrus-Cured Sea Bass with Avocado",
    description: "Lightly cured sea bass in citrus, served with creamy avocado and microherbs.",
    ingredients: { "sea_bass" => "400 g", "lime" => "2", "orange" => "1", "avocado" => "1" },
    recipe_level: 1,
    meal_prep_time: 60,
    tips: "Cure briefly for a ceviche-style texture. Use very fresh fish and serve chilled with bright citrus and avocado.",
    steps: [
      { title: "Cure Fish", content: "Marinate thin slices in citrus juice for a short cure." },
      { title: "Prepare Avocado", content: "Dice avocado and season lightly." },
      { title: "Assemble", content: "Plate cured fish with avocado and herbs." }
    ]
  },
  {
    title: "Maple & Mustard Glazed Suckling Pig Shoulder",
    description: "Slow-roasted pork shoulder with sticky maple and mustard glaze for a show-stopping dish.",
    ingredients: { "pork_shoulder" => "2 kg", "maple_syrup" => "100 ml", "mustard" => "3 tbsp", "garlic" => "3 cloves" },
    recipe_level: 2,
    meal_prep_time: 360,
    tips: "Cook low then finish at high heat to caramelize glaze. Rest long to keep juices and carve carefully for presentation.",
    steps: [
      { title: "Slow Roast", content: "Slow roast until meat is tender and forkable." },
      { title: "Glaze & Finish", content: "Brush glaze and roast at high heat to caramelize." },
      { title: "Rest & Carve", content: "Rest and carve for serving." }
    ]
  },
  {
    title: "Brown Butter Sage Gnocchi with Pumpkin",
    description: "Tender gnocchi in brown butter with roasted pumpkin and crispy sage.",
    ingredients: { "gnocchi" => "500 g", "pumpkin" => "200 g", "butter" => "80 g", "sage" => "10 leaves" },
    recipe_level: 1,
    meal_prep_time: 35,
    tips: "Roast pumpkin to concentrate flavor; crisp sage separately and add at the end for texture contrast.",
    steps: [
      { title: "Roast Pumpkin", content: "Roast pumpkin and keep warm." },
      { title: "Cook Gnocchi", content: "Boil gnocchi until they float." },
      { title: "Brown Butter & Serve", content: "Brown butter, add sage and toss gnocchi with pumpkin." }
    ]
  },
  {
    title: "Beet, Fennel & Goat Cheese Salad",
    description: "Delicate salad of roasted beets, crisp fennel, and creamy goat cheese with walnuts.",
    ingredients: { "beetroot" => "400 g", "fennel" => "1 bulb", "goat_cheese" => "80 g", "walnuts" => "30 g" },
    recipe_level: 0,
    meal_prep_time: 35,
    tips: "Roast beets until tender and slice thinly; dress just before serving to keep fennel crisp.",
    steps: [
      { title: "Roast Beets", content: "Roast beets until tender and cool." },
      { title: "Slice Fennel", content: "Thinly slice fennel bulb." },
      { title: "Assemble", content: "Combine, crumble goat cheese and sprinkle walnuts with vinaigrette." }
    ]
  },
  {
    title: "Comté & Caramelized Onion Grilled Cheese",
    description: "Elevated grilled cheese with nutty Comté and slowly caramelized onions.",
    ingredients: { "bread" => "4 slices", "comte" => "150 g", "onions" => "2", "butter" => "30 g" },
    recipe_level: 0,
    meal_prep_time: 25,
    tips: "Caramelize onions low and slow for sweetness; use good quality bread and low heat to melt cheese without burning bread.",
    steps: [
      { title: "Caramelize Onions", content: "Cook onions until golden and sweet." },
      { title: "Assemble Sandwich", content: "Layer cheese and onions between bread slices." },
      { title: "Grill", content: "Grill slowly until cheese melts and bread crisps." }
    ]
  },
  {
    title: "Smoked Salmon & Potato Rösti",
    description: "Crispy potato rösti topped with silky smoked salmon and crème fraîche.",
    ingredients: { "potatoes" => "600 g", "smoked_salmon" => "150 g", "egg" => "1", "crème_fraiche" => "50 g" },
    recipe_level: 0,
    meal_prep_time: 40,
    tips: "Grate potatoes and wring out excess moisture to get a crisp rösti; top with cold smoked salmon and a dollop of crème fraîche.",
    steps: [
      { title: "Prepare Potatoes", content: "Grate and squeeze dry then mix with egg." },
      { title: "Fry Rösti", content: "Form patties and fry until crisp on both sides." },
      { title: "Top & Serve", content: "Top with salmon and crème fraîche." }
    ]
  },
  {
    title: "Pumpkin Seed Pesto with Wholegrain Pasta",
    description: "Nutty pumpkin seed pesto tossed with al dente wholegrain pasta.",
    ingredients: { "pumpkin_seeds" => "60 g", "parmesan" => "50 g", "olive_oil" => "60 ml", "pasta" => "300 g" },
    recipe_level: 0,
    meal_prep_time: 20,
    tips: "Toast seeds briefly before blending for extra flavor and texture. Reserve pasta water to loosen the pesto.",
    steps: [
      { title: "Toast Seeds", content: "Toast pumpkin seeds until fragrant." },
      { title: "Blend Pesto", content: "Blend seeds, parmesan, garlic and oil to desired consistency." },
      { title: "Toss Pasta", content: "Toss with pasta and a splash of pasta water." }
    ]
  },
  {
    title: "Crispy Skin Monkfish with Herb Butter",
    description: "Firm monkfish seared to create a crispy exterior and served with herbed butter.",
    ingredients: { "monkfish" => "400 g", "butter" => "60 g", "parsley" => "1 bunch", "lemon" => "1" },
    recipe_level: 1,
    meal_prep_time: 20,
    tips: "Pat fish dry, sear quickly and finish with a spoon of herb butter to baste for gloss and flavor.",
    steps: [
      { title: "Sear Monkfish", content: "Sear fillets until golden." },
      { title: "Make Herb Butter", content: "Mix softened butter with chopped herbs and lemon." },
      { title: "Finish", content: "Baste fish with herb butter before serving." }
    ]
  },
  {
    title: "Classic Tarte Tatin",
    description: "Upside-down caramelized apple tart with a flaky pastry top.",
    ingredients: { "apples" => "6", "butter" => "100 g", "sugar" => "150 g", "puff_pastry" => "1 sheet" },
    recipe_level: 1,
    meal_prep_time: 75,
    tips: "Caramelize sugar and butter until amber then arrange apples tightly; top with pastry and bake, invert carefully after resting.",
    steps: [
      { title: "Caramelize Apples", content: "Cook apples in caramel until coated." },
      { title: "Top with Pastry", content: "Cover apples with pastry and bake until golden." },
      { title: "Invert & Serve", content: "Let cool slightly then invert onto plate." }
    ]
  },
  {
    title: "Fermented Sourdough Pancakes",
    description: "Light, tangy pancakes made with a sourdough discard for depth and texture.",
    ingredients: { "sourdough_discard" => "200 g", "flour" => "150 g", "milk" => "200 ml", "egg" => "1" },
    recipe_level: 1,
    meal_prep_time: 30,
    tips: "Use active discard and rest batter briefly. Cook on medium heat for even browning and serve with seasonal fruit.",
    steps: [
      { title: "Mix Batter", content: "Combine discard, flour, milk and egg and rest." },
      { title: "Cook Pancakes", content: "Pour batter onto hot pan and cook until set, flip and finish." },
      { title: "Serve", content: "Serve warm with toppings." }
    ]
  },
  {
    title: "Cider-Poached Pears with Vanilla Cream",
    description: "Elegant poached pears in cider with a lightly whipped vanilla cream.",
    ingredients: { "pears" => "4", "cider" => "500 ml", "vanilla" => "1 pod", "cream" => "200 ml" },
    recipe_level: 0,
    meal_prep_time: 45,
    tips: "Poach gently to keep pears intact. Chill in poaching liquid for deeper flavor and serve with lightly whipped cream.",
    steps: [
      { title: "Poach Pears", content: "Poach pears in cider with vanilla until tender." },
      { title: "Make Cream", content: "Whip cream with vanilla and sugar lightly." },
      { title: "Serve", content: "Serve pears with cream and reduced poaching syrup." }
    ]
  },
  {
    title: "Charred Leek & Ricotta Galette",
    description: "Rustic galette with charred leeks, creamy ricotta and lemon zest.",
    ingredients: { "leeks" => "3", "ricotta" => "200 g", "puff_pastry" => "1 sheet", "lemon" => "1" },
    recipe_level: 0,
    meal_prep_time: 45,
    tips: "Char leeks to concentrate flavor and keep galette rustic by folding edges; brush with egg wash for sheen.",
    steps: [
      { title: "Char Leeks", content: "Char leeks on high heat then slice." },
      { title: "Assemble Galette", content: "Spread ricotta, top with leeks and fold edges." },
      { title: "Bake", content: "Bake until golden." }
    ]
  },
  {
    title: "Citrus & Herb Crusted Halibut",
    description: "Firm halibut fillets with a bright citrus-herb crust and beurre blanc.",
    ingredients: { "halibut" => "2 fillets", "bread_crumbs" => "50 g", "lemon" => "1", "butter" => "60 g" },
    recipe_level: 1,
    meal_prep_time: 25,
    tips: "Pat fish dry and press crust firmly; cook gently to avoid drying and pair with a smooth beurre blanc.",
    steps: [
      { title: "Make Crust", content: "Combine crumbs, zest and herbs and press onto fish." },
      { title: "Sear & Finish", content: "Sear fish and finish in oven if needed." },
      { title: "Sauce", content: "Make beurre blanc and spoon over plated fish." }
    ]
  },
  {
    title: "Truffled Mushroom Wellington (Vegetarian)",
    description: "A vegetarian twist on Wellington with truffled wild mushrooms and spinach.",
    ingredients: { "puff_pastry" => "1 sheet", "mushrooms" => "400 g", "spinach" => "150 g", "truffle_oil" => "1 tsp" },
    recipe_level: 2,
    meal_prep_time: 90,
    tips: "Cook mushrooms until dry to avoid soggy pastry. Chill filling before wrapping in pastry for clean edges.",
    steps: [
      { title: "Make Filling", content: "Sauté mushrooms with herbs until concentrated and mix with spinach." },
      { title: "Assemble & Bake", content: "Wrap in pastry and bake until golden." },
      { title: "Serve", content: "Slice and serve with truffle oil drizzle." }
    ]
  },
  {
    title: "Spiced Lamb Kofta with Yogurt & Preserved Lemon",
    description: "Grilled lamb kofta served with cooling yogurt and chopped preserved lemon.",
    ingredients: { "lamb" => "500 g", "cumin" => "1 tsp", "preserved_lemon" => "1", "yogurt" => "150 g" },
    recipe_level: 0,
    meal_prep_time: 35,
    tips: "Keep kofta mixture light and bind with minimal breadcrumbs; chill briefly before grilling for better shape retention.",
    steps: [
      { title: "Mix Kofta", content: "Combine lamb with spices and shape onto skewers." },
      { title: "Grill", content: "Grill until cooked through and charred." },
      { title: "Serve", content: "Serve with yogurt and preserved lemon." }
    ]
  },
  {
    title: "Vanilla Bean Panna Cotta with Berry Compote",
    description: "Silky panna cotta set with gelatin and topped with a bright berry compote.",
    ingredients: { "cream" => "400 ml", "vanilla" => "1 pod", "gelatin" => "3 sheets", "berries" => "200 g" },
    recipe_level: 0,
    meal_prep_time: 360,
    tips: "Bloom gelatin properly and strain panna cotta for a silky finish. Chill thoroughly before unmolding and serve with a bright compote.",
    steps: [
      { title: "Heat Cream", content: "Warm cream with vanilla then stir in bloomed gelatin." },
      { title: "Chill", content: "Pour into molds and chill until set." },
      { title: "Make Compote", content: "Simmer berries with sugar until syrupy and serve over panna cotta." }
    ]
  },
  {
    title: "Harissa Lamb Shanks with Preserved Lemon Couscous",
    description: "Slow-braised lamb shanks with harissa-spiced sauce and fragrant couscous.",
    ingredients: { "lamb_shanks" => "1.2 kg", "harissa" => "2 tbsp", "preserved_lemon" => "1", "couscous" => "200 g" },
    recipe_level: 2,
    meal_prep_time: 240,
    tips: "Braise slowly until tender and reduce braising liquid to a glossy sauce. Serve with couscous to soak up the sauce.",
    steps: [
      { title: "Brown & Braise", content: "Brown shanks then braise with harissa and stock until tender." },
      { title: "Reduce", content: "Remove shanks and reduce sauce for intensity." },
      { title: "Serve", content: "Serve over couscous with preserved lemon and herbs." }
    ]
  },
  {
    title: "Pistachio-Crusted Lamb Chops with Mint Gremolata",
    description: "Lamb chops seared and topped with a crunchy pistachio-mint gremolata.",
    ingredients: { "lamb_chops" => "8", "pistachios" => "80 g", "mint" => "1 bunch", "lemon" => "1" },
    recipe_level: 1,
    meal_prep_time: 30,
    tips: "Toast pistachios before pulsing for crumbly texture; sear chops hot and rest briefly before serving with gremolata.",
    steps: [
      { title: "Toast Pistachios", content: "Toast and pulse pistachios to coarse crumbs." },
      { title: "Sear Chops", content: "Sear lamb chops to desired doneness." },
      { title: "Garnish", content: "Top chops with mint gremolata." }
    ]
  },
  {
    title: "Celery Root & Apple Gratin",
    description: "Layered celery root and apple gratin baked with cream and Gruyère.",
    ingredients: { "celery_root" => "600 g", "apple" => "1", "cream" => "250 ml", "gruyere" => "80 g" },
    recipe_level: 1,
    meal_prep_time: 75,
    tips: "Slice ingredients evenly for even cooking and bake until bubbling and golden on top.",
    steps: [
      { title: "Slice Thinly", content: "Use a mandoline to slice celery root and apple thinly." },
      { title: "Layer & Bake", content: "Layer in a dish with cream and cheese and bake until set and golden." },
      { title: "Rest", content: "Let rest briefly before serving." }
    ]
  },
  {
    title: "Seared Tuna Steak with Sesame & Yuzu Dressing",
    description: "Rare seared tuna with bright yuzu dressing and sesame crunch.",
    ingredients: { "tuna_steak" => "2", "sesame_seeds" => "2 tbsp", "yuzu_juice" => "2 tbsp", "soy" => "1 tbsp" },
    recipe_level: 1,
    meal_prep_time: 15,
    tips: "Sear tuna quickly on extremely hot pan for a clean rare center; slice against the grain and dress lightly with yuzu.",
    steps: [
      { title: "Toast Sesame", content: "Toast sesame seeds until fragrant." },
      { title: "Sear Tuna", content: "Sear tuna briefly on both sides for a rare center." },
      { title: "Dress", content: "Slice and drizzle with yuzu-soy dressing." }
    ]
  },
  {
    title: "Sichuan Twice-Cooked Pork",
    description: "Pork belly blanched then stir-fried with spicy Sichuan peppercorns and chilies.",
    ingredients: { "pork_belly" => "500 g", "doubanjiang" => "2 tbsp", "sichuan_pepper" => "1 tsp", "garlic" => "2 cloves" },
    recipe_level: 1,
    meal_prep_time: 60,
    tips: "Blanch pork to remove impurities, then slice and fry on high heat for crisp edges; balance spice with a touch of sugar.",
    steps: [
      { title: "Blanch & Slice", content: "Blanch pork belly and slice thinly." },
      { title: "Stir-Fry", content: "Fry with doubanjiang and aromatics until caramelized." },
      { title: "Finish", content: "Adjust seasoning and serve with rice." }
    ]
  },
  {
    title: "Oxford Comma Chocolate Tart (Intense)",
    description: "A dense, intense chocolate tart with a crisp pastry shell and ganache filling.",
    ingredients: { "dark_chocolate" => "300 g", "butter" => "150 g", "eggs" => "3", "sugar" => "100 g" },
    recipe_level: 2,
    meal_prep_time: 90,
    tips: "Temper ingredients gently and bake until set but slightly wobbly for the perfect texture; chill before slicing.",
    steps: [
      { title: "Make Shell", content: "Blind bake tart shell until golden." },
      { title: "Make Ganache", content: "Melt chocolate with butter and whisk with eggs and sugar." },
      { title: "Bake & Chill", content: "Bake gently and cool before serving." }
    ]
  },
  {
    title: "Hasselback Potatoes with Rosemary & Garlic",
    description: "Thinly sliced roast potatoes with crisp edges and soft centers, flavored with rosemary and garlic.",
    ingredients: { "potatoes" => "800 g", "butter" => "50 g", "rosemary" => "1 sprig", "garlic" => "2 cloves" },
    recipe_level: 0,
    meal_prep_time: 60,
    tips: "Slice potatoes thinly without cutting through, fan them and baste periodically while roasting for evenly crisped edges.",
    steps: [
      { title: "Slice Potatoes", content: "Thinly slice potatoes almost through to create a fan." },
      { title: "Season & Roast", content: "Brush with butter and roast until crisp." },
      { title: "Baste", content: "Baste occasionally with butter and garlic." }
    ]
  },
  {
    title: "Cured & Grilled Mackerel with Tomato Salad",
    description: "Quick-cured mackerel grilled and paired with a vibrant tomato and herb salad.",
    ingredients: { "mackerel" => "2 fillets", "tomato" => "3", "olive_oil" => "2 tbsp", "lemon" => "1" },
    recipe_level: 1,
    meal_prep_time: 25,
    tips: "Cure briefly with salt to firm flesh before grilling; serve with fresh, acidic tomato salad to balance oiliness.",
    steps: [
      { title: "Cure Fish", content: "Lightly cure mackerel in salt briefly and rinse." },
      { title: "Grill", content: "Grill until skin is crisp." },
      { title: "Assemble Salad", content: "Toss tomatoes with herbs and lemon and serve with fish." }
    ]
  },
  {
    title: "Cider-Glazed Pork Chop with Braised Red Cabbage",
    description: "Pan-seared pork chop with a sweet-tart cider glaze and braised red cabbage.",
    ingredients: { "pork_chop" => "2", "cider" => "150 ml", "red_cabbage" => "400 g", "apple" => "1" },
    recipe_level: 1,
    meal_prep_time: 60,
    tips: "Reduce cider into a syrupy glaze and balance braised cabbage with vinegar and sugar to taste.",
    steps: [
      { title: "Braised Cabbage", content: "Slowly braise cabbage with apple and vinegar until tender." },
      { title: "Sear Chops", content: "Sear pork chops and finish in oven." },
      { title: "Glaze & Serve", content: "Reduce cider to a glaze and brush over chops." }
    ]
  },
  {
    title: "Pear & Gorgonzola Tartlets",
    description: "Savory tartlets with ripe pear and tangy gorgonzola for appetizer bites.",
    ingredients: { "puff_pastry" => "1 sheet", "pear" => "2", "gorgonzola" => "80 g", "walnuts" => "20 g" },
    recipe_level: 0,
    meal_prep_time: 30,
    tips: "Slice pears thin and assemble tartlets with cheese; bake until pastry is golden and cheese bubbling.",
    steps: [
      { title: "Assemble Tartlets", content: "Place pear slices and gorgonzola on pastry rounds." },
      { title: "Bake", content: "Bake until pastry is golden and toppings are bubbling." },
      { title: "Serve", content: "Garnish with toasted walnuts." }
    ]
  },
  {
    title: "Chestnut & Porcini Soup",
    description: "Velvety soup of chestnuts and porcini with a hint of sherry for warmth.",
    ingredients: { "chestnuts" => "300 g", "porcini" => "30 g", "stock" => "800 ml", "sherry" => "1 tbsp" },
    recipe_level: 1,
    meal_prep_time: 60,
    tips: "Use roasted chestnuts for a deeper flavor and strain soup for a very smooth texture; finish with a splash of sherry.",
    steps: [
      { title: "Rehydrate Porcini", content: "Soak porcini in hot water and reserve." },
      { title: "Simmer Chestnuts", content: "Simmer chestnuts with stock and porcini, then blend." },
      { title: "Finish", content: "Add sherry and cream if desired and serve." }
    ]
  },
  {
    title: "Canelé (Classic French Pastry)",
    description: "Caramelized exterior with custardy interior—classic Bordeaux canelé.",
    ingredients: { "milk" => "500 ml", "vanilla" => "1 pod", "eggs" => "4", "sugar" => "200 g", "rum" => "2 tbsp" },
    recipe_level: 2,
    meal_prep_time: 1440,
    tips: "Use copper molds or well-seasoned silicone and bake at high heat for the first part to get the caramelized crust while the inside stays tender. Batter benefits from overnight rest.",
    steps: [
      { title: "Make Batter", content: "Heat milk with vanilla then whisk with eggs and sugar; add rum and rest batter." },
      { title: "Bake in Molds", content: "Fill molds and bake at high heat followed by moderate heat until crusted." },
      { title: "Unmold & Serve", content: "Cool briefly and unmold to enjoy crisp exterior and custardy inside." }
    ]
  }
] # end recipes_data (you provided these templates)

# Safety: ensure exactly 75 recipes (if fewer, duplicate variations)
if recipes_data.length < 75
  base = recipes_data.dup
  i = 0
  while recipes_data.length < 75
    copy = base[i % base.size].deep_dup rescue base[i % base.size].dup
    copy[:title] = "#{copy[:title]} (Variation #{(recipes_data.length - base.size) + 1})"
    recipes_data << copy
    i += 1
  end
elsif recipes_data.length > 75
  recipes_data = recipes_data.first(75)
end

# Create recipes and attach steps + reviews
puts "Creating #{recipes_data.length} recipes with detailed steps and reviews..."
recipes_data.each_with_index do |rdata, index|
  rec = Recipe.create!(
    title: rdata[:title],
    description: rdata[:description],
    ingredients: rdata[:ingredients],
    recipe_level: rdata[:recipe_level],
    user: user,
    meal_prep_time: rdata[:meal_prep_time],
    tips: rdata[:tips]
  )

  create_steps_for_recipe(rec, rdata[:steps])

  # Create 4..7 reviews per recipe (English)
  rand(4..7).times do
    Review.create!(
      title: REVIEW_TITLES.sample,
      comment: REVIEW_COMMENTS.sample,
      rate: rand(3..5),
      recipe: rec,
      user: [user, generic_user].sample
    )
  end

  puts "  Created recipe #{index + 1}/#{recipes_data.length}: #{rec.title}"
end

puts "Created #{Recipe.count} recipes with #{Step.count} steps and #{Review.count} reviews."

# ---------------------------
# CHATS & MESSAGES
# ---------------------------
puts "Creating example chat and messages..."
chat = Chat.create!(user: user, title: "Botifarra Ideas")
Message.create!(chat: chat, role: "user", content: "I have carrots, beetroot, and botifarra. What can I cook?")
Message.create!(chat: chat, role: "ai", content: "Here are some recipe ideas using those ingredients!")

# ---------------------------
# BADGES
# ---------------------------
puts "Creating badges..."

Badge.create!([
  { name: "Beginner Recipes", rule_key: "recipe_beginner", description: "Earned by completing Beginner-level recipes." },
  { name: "Intermediate Recipes", rule_key: "recipe_intermediate", description: "Earned by mastering Intermediate-level recipes." },
  { name: "Expert Recipes", rule_key: "recipe_expert", description: "Awarded for finishing challenging Expert-level recipes." },
  { name: "Saved Recipes", rule_key: "saved_recipes", description: "Earned by saving many recipes to your cookbook." },
  { name: "Skills Completed", rule_key: "skills_completed", description: "Unlocked by learning different cooking skills." },
  { name: "Consistency", rule_key: "streak", description: "Earned by being consistently active day after day." }
])

puts "Created #{Badge.count} badges."

# ---------------------------
# USER BADGES: pre-create blank user_badges to avoid null awarded_at errors
# ---------------------------
puts "Preparing placeholder user_badges for main user..."

Badge.find_each do |badge|
  UserBadge.find_or_create_by!(user: user, badge: badge) do |ub|
    ub.level = 0
    ub.awarded_at = Time.current
  end
end

puts "Created placeholder UserBadges for main user."

# Now set some requested badge levels for the main user (idempotent updates)
streak_badge = Badge.find_by(rule_key: "streak")
beginner_badge = Badge.find_by(rule_key: "recipe_beginner")
skills_badge = Badge.find_by(rule_key: "skills_completed")

UserBadge.find_by(user: user, badge: streak_badge)&.update!(level: 3, awarded_at: Time.current)
UserBadge.find_by(user: user, badge: beginner_badge)&.update!(level: 1, awarded_at: Time.current)
UserBadge.find_by(user: user, badge: skills_badge)&.update!(level: 2, awarded_at: Time.current)

puts "Assigned requested badge levels to #{user.username}."

# ---------------------------
# USER SKILLS (mark a few skills as completed for main user)
# ---------------------------
puts "Creating some user_skills for the main user..."
Skill.all.sample(6).each do |s|
  UserSkill.find_or_create_by!(user: user, skill: s) do |us|
    us.completed = true
  end
end
puts "User skills created."

# ---------------------------
# IMPORTANT: We ARE NOT creating UserRecipeCompletion entries here
# That prevents add_xp callbacks from modifying the main user's xp/level during seeding.
# ---------------------------

puts "Seed finished successfully!"
