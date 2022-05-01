module default {
  type Recipe {
    required property names => array<str> {
      constraint max_len_value(64);
    }

    property description => str {
      constraint max_len_value(1024);
    }

    property servings => str {
      constraint max_len_value(64);
    }

    property spice_level => SpiceLevel;

    property total_time_in_minutes => int16;

    property overnight_preparation => bool;

    property region => str {
      constraint one_of ('East Asia','Indian Subcontinent','Latin America and the Caribbean','Middle East','North America','North and West Africa','Northern Europe','South and East Africa','Southeast Asia','Southern Europe');
    }

    property cuisine => string {
      constraint one_of ('American','Brazilian','British','Chinese','Cuban','Egyptian','Ethiopian','French','German','Greek','Indian Subcontinent','Indo-Chinese','Italian','Malaysian','Mexican','Modern','Moroccan','North Indian','South Indian','Southeast Asia','Spanish','Street Food','Thai','Turkish','Vietnamese');
    }

    multi property collections => string {
      constraint one_of ('Breads','Breakfast','Burgers','Chutneys','Curries','Desserts','Dinner','Lunch','Main course','One-pot meals','Pasta','Pizza','Rice dishes','Salads','Side dishes','Snacks','Soups','Spice mixes and Condiments','Starters','Stews');
    }

    property image_id => str {
      constraint max_len_value(8);
    }

    property ingredient_items => array<json>;

    property recipe_steps => array<json>;

    multi link ingredients => Ingredient;

    multi link accompaniments => Recipe;

    link chef => User;

    required property approved => bool {
      default := false;
    }

    required property last_modified => datetime;
  }
}