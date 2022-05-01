module default {
  type Ingredient {
    required property names -> array<str>;

    property description -> str;

    property category -> str {
      constraint one_of ('Alcohols and Other Liquids','Baked goods and Baking supplies','Condiments and Flavourings','Dairy, Eggs and Non-dairy Cheeses','Grains, Grain Products and Flours','Herbs and Spices','Legumes, Nuts and Seeds','Oils and Sweeteners','Preserves and Accompaniments','Vegetables and Fruits');
    }

    required property vegan -> bool;

    required property last_modified -> datetime;

    multi link ingredient_recipes := .<ingredients[is Recipe];
  }
}
