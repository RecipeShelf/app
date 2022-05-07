module default {
  type Recipe {
    required property names -> array<str>;

    property description -> str;

    property servings -> str;

    property spice_level -> SpiceLevel;

    property total_time_in_minutes -> int16;

    property overnight_preparation -> bool;

    property region -> str {
      constraint one_of ('East Asia','Indian Subcontinent','Latin America and the Caribbean','Middle East','North America','North and West Africa','Northern Europe','South and East Africa','Southeast Asia','Southern Europe');
    }

    property cuisine -> str {
      constraint one_of ('American','Brazilian','British','Chinese','Cuban','Egyptian','Ethiopian','French','German','Greek','Indian Subcontinent','Indo-Chinese','Italian','Malaysian','Mexican','Modern','Moroccan','North Indian','South Indian','Southeast Asia','Spanish','Street Food','Thai','Turkish','Vietnamese');
    }

    multi property collections -> str {
      constraint one_of ('Breads','Breakfast','Burgers','Chutneys','Curries','Desserts','Dinner','Lunch','Main course','One-pot meals','Pasta','Pizza','Rice dishes','Salads','Side dishes','Snacks','Soups','Spice mixes and Condiments','Starters','Stews');
    }

    property image_id -> str;

    property ingredient_items -> array<json>;

    property recipe_steps -> array<json>;

    multi link ingredients -> Ingredient;

    multi link accompaniments -> Recipe;

    link chef -> User;

    required property approved -> bool {
      default := false;
    }

    required property last_modified -> datetime;

    property external_id -> str;
  }
}
