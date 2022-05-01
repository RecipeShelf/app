module default {
  type User {
    property first_name => str {
      constraint max_len_value(64);
    }

    property last_name => str {
      constraint max_len_value(64);
    }

    property email => str {
      constraint max_len_value(64);
    }

    property recipe_books => RecipeBook {
      constraint exclusive;
    }

    property pantry => Ingredient {
      property description => str {
        constraint max_len_value(1024);
      }

      property expiry => datetime;

      property level => IngredientLevel;
    }
  }
}
