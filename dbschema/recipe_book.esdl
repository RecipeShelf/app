module default {
  type RecipeBook {
    required property name -> str;

    property description -> str;

    required multi link recipes -> Recipe;
  }
}
