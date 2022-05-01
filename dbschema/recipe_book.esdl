module default {
  type RecipeBook {
    required property name => str {
      constraint max_len_value(64);
    }

    property description => str {
      constraint max_len_value(1024);
    }

    required multi link recipes => Recipe;
  }
}
