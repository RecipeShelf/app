CREATE MIGRATION m17tpefsqlwxspbq2gy4p6mjw2rxgs2k4ko33u2t5f2bg5d2lu2mua
    ONTO initial
{
  CREATE TYPE default::Ingredient {
      CREATE PROPERTY category -> std::str {
          CREATE CONSTRAINT std::one_of('Alcohols and Other Liquids', 'Baked goods and Baking supplies', 'Condiments and Flavourings', 'Dairy, Eggs and Non-dairy Cheeses', 'Grains, Grain Products and Flours', 'Herbs and Spices', 'Legumes, Nuts and Seeds', 'Oils and Sweeteners', 'Preserves and Accompaniments', 'Vegetables and Fruits');
      };
      CREATE PROPERTY description -> std::str;
      CREATE REQUIRED PROPERTY last_modified -> std::datetime;
      CREATE REQUIRED PROPERTY names -> array<std::str>;
      CREATE REQUIRED PROPERTY vegan -> std::bool;
  };
  CREATE SCALAR TYPE default::SpiceLevel EXTENDING enum<Sweet, Mild, Medium, Hot>;
  CREATE TYPE default::Recipe {
      CREATE MULTI LINK ingredients -> default::Ingredient;
      CREATE MULTI LINK accompaniments -> default::Recipe;
      CREATE REQUIRED PROPERTY approved -> std::bool {
          SET default := false;
      };
      CREATE MULTI PROPERTY collections -> std::str {
          CREATE CONSTRAINT std::one_of('Breads', 'Breakfast', 'Burgers', 'Chutneys', 'Curries', 'Desserts', 'Dinner', 'Lunch', 'Main course', 'One-pot meals', 'Pasta', 'Pizza', 'Rice dishes', 'Salads', 'Side dishes', 'Snacks', 'Soups', 'Spice mixes and Condiments', 'Starters', 'Stews');
      };
      CREATE PROPERTY cuisine -> std::str {
          CREATE CONSTRAINT std::one_of('American', 'Brazilian', 'British', 'Chinese', 'Cuban', 'Egyptian', 'Ethiopian', 'French', 'German', 'Greek', 'Indian Subcontinent', 'Indo-Chinese', 'Italian', 'Malaysian', 'Mexican', 'Modern', 'Moroccan', 'North Indian', 'South Indian', 'Southeast Asia', 'Spanish', 'Street Food', 'Thai', 'Turkish', 'Vietnamese');
      };
      CREATE PROPERTY description -> std::str;
      CREATE PROPERTY image_id -> std::str;
      CREATE PROPERTY ingredient_items -> array<std::json>;
      CREATE REQUIRED PROPERTY last_modified -> std::datetime;
      CREATE REQUIRED PROPERTY names -> array<std::str>;
      CREATE PROPERTY overnight_preparation -> std::bool;
      CREATE PROPERTY recipe_steps -> array<std::json>;
      CREATE PROPERTY region -> std::str {
          CREATE CONSTRAINT std::one_of('East Asia', 'Indian Subcontinent', 'Latin America and the Caribbean', 'Middle East', 'North America', 'North and West Africa', 'Northern Europe', 'South and East Africa', 'Southeast Asia', 'Southern Europe');
      };
      CREATE PROPERTY servings -> std::str;
      CREATE PROPERTY spice_level -> default::SpiceLevel;
      CREATE PROPERTY total_time_in_minutes -> std::int16;
  };
  ALTER TYPE default::Ingredient {
      CREATE MULTI LINK ingredient_recipes := (.<ingredients[IS default::Recipe]);
  };
  CREATE TYPE default::RecipeBook {
      CREATE REQUIRED MULTI LINK recipes -> default::Recipe;
      CREATE PROPERTY description -> std::str;
      CREATE REQUIRED PROPERTY name -> std::str;
  };
  CREATE SCALAR TYPE default::IngredientLevel EXTENDING enum<Low, Medium, High>;
  CREATE TYPE default::User {
      CREATE MULTI LINK pantry -> default::Ingredient {
          CREATE PROPERTY description -> std::str;
          CREATE PROPERTY expiry -> std::datetime;
          CREATE PROPERTY level -> default::IngredientLevel;
      };
      CREATE MULTI LINK recipe_books -> default::RecipeBook {
          ON TARGET DELETE  DELETE SOURCE;
          CREATE CONSTRAINT std::exclusive;
      };
      CREATE PROPERTY email -> std::str;
      CREATE PROPERTY first_name -> std::str;
      CREATE PROPERTY last_name -> std::str;
  };
  ALTER TYPE default::Recipe {
      CREATE LINK chef -> default::User;
  };
};
