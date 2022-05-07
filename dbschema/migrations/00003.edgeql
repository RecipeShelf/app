CREATE MIGRATION m164spjykf2acllkwsylirwkkll3lotue2w6dfwo7sbdrcw5bsktvq
    ONTO m1eyexebewoylrcjfq5p4tsoadt2pyh4m26pivym2a3lkcvxa75opa
{
  ALTER TYPE default::Ingredient {
      ALTER PROPERTY external_id {
          CREATE CONSTRAINT std::exclusive;
      };
  };
  ALTER TYPE default::Recipe {
      ALTER PROPERTY external_id {
          CREATE CONSTRAINT std::exclusive;
      };
  };
  ALTER TYPE default::User {
      ALTER PROPERTY external_id {
          CREATE CONSTRAINT std::exclusive;
      };
  };
};
