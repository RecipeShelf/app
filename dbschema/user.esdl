module default {
  type User {
    property first_name -> str;

    property last_name -> str;

    property email -> str;

    multi link recipe_books -> RecipeBook {
      constraint exclusive;
      on target delete delete source;
    }

    multi link pantry -> Ingredient {
      property description -> str;

      property expiry -> datetime;

      property level -> IngredientLevel;
    }

    property external_id -> str;
  }
}
